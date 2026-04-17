const std = @import("std");
const Allocator = std.mem.Allocator;
const candidate_mod = @import("candidate.zig");
const utilities = @import("utilities.zig");
const variants_mod = @import("variants.zig");
const emitter_mod = @import("emitter.zig");
const theme_mod = @import("theme.zig");
const Declaration = emitter_mod.Declaration;
const Rule = emitter_mod.Rule;
const Theme = theme_mod.Theme;

// ─── Compiled Rule (with sort key) ─────────────────────────────────────────

const CompiledRule = struct {
    rule: Rule,
    variant_order: u64,
    raw: []const u8,
};

// ─── Context ───────────────────────────────────────────────────────────────

pub const Context = struct {
    alloc: Allocator,
    theme: Theme,
    rules: std.ArrayList(CompiledRule),
    seen: std.StringHashMap(void),
    include_preflight: bool,
    minify: bool,
    custom_css: ?[]const u8,
    custom_utilities_json: ?[]const u8,
    custom_utility_map: std.StringHashMap([]const u8),
    at_properties: std.ArrayList(emitter_mod.AtProperty),
    keyframes: std.ArrayList(emitter_mod.Keyframes),
    plugin_css: ?[]const u8,

    pub fn init(alloc: Allocator, include_preflight: bool, minify: bool, custom_css: ?[]const u8, custom_utilities_json: ?[]const u8, plugin_css: ?[]const u8) Context {
        return Context{
            .alloc = alloc,
            .theme = Theme.init(alloc),
            .rules = .empty,
            .seen = std.StringHashMap(void).init(alloc),
            .include_preflight = include_preflight,
            .minify = minify,
            .custom_css = custom_css,
            .custom_utilities_json = custom_utilities_json,
            .custom_utility_map = std.StringHashMap([]const u8).init(alloc),
            .at_properties = .empty,
            .keyframes = .empty,
            .plugin_css = plugin_css,
        };
    }

    /// Parse custom utilities JSON into the lookup map.
    /// Format: {"btn-primary":"background:blue;color:white","link":"color:inherit"}
    pub fn loadCustomUtilities(self: *Context) !void {
        const json_str = self.custom_utilities_json orelse return;
        if (json_str.len == 0) return;

        var parsed = std.json.parseFromSlice(std.json.Value, self.alloc, json_str, .{}) catch return;
        defer parsed.deinit();

        if (parsed.value != .object) return;

        var iter = parsed.value.object.iterator();
        while (iter.next()) |entry| {
            if (entry.value_ptr.* == .string) {
                const name = try self.alloc.dupe(u8, entry.key_ptr.*);
                const css = try self.alloc.dupe(u8, entry.value_ptr.*.string);
                try self.custom_utility_map.put(name, css);
            }
        }
    }

    /// Parse plugin CSS to extract theme color variables and component CSS.
    /// Scans for :root, [data-theme=...] blocks containing --color-* declarations,
    /// registers them as theme colors (so bg-*, text-*, border-* etc. work),
    /// and passes through all CSS (including component classes) as custom_css.
    pub fn loadPluginCss(self: *Context) !void {
        const css = self.plugin_css orelse return;
        if (css.len == 0) return;

        // Parse CSS variable definitions from :root and [data-theme] blocks
        // and register --color-* variables as theme colors
        try self.extractPluginThemeColors(css);

        // Append plugin CSS (component classes, theme variable blocks, etc.)
        // after any existing custom_css, minifying whitespace
        const minified = try minifyCss(self.alloc, css);
        if (self.custom_css) |existing| {
            self.custom_css = try std.fmt.allocPrint(self.alloc, "{s}{s}", .{ existing, minified });
        } else {
            self.custom_css = minified;
        }
    }

    /// Extract --color-* variable definitions from CSS blocks like :root { } and
    /// [data-theme="..."] { }, and register them into the theme so utilities like
    /// bg-primary, text-secondary, etc. are generated.
    fn extractPluginThemeColors(self: *Context, css: []const u8) !void {
        var pos: usize = 0;

        while (pos < css.len) {
            // Skip whitespace
            while (pos < css.len and isWhitespace(css[pos])) pos += 1;
            if (pos >= css.len) break;

            // Skip CSS comments
            if (pos + 1 < css.len and css[pos] == '/' and css[pos + 1] == '*') {
                pos += 2;
                while (pos + 1 < css.len) {
                    if (css[pos] == '*' and css[pos + 1] == '/') {
                        pos += 2;
                        break;
                    }
                    pos += 1;
                }
                continue;
            }

            // Look for a block: find the next '{'
            const block_start = std.mem.indexOfScalarPos(u8, css, pos, '{') orelse break;
            const selector = std.mem.trim(u8, css[pos..block_start], " \t\n\r");

            // Find matching closing brace (handle nesting)
            const body_start = block_start + 1;
            var depth: usize = 1;
            var body_end: usize = body_start;
            while (body_end < css.len and depth > 0) {
                if (css[body_end] == '{') depth += 1;
                if (css[body_end] == '}') depth -= 1;
                if (depth > 0) body_end += 1;
            }

            const body = css[body_start..body_end];

            // Check if this is a :root or [data-theme] block
            if (std.mem.eql(u8, selector, ":root") or
                std.mem.startsWith(u8, selector, "[data-theme"))
            {
                // Parse CSS declarations within this block for --color-* variables
                try self.parseColorVariables(body);
            }

            // Move past the closing brace
            pos = if (body_end < css.len) body_end + 1 else css.len;
        }
    }

    /// Parse CSS declarations within a block body to find --color-* variable definitions.
    /// E.g., "--color-primary: oklch(62.3% 0.214 259.815);" → registers as theme color.
    fn parseColorVariables(self: *Context, body: []const u8) !void {
        var pos: usize = 0;

        while (pos < body.len) {
            // Skip whitespace
            while (pos < body.len and isWhitespace(body[pos])) pos += 1;
            if (pos >= body.len) break;

            // Skip comments
            if (pos + 1 < body.len and body[pos] == '/' and body[pos + 1] == '*') {
                pos += 2;
                while (pos + 1 < body.len) {
                    if (body[pos] == '*' and body[pos + 1] == '/') {
                        pos += 2;
                        break;
                    }
                    pos += 1;
                }
                continue;
            }

            // Find the property name (up to ':')
            const colon_pos = std.mem.indexOfScalarPos(u8, body, pos, ':') orelse break;
            const property = std.mem.trim(u8, body[pos..colon_pos], " \t\n\r");

            // Find the value (up to ';' or end of block)
            const val_start = colon_pos + 1;
            const semicolon_pos = std.mem.indexOfScalarPos(u8, body, val_start, ';') orelse body.len;
            const value = std.mem.trim(u8, body[val_start..semicolon_pos], " \t\n\r");

            // If this is a --color-* variable, register it in the theme
            if (std.mem.startsWith(u8, property, "--color-")) {
                const duped_name = try self.alloc.dupe(u8, property);
                const duped_value = try self.alloc.dupe(u8, value);
                try self.theme.variables.put(duped_name, duped_value);
            }

            // Move past the semicolon
            pos = if (semicolon_pos < body.len) semicolon_pos + 1 else body.len;
        }
    }

    pub fn deinit(self: *Context) void {
        self.theme.deinit();
        self.rules.deinit(self.alloc);
        self.seen.deinit();
        self.at_properties.deinit(self.alloc);
        self.keyframes.deinit(self.alloc);
    }

    pub fn registerProperty(self: *Context, prop: emitter_mod.AtProperty) !void {
        // Deduplicate by name
        for (self.at_properties.items) |existing| {
            if (std.mem.eql(u8, existing.name, prop.name)) return;
        }
        try self.at_properties.append(self.alloc, prop);
    }

    pub fn registerKeyframes(self: *Context, kf: emitter_mod.Keyframes) !void {
        for (self.keyframes.items) |existing| {
            if (std.mem.eql(u8, existing.name, kf.name)) return;
        }
        try self.keyframes.append(self.alloc, kf);
    }

    /// Load default theme values.
    pub fn loadDefaults(self: *Context) !void {
        try self.theme.loadDefaults();
    }

    /// Apply user theme overrides from JSON.
    pub fn applyThemeJson(self: *Context, json: []const u8) !void {
        try self.theme.parseJson(json);
    }

    /// Process a single candidate string.
    pub fn process(self: *Context, raw: []const u8) !void {
        // Deduplicate
        const gop = try self.seen.getOrPut(raw);
        if (gop.found_existing) return;

        // Parse the candidate
        const parsed = try candidate_mod.parseCandidate(
            self.alloc,
            raw,
            &isStaticWrapper,
            &isFunctionalWrapper,
            &isVariantWrapper,
            &isFunctionalVariantRootWrapper,
        ) orelse {
            // Not a known Tailwind utility — check custom utilities
            try self.processCustomUtility(raw);
            return;
        };

        // Reject bare functional utilities without a value (unless they have defaults)
        if (parsed.kind == .functional and parsed.value == null) {
            if (!utilities.hasDefaultValue(parsed.root)) return;
        }

        // Reject modifiers on utilities that don't support them
        if (parsed.modifier != null) {
            // Allow fractions: when value is named, modifier is named, and
            // the denominator is a positive integer, this is a fraction (e.g. w-1/2)
            const is_fraction = blk: {
                if (parsed.value) |val| {
                    if (val.fraction != null and parsed.modifier.?.kind == .named) {
                        // Only allow fractions for utilities that support them
                        if (!utilities.supportsFraction(parsed.root)) break :blk false;
                        // Validate both numerator and denominator are valid
                        // Numerator: positive integer or valid decimal (e.g., 8.5)
                        var num_valid = val.value.len > 0;
                        var num_has_dot = false;
                        for (val.value) |c| {
                            if (c == '.') {
                                if (num_has_dot) { num_valid = false; break; }
                                num_has_dot = true;
                            } else if (c < '0' or c > '9') {
                                num_valid = false;
                                break;
                            }
                        }
                        if (!num_valid) break :blk false;
                        // Denominator: positive integer
                        const denom = parsed.modifier.?.value;
                        var all_digits = denom.len > 0;
                        for (denom) |c| {
                            if (c < '0' or c > '9') {
                                all_digits = false;
                                break;
                            }
                        }
                        break :blk all_digits;
                    }
                }
                break :blk false;
            };

            if (!is_fraction) {
                switch (parsed.kind) {
                    .static => return, // Static utilities never accept modifiers
                    .functional => {
                        // Only color/gradient utilities accept modifiers
                        if (!utilities.supportsModifier(parsed.root)) return;
                        // Validate named modifier values are valid non-negative numbers
                        // Named modifiers like /50, /2.5 are valid; /foo, /hsl are not
                        // Exception: "text" uses modifiers for line-height (accepts named values)
                        if (parsed.modifier) |mod| {
                            if (mod.kind == .named and !utilities.modifierAcceptsNamed(parsed.root)) {
                                const f = std.fmt.parseFloat(f64, mod.value) catch return;
                                if (f < 0) return;
                            }
                        }
                    },
                    .arbitrary => {}, // Arbitrary properties accept modifiers
                }
            }
        }

        // Reject negative prefix on utilities that don't support it
        if (parsed.negative) {
            if (!utilities.supportsNegative(parsed.root)) return;
        }

        // Resolve to CSS declarations
        const declarations = try self.resolveDeclarations(&parsed) orelse return;

        // Scan declaration values for var(--...) references to theme variables
        // and mark them as used so they appear in @layer theme output.
        for (declarations) |decl| {
            self.markVarReferences(decl.value);
        }

        // Register @property declarations for this utility
        const props = utilities.getRequiredProperties(parsed.root);
        for (props) |prop| {
            try self.registerProperty(prop);
        }

        // Register @keyframes for this utility
        const kfs = utilities.getRequiredKeyframes(parsed.root);
        for (kfs) |kf| {
            try self.registerKeyframes(kf);
        }

        // Apply important flag
        var final_decls = declarations;
        if (parsed.important) {
            var important_decls = try self.alloc.alloc(Declaration, declarations.len);
            for (declarations, 0..) |decl, i| {
                important_decls[i] = Declaration{
                    .property = decl.property,
                    .value = decl.value,
                    .important = true,
                };
            }
            final_decls = important_decls;
        }

        // Build the escaped selector
        const escaped = try emitter_mod.escapeCssIdentifier(self.alloc, raw);
        const selector = try std.fmt.allocPrint(self.alloc, ".{s}", .{escaped});

        // Space utilities: use CSS nesting with :where(& > :not(:last-child))
        // .space-y-4 { :where(& > :not(:last-child)) { margin-block-end: value } }
        var nested_children: ?[]const Rule = null;
        if (final_decls.len == 1 and std.mem.eql(u8, final_decls[0].property, "__space_value")) {
            const space_value = final_decls[0].value;
            const is_y = std.mem.indexOf(u8, parsed.root, "space-y") != null;
            const reverse_var = if (is_y) "--tw-space-y-reverse" else "--tw-space-x-reverse";
            const margin_start_prop = if (is_y) "margin-block-start" else "margin-inline-start";
            const margin_end_prop = if (is_y) "margin-block-end" else "margin-inline-end";

            var space_decls = try self.alloc.alloc(Declaration, 3);
            space_decls[0] = Declaration{ .property = reverse_var, .value = "0" };
            space_decls[1] = Declaration{
                .property = margin_start_prop,
                .value = try std.fmt.allocPrint(self.alloc, "calc({s} * var({s}))", .{ space_value, reverse_var }),
            };
            space_decls[2] = Declaration{
                .property = margin_end_prop,
                .value = try std.fmt.allocPrint(self.alloc, "calc({s} * calc(1 - var({s})))", .{ space_value, reverse_var }),
            };
            final_decls = &.{};
            var children = try self.alloc.alloc(Rule, 1);
            children[0] = Rule{ .kind = .style, .selector = ":where(& > :not(:last-child))", .declarations = space_decls };
            nested_children = children;
        }

        // All divide-* utilities use CSS nesting with :where(& > :not(:last-child))
        if (std.mem.startsWith(u8, parsed.root, "divide") and
            !std.mem.eql(u8, final_decls[0].property, "__divide_value"))
        {
            var children = try self.alloc.alloc(Rule, 1);
            children[0] = Rule{ .kind = .style, .selector = ":where(& > :not(:last-child))", .declarations = final_decls };
            final_decls = &.{};
            nested_children = children;
        }

        // Divide width utilities: use CSS nesting
        if (final_decls.len == 1 and std.mem.eql(u8, final_decls[0].property, "__divide_value")) {
            const divide_value = final_decls[0].value;
            const is_y = std.mem.indexOf(u8, parsed.root, "divide-y") != null;
            const reverse_var = if (is_y) "--tw-divide-y-reverse" else "--tw-divide-x-reverse";

            var divide_decls: []Declaration = undefined;
            if (is_y) {
                divide_decls = try self.alloc.alloc(Declaration, 5);
                divide_decls[0] = Declaration{ .property = reverse_var, .value = "0" };
                divide_decls[1] = Declaration{ .property = "border-bottom-style", .value = "var(--tw-border-style)" };
                divide_decls[2] = Declaration{ .property = "border-top-style", .value = "var(--tw-border-style)" };
                divide_decls[3] = Declaration{
                    .property = "border-top-width",
                    .value = try std.fmt.allocPrint(self.alloc, "calc({s} * var({s}))", .{ divide_value, reverse_var }),
                };
                divide_decls[4] = Declaration{
                    .property = "border-bottom-width",
                    .value = try std.fmt.allocPrint(self.alloc, "calc({s} * calc(1 - var({s})))", .{ divide_value, reverse_var }),
                };
            } else {
                divide_decls = try self.alloc.alloc(Declaration, 5);
                divide_decls[0] = Declaration{ .property = reverse_var, .value = "0" };
                divide_decls[1] = Declaration{ .property = "border-right-style", .value = "var(--tw-border-style)" };
                divide_decls[2] = Declaration{ .property = "border-left-style", .value = "var(--tw-border-style)" };
                divide_decls[3] = Declaration{
                    .property = "border-right-width",
                    .value = try std.fmt.allocPrint(self.alloc, "calc({s} * var({s}))", .{ divide_value, reverse_var }),
                };
                divide_decls[4] = Declaration{
                    .property = "border-left-width",
                    .value = try std.fmt.allocPrint(self.alloc, "calc({s} * calc(1 - var({s})))", .{ divide_value, reverse_var }),
                };
            }
            final_decls = &.{};
            var children = try self.alloc.alloc(Rule, 1);
            children[0] = Rule{ .kind = .style, .selector = ":where(& > :not(:last-child))", .declarations = divide_decls };
            nested_children = children;
        }

        // Create base rule
        var base_rule = Rule{
            .kind = .style,
            .selector = selector,
            .declarations = final_decls,
            .children = nested_children orelse &.{},
        };

        // Apply variants
        if (parsed.variants.len > 0) {
            base_rule = try variants_mod.applyVariants(
                self.alloc,
                base_rule,
                parsed.variants,
                &self.theme,
                raw,
            );
        }

        // Compute variant sort order
        var variant_order: u64 = 0;
        for (parsed.variants) |v| {
            const order = variants_mod.variantOrder(v.root);
            variant_order = variant_order * 1000 + order;
        }

        try self.rules.append(self.alloc, CompiledRule{
            .rule = base_rule,
            .variant_order = variant_order,
            .raw = raw,
        });

        // Special handling for container: add responsive max-width rules
        if (std.mem.eql(u8, parsed.root, "container")) {
            const container_escaped = try emitter_mod.escapeCssIdentifier(self.alloc, raw);
            const container_sel = try std.fmt.allocPrint(self.alloc, ".{s}", .{container_escaped});

            const breakpoint_names = [_][]const u8{ "sm", "md", "lg", "xl", "2xl" };
            for (breakpoint_names) |bp_name| {
                if (self.theme.getBreakpoint(bp_name)) |bp_value| {
                    const max_w_decl = try self.alloc.alloc(Declaration, 1);
                    max_w_decl[0] = Declaration{ .property = "max-width", .value = bp_value };

                    const inner_rule = Rule{
                        .kind = .style,
                        .selector = container_sel,
                        .declarations = max_w_decl,
                    };

                    const media = try std.fmt.allocPrint(self.alloc, "@media (width>={s})", .{bp_value});
                    const children = try self.alloc.alloc(Rule, 1);
                    children[0] = inner_rule;

                    const media_rule = Rule{
                        .kind = .media,
                        .at_rule = media,
                        .children = children,
                    };

                    try self.rules.append(self.alloc, CompiledRule{
                        .rule = media_rule,
                        .variant_order = variant_order + 1,
                        .raw = raw,
                    });
                }
            }
        }
    }

    /// Process a candidate as a custom utility.
    /// Custom utilities get selector escaping and are emitted in @layer utilities.
    fn processCustomUtility(self: *Context, raw: []const u8) !void {
        // Look up the raw candidate in the custom utility map
        // For "btn-primary", look up "btn-primary"
        // For "hover:btn-primary", split variant and look up "btn-primary"
        var base = raw;
        var variant_prefix: ?[]const u8 = null;

        // Simple variant detection: split on last ':'
        if (std.mem.lastIndexOfScalar(u8, raw, ':')) |colon_idx| {
            base = raw[colon_idx + 1 ..];
            variant_prefix = raw[0..colon_idx];
        }

        const css_text = self.custom_utility_map.get(base) orelse return;

        // Parse CSS text into declarations: "background:blue;color:white"
        var decl_list: [32]Declaration = undefined;
        var decl_count: usize = 0;
        var decl_iter = std.mem.splitScalar(u8, css_text, ';');
        while (decl_iter.next()) |part| {
            const trimmed = std.mem.trim(u8, part, " ");
            if (trimmed.len == 0) continue;
            if (std.mem.indexOfScalar(u8, trimmed, ':')) |ci| {
                if (decl_count < 32) {
                    decl_list[decl_count] = Declaration{
                        .property = std.mem.trim(u8, trimmed[0..ci], " "),
                        .value = std.mem.trim(u8, trimmed[ci + 1 ..], " "),
                    };
                    decl_count += 1;
                }
            }
        }
        if (decl_count == 0) return;

        const decls = try self.alloc.alloc(Declaration, decl_count);
        @memcpy(decls, decl_list[0..decl_count]);

        // Build escaped selector
        const escaped = try emitter_mod.escapeCssIdentifier(self.alloc, raw);
        const selector = try std.fmt.allocPrint(self.alloc, ".{s}", .{escaped});

        var rule = Rule{
            .kind = .style,
            .selector = selector,
            .declarations = decls,
        };

        // Apply variant if present (simple single-variant support)
        if (variant_prefix) |vp| {
            if (variants_mod.isVariant(vp)) {
                const variant = candidate_mod.Variant{
                    .kind = .static,
                    .root = vp,
                };
                const variants = try self.alloc.alloc(candidate_mod.Variant, 1);
                variants[0] = variant;
                rule = try variants_mod.applyVariants(
                    self.alloc,
                    rule,
                    variants,
                    &self.theme,
                    raw,
                );
            }
        }

        try self.rules.append(self.alloc, CompiledRule{
            .rule = rule,
            .variant_order = if (variant_prefix) |vp| @as(u64, variants_mod.variantOrder(vp)) else 0,
            .raw = raw,
        });
    }

    /// Resolve a parsed candidate to CSS declarations.
    fn resolveDeclarations(self: *Context, parsed: *const candidate_mod.Candidate) !?[]const Declaration {
        switch (parsed.kind) {
            .static => {
                return utilities.lookupStatic(parsed.root);
            },
            .functional => {
                return utilities.resolveFunctional(
                    self.alloc,
                    parsed.root,
                    parsed.value,
                    parsed.modifier,
                    &self.theme,
                    parsed.negative,
                );
            },
            .arbitrary => {
                // Arbitrary property: [color:red]
                if (parsed.property) |prop| {
                    if (parsed.value) |val| {
                        const decls = try self.alloc.alloc(Declaration, 1);
                        decls[0] = Declaration{
                            .property = prop,
                            .value = val.value,
                        };
                        return decls;
                    }
                }
                return null;
            },
        }
    }

    /// Resolve a single utility class name to its CSS declarations (property:value pairs).
    /// This is used by @apply processing to resolve each class independently.
    /// Returns null if the class cannot be resolved.
    /// Scan a CSS value string for var(--...) references and mark the
    /// referenced theme variables as used so they appear in @layer theme.
    fn markVarReferences(self: *Context, value: []const u8) void {
        var pos: usize = 0;
        while (pos + 6 < value.len) {
            if (std.mem.eql(u8, value[pos .. pos + 6], "var(--")) {
                const start = pos + 4; // start of "--..."
                var end = start;
                // Find the closing ) or , (for fallback)
                while (end < value.len and value[end] != ')' and value[end] != ',') {
                    end += 1;
                }
                if (end > start) {
                    const var_name = value[start..end];
                    if (self.theme.get(var_name) != null) {
                        self.theme.markUsed(self.alloc.dupe(u8, var_name) catch return);
                    }
                }
                pos = end;
            } else {
                pos += 1;
            }
        }
    }

    fn resolveClassDeclarations(self: *Context, class_name: []const u8) !?[]const Declaration {
        // Parse the candidate
        const parsed = try candidate_mod.parseCandidate(
            self.alloc,
            class_name,
            &isStaticWrapper,
            &isFunctionalWrapper,
            &isVariantWrapper,
            &isFunctionalVariantRootWrapper,
        ) orelse return null;

        // Reject bare functional utilities without a value (unless they have defaults)
        if (parsed.kind == .functional and parsed.value == null) {
            if (!utilities.hasDefaultValue(parsed.root)) return null;
        }

        // We don't handle variants in @apply — just the base utility
        // Reject negative prefix on utilities that don't support it
        if (parsed.negative) {
            if (!utilities.supportsNegative(parsed.root)) return null;
        }

        // Resolve to CSS declarations
        return try self.resolveDeclarations(&parsed);
    }

    /// Process @apply directives and theme() function calls in custom CSS.
    /// Returns a new string with all directives resolved, or the original if none found.
    fn processCustomCss(self: *Context) !?[]const u8 {
        const css = self.custom_css orelse return null;
        if (css.len == 0) return null;

        // First pass: resolve theme() calls
        const themed_css = try self.resolveThemeCalls(css);

        // Second pass: resolve @apply directives
        const result = try self.resolveApplyDirectives(themed_css);

        return result;
    }

    /// Resolve all theme() function calls in a CSS string.
    /// theme(colors.blue.900) → the resolved value from the theme.
    fn resolveThemeCalls(self: *Context, css: []const u8) ![]const u8 {
        // Quick check: if no "theme(" present, return as-is
        if (std.mem.indexOf(u8, css, "theme(") == null) return css;

        var result: std.ArrayList(u8) = .empty;
        var pos: usize = 0;

        while (pos < css.len) {
            if (pos + 6 <= css.len and std.mem.eql(u8, css[pos .. pos + 6], "theme(")) {
                // Find the closing paren
                const start = pos + 6;
                var depth: usize = 1;
                var end: usize = start;
                while (end < css.len and depth > 0) {
                    if (css[end] == '(') depth += 1;
                    if (css[end] == ')') depth -= 1;
                    if (depth > 0) end += 1;
                }

                if (depth == 0) {
                    const path = std.mem.trim(u8, css[start..end], " \t");

                    // Convert dot-path to CSS variable name
                    // e.g., "colors.blue.900" → "--color-blue-900"
                    // e.g., "spacing" → "--spacing"
                    if (self.resolveThemePath(path)) |value| {
                        try result.appendSlice(self.alloc, value);
                    } else {
                        // If unresolved, keep original
                        try result.appendSlice(self.alloc, css[pos .. end + 1]);
                    }
                    pos = end + 1;
                } else {
                    // Malformed — keep as-is
                    try result.append(self.alloc, css[pos]);
                    pos += 1;
                }
            } else {
                try result.append(self.alloc, css[pos]);
                pos += 1;
            }
        }

        return result.items;
    }

    /// Map a theme() dot-path to a CSS variable name and look up its value.
    /// E.g., "colors.blue.900" → look up "--color-blue-900"
    ///       "spacing" → look up "--spacing"
    ///       "borderRadius.lg" → look up "--radius-lg"
    ///       "fontSize.lg" → look up "--text-lg"
    fn resolveThemePath(self: *Context, raw_path: []const u8) ?[]const u8 {
        // Handle opacity modifier: "colors.red.500 / 50%"
        var path = raw_path;
        var opacity: ?[]const u8 = null;
        if (std.mem.indexOf(u8, raw_path, " / ")) |slash_pos| {
            path = std.mem.trim(u8, raw_path[0..slash_pos], " \t");
            opacity = std.mem.trim(u8, raw_path[slash_pos + 3 ..], " \t");
        }

        // CSS variable shorthand: theme(--color-red-500) → look up directly
        if (std.mem.startsWith(u8, path, "--")) {
            if (self.theme.get(path)) |value| {
                self.theme.markUsed(self.alloc.dupe(u8, path) catch return value);
                return self.maybeApplyOpacity(value, opacity);
            }
            return null;
        }

        var buf: [512]u8 = undefined;
        var buf_len: usize = 0;

        // Split on dots
        var parts: [16][]const u8 = undefined;
        var part_count: usize = 0;
        var iter = std.mem.splitScalar(u8, path, '.');
        while (iter.next()) |part| {
            if (part_count < 16) {
                parts[part_count] = part;
                part_count += 1;
            }
        }

        if (part_count == 0) return null;

        // Map the first segment (namespace) to a CSS variable prefix
        const namespace = parts[0];
        const prefix = themeNamespaceToPrefix(namespace);

        // Build the variable name: prefix + remaining segments joined with "-"
        @memcpy(buf[0..prefix.len], prefix);
        buf_len = prefix.len;

        for (parts[1..part_count]) |part| {
            if (buf_len + 1 + part.len > buf.len) return null;
            buf[buf_len] = '-';
            buf_len += 1;
            @memcpy(buf[buf_len .. buf_len + part.len], part);
            buf_len += part.len;
        }

        const var_name = buf[0..buf_len];

        // Look up in theme
        if (self.theme.get(var_name)) |value| {
            // Mark as used for tree-shaking
            self.theme.markUsed(self.alloc.dupe(u8, var_name) catch return value);
            return self.maybeApplyOpacity(value, opacity);
        }

        return null;
    }

    /// Apply an opacity modifier to a resolved color value.
    /// E.g., "oklch(63.7% 0.237 25.331)" with "50%" → "oklch(63.7% 0.237 25.331 / 50%)"
    fn maybeApplyOpacity(self: *Context, value: []const u8, opacity: ?[]const u8) ?[]const u8 {
        const op = opacity orelse return value;
        // If value is an oklch/rgb/hsl function, inject opacity before the closing paren
        if (std.mem.lastIndexOfScalar(u8, value, ')')) |close| {
            return std.fmt.allocPrint(self.alloc, "{s} / {s})", .{ value[0..close], op }) catch return value;
        }
        // For hex or other values, use color-mix as fallback
        return std.fmt.allocPrint(self.alloc, "color-mix(in oklab,{s} {s},transparent)", .{ value, op }) catch return value;
    }

    /// Map theme() namespace to CSS variable prefix.
    fn themeNamespaceToPrefix(namespace: []const u8) []const u8 {
        const map = std.StaticStringMap([]const u8).initComptime(.{
            .{ "colors", "--color" },
            .{ "spacing", "--spacing" },
            .{ "fontFamily", "--font" },
            .{ "fontSize", "--text" },
            .{ "fontWeight", "--font-weight" },
            .{ "letterSpacing", "--tracking" },
            .{ "lineHeight", "--leading" },
            .{ "borderRadius", "--radius" },
            .{ "boxShadow", "--shadow" },
            .{ "insetShadow", "--inset-shadow" },
            .{ "dropShadow", "--drop-shadow" },
            .{ "blur", "--blur" },
            .{ "breakpoints", "--breakpoint" },
            .{ "maxWidth", "--max-width" },
            .{ "transitionDuration", "--duration" },
            .{ "transitionProperty", "--transition-property" },
            .{ "animation", "--animate" },
            .{ "ease", "--ease" },
            .{ "perspective", "--perspective" },
            .{ "aspectRatio", "--aspect" },
            .{ "textShadow", "--text-shadow" },
        });
        return map.get(namespace) orelse "--unknown";
    }

    /// Resolve all @apply directives in a CSS string.
    /// @apply font-bold py-4 px-8; → resolved declarations inline.
    fn resolveApplyDirectives(self: *Context, css: []const u8) ![]const u8 {
        // Quick check: if no "@apply" present, return as-is
        if (std.mem.indexOf(u8, css, "@apply ") == null) return css;

        var result: std.ArrayList(u8) = .empty;
        // Collect variant rules to append after each rule block
        var variant_rules: std.ArrayList(u8) = .empty;
        var pos: usize = 0;
        // Track current selector for variant rule generation
        var current_selector: ?[]const u8 = null;

        while (pos < css.len) {
            // Track selector: when we see something like ".btn {", capture ".btn"
            if (css[pos] == '{') {
                // Look backwards for the selector
                const sel_end = pos;
                var sel_start = if (pos > 0) pos - 1 else 0;
                while (sel_start > 0 and css[sel_start] != '}' and css[sel_start] != ';' and css[sel_start] != '{') {
                    sel_start -= 1;
                }
                if (sel_start > 0 or css[sel_start] == '}' or css[sel_start] == ';') sel_start += 1;
                const sel = std.mem.trim(u8, css[sel_start..sel_end], " \t\n\r");
                if (sel.len > 0) current_selector = sel;
                try result.append(self.alloc, css[pos]);
                pos += 1;
                continue;
            }

            // When a rule block closes, append any collected variant rules
            if (css[pos] == '}') {
                try result.append(self.alloc, css[pos]);
                pos += 1;

                if (variant_rules.items.len > 0) {
                    try result.appendSlice(self.alloc, variant_rules.items);
                    variant_rules.clearRetainingCapacity();
                }
                current_selector = null;
                continue;
            }

            // Look for @apply at current position
            if (pos + 7 <= css.len and std.mem.eql(u8, css[pos .. pos + 7], "@apply ")) {
                // Find the end of the @apply directive (semicolon or closing brace)
                const start = pos + 7;
                var end = start;
                while (end < css.len and css[end] != ';' and css[end] != '}') {
                    end += 1;
                }

                const class_list = std.mem.trim(u8, css[start..end], " \t\n\r");

                // Split class names on whitespace
                var class_iter = std.mem.tokenizeAny(u8, class_list, " \t\n\r");
                var first = true;

                while (class_iter.next()) |class_name| {
                    // Handle [&>selector]:utility arbitrary variant patterns
                    if (class_name.len > 0 and class_name[0] == '[') {
                        // Find the closing ] then the : after it
                        if (std.mem.indexOf(u8, class_name, "]:")) |bracket_end| {
                            const arb_selector_raw = class_name[1..bracket_end]; // e.g., "&>input" or "&>input:focus"
                            const utility = class_name[bracket_end + 2 ..]; // e.g., "pb-2"

                            if (self.resolveClassDeclarations(utility) catch null) |decls| {
                                if (current_selector) |sel| {
                                    // Convert &>input to parent>input
                                    // Replace & with the parent selector
                                    var child_sel: std.ArrayList(u8) = .empty;
                                    var arb_pos: usize = 0;
                                    while (arb_pos < arb_selector_raw.len) {
                                        if (arb_selector_raw[arb_pos] == '&') {
                                            try child_sel.appendSlice(self.alloc, sel);
                                        } else {
                                            try child_sel.append(self.alloc, arb_selector_raw[arb_pos]);
                                        }
                                        arb_pos += 1;
                                    }

                                    try variant_rules.appendSlice(self.alloc, child_sel.items);
                                    try variant_rules.append(self.alloc, '{');
                                    for (decls, 0..) |decl, di| {
                                        if (di > 0) try variant_rules.append(self.alloc, ';');
                                        try variant_rules.appendSlice(self.alloc, decl.property);
                                        try variant_rules.append(self.alloc, ':');
                                        try variant_rules.appendSlice(self.alloc, decl.value);
                                    }
                                    try variant_rules.append(self.alloc, '}');
                                }
                            }
                        }
                        continue;
                    }

                    // Also handle lg:[&>selector]:utility (responsive + arbitrary)
                    if (std.mem.indexOf(u8, class_name, ":[&")) |arb_start| {
                        const responsive_prefix = class_name[0..arb_start];
                        const rest = class_name[arb_start + 1 ..];
                        if (rest.len > 0 and rest[0] == '[') {
                            if (std.mem.indexOf(u8, rest, "]:")) |bracket_end| {
                                const arb_selector_raw = rest[1..bracket_end];
                                const utility = rest[bracket_end + 2 ..];

                                if (self.resolveClassDeclarations(utility) catch null) |decls| {
                                    if (current_selector) |sel| {
                                        const media = variantToMedia(responsive_prefix);
                                        if (media) |mq| {
                                            try variant_rules.appendSlice(self.alloc, mq);
                                            try variant_rules.append(self.alloc, '{');
                                        }

                                        var child_sel: std.ArrayList(u8) = .empty;
                                        var arb_pos: usize = 0;
                                        while (arb_pos < arb_selector_raw.len) {
                                            if (arb_selector_raw[arb_pos] == '&') {
                                                try child_sel.appendSlice(self.alloc, sel);
                                            } else {
                                                try child_sel.append(self.alloc, arb_selector_raw[arb_pos]);
                                            }
                                            arb_pos += 1;
                                        }

                                        try variant_rules.appendSlice(self.alloc, child_sel.items);
                                        try variant_rules.append(self.alloc, '{');
                                        for (decls, 0..) |decl, di| {
                                            if (di > 0) try variant_rules.append(self.alloc, ';');
                                            try variant_rules.appendSlice(self.alloc, decl.property);
                                            try variant_rules.append(self.alloc, ':');
                                            try variant_rules.appendSlice(self.alloc, decl.value);
                                        }
                                        try variant_rules.append(self.alloc, '}');

                                        if (media != null) {
                                            try variant_rules.append(self.alloc, '}');
                                        }
                                    }
                                }
                            }
                        }
                        continue;
                    }

                    // Check if class has a variant prefix (contains :)
                    if (std.mem.indexOfScalar(u8, class_name, ':')) |colon_idx| {
                        const variant = class_name[0..colon_idx];
                        const utility = class_name[colon_idx + 1 ..];

                        if (self.resolveClassDeclarations(utility) catch null) |decls| {
                            if (current_selector) |sel| {
                                // Generate a variant rule: .btn:hover{background-color:...}
                                const pseudo = variantToPseudo(variant);
                                if (pseudo) |ps| {
                                    // Check if this needs a media query wrapper
                                    const media = variantToMedia(variant);
                                    if (media) |mq| {
                                        try variant_rules.appendSlice(self.alloc, mq);
                                        try variant_rules.append(self.alloc, '{');
                                    }
                                    try variant_rules.appendSlice(self.alloc, sel);
                                    try variant_rules.appendSlice(self.alloc, ps);
                                    try variant_rules.append(self.alloc, '{');
                                    for (decls, 0..) |decl, di| {
                                        if (di > 0) try variant_rules.append(self.alloc, ';');
                                        try variant_rules.appendSlice(self.alloc, decl.property);
                                        try variant_rules.append(self.alloc, ':');
                                        try variant_rules.appendSlice(self.alloc, decl.value);
                                    }
                                    try variant_rules.append(self.alloc, '}');
                                    if (media != null) {
                                        try variant_rules.append(self.alloc, '}');
                                    }
                                }
                            }
                        }
                    } else {
                        // No variant — inline declarations as before
                        // Handle important modifier: flex! or !flex
                        var resolved_name = class_name;
                        var important = false;
                        if (std.mem.endsWith(u8, class_name, "!")) {
                            resolved_name = class_name[0 .. class_name.len - 1];
                            important = true;
                        } else if (std.mem.startsWith(u8, class_name, "!")) {
                            resolved_name = class_name[1..];
                            important = true;
                        }
                        if (self.resolveClassDeclarations(resolved_name) catch null) |decls| {
                            for (decls) |decl| {
                                if (!first) try result.append(self.alloc, ';');
                                try result.appendSlice(self.alloc, decl.property);
                                try result.append(self.alloc, ':');
                                try result.appendSlice(self.alloc, decl.value);
                                if (important) try result.appendSlice(self.alloc, "!important");
                                first = false;
                            }
                        }
                    }
                }

                // Skip the semicolon if present
                if (end < css.len and css[end] == ';') {
                    pos = end + 1;
                } else {
                    pos = end;
                }
            } else {
                try result.append(self.alloc, css[pos]);
                pos += 1;
            }
        }

        // Append any remaining variant rules
        if (variant_rules.items.len > 0) {
            try result.appendSlice(self.alloc, variant_rules.items);
        }

        return result.items;
    }

    /// Map a variant name to its CSS pseudo-class/element selector suffix.
    fn variantToPseudo(variant: []const u8) ?[]const u8 {
        const map = std.StaticStringMap([]const u8).initComptime(.{
            .{ "hover", ":hover" },
            .{ "focus", ":focus" },
            .{ "focus-visible", ":focus-visible" },
            .{ "focus-within", ":focus-within" },
            .{ "active", ":active" },
            .{ "visited", ":visited" },
            .{ "disabled", ":disabled" },
            .{ "checked", ":checked" },
            .{ "first", ":first-child" },
            .{ "last", ":last-child" },
            .{ "odd", ":nth-child(odd)" },
            .{ "even", ":nth-child(even)" },
            .{ "first-of-type", ":first-of-type" },
            .{ "last-of-type", ":last-of-type" },
            .{ "empty", ":empty" },
            .{ "required", ":required" },
            .{ "invalid", ":invalid" },
            .{ "valid", ":valid" },
            .{ "placeholder-shown", ":placeholder-shown" },
            .{ "read-only", ":read-only" },
            .{ "open", "[open]" },
            .{ "before", "::before" },
            .{ "after", "::after" },
            .{ "placeholder", "::placeholder" },
            .{ "file", "::file-selector-button" },
            // Responsive variants return the selector as-is (media query handled separately)
            .{ "sm", "" },
            .{ "md", "" },
            .{ "lg", "" },
            .{ "xl", "" },
            .{ "2xl", "" },
            .{ "dark", "" },
            .{ "any-hover", "" },
            .{ "prefers-reduced-transparency", "" },
        });
        return map.get(variant);
    }

    /// Map a variant name to a media query wrapper, if applicable.
    fn variantToMedia(variant: []const u8) ?[]const u8 {
        const map = std.StaticStringMap([]const u8).initComptime(.{
            .{ "sm", "@media (width>=40rem)" },
            .{ "md", "@media (width>=48rem)" },
            .{ "lg", "@media (width>=64rem)" },
            .{ "xl", "@media (width>=80rem)" },
            .{ "2xl", "@media (width>=96rem)" },
            .{ "dark", "@media (prefers-color-scheme:dark)" },
            .{ "hover", "@media (hover:hover)" },
            .{ "any-hover", "@media (any-hover:hover)" },
            .{ "prefers-reduced-transparency", "@media (prefers-reduced-transparency:reduce)" },
        });
        return map.get(variant);
    }

    /// Emit the final CSS output.
    pub fn emit(self: *Context) ![]const u8 {
        // Sort rules
        std.mem.sort(CompiledRule, self.rules.items, {}, struct {
            fn lessThan(_: void, a: CompiledRule, b: CompiledRule) bool {
                // Sort by variant order first
                if (a.variant_order != b.variant_order) {
                    return a.variant_order < b.variant_order;
                }
                // Then alphabetically by raw candidate
                return std.mem.order(u8, a.raw, b.raw) == .lt;
            }
        }.lessThan);

        // Extract rules for emitter
        var emit_rules = try self.alloc.alloc(Rule, self.rules.items.len);
        for (self.rules.items, 0..) |cr, i| {
            emit_rules[i] = cr.rule;
        }

        // Process custom CSS: resolve @apply directives and theme() calls
        const processed_css = try self.processCustomCss();

        // Emit CSS (no deinit needed — arena owns all memory, and we return buf.items)
        var css_emitter = emitter_mod.CssEmitter.init(self.alloc, processed_css, self.minify);

        // Pass @property registrations to emitter
        for (self.at_properties.items) |prop| {
            try css_emitter.addProperty(prop);
        }

        // Pass @keyframes registrations to emitter
        for (self.keyframes.items) |kf| {
            try css_emitter.addKeyframes(kf);
        }

        return css_emitter.emit(&self.theme, emit_rules, self.include_preflight);
    }
};

// ─── Wrapper functions for function pointers ───────────────────────────────

fn isStaticWrapper(name: []const u8) bool {
    return utilities.isStaticUtility(name);
}

fn isFunctionalWrapper(name: []const u8) bool {
    return utilities.isFunctionalUtility(name);
}

fn isVariantWrapper(name: []const u8) bool {
    return variants_mod.isVariant(name);
}

fn isFunctionalVariantRootWrapper(name: []const u8) bool {
    return variants_mod.isFunctionalVariantRoot(name);
}

fn isWhitespace(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r';
}

/// Minify CSS: collapse whitespace runs to single spaces, remove whitespace
/// around braces, colons, semicolons, and strip comments.
fn minifyCss(alloc: Allocator, css: []const u8) ![]const u8 {
    var result: std.ArrayList(u8) = .empty;
    try result.ensureTotalCapacity(alloc, css.len);
    var pos: usize = 0;

    while (pos < css.len) {
        // Skip comments
        if (pos + 1 < css.len and css[pos] == '/' and css[pos + 1] == '*') {
            pos += 2;
            while (pos + 1 < css.len) {
                if (css[pos] == '*' and css[pos + 1] == '/') {
                    pos += 2;
                    break;
                }
                pos += 1;
            }
            continue;
        }

        // Collapse whitespace
        if (isWhitespace(css[pos])) {
            // Skip all whitespace
            while (pos < css.len and isWhitespace(css[pos])) pos += 1;
            // Only add a space if the previous and next chars aren't structural
            if (result.items.len > 0 and pos < css.len) {
                const prev = result.items[result.items.len - 1];
                const next = css[pos];
                if (prev != '{' and prev != '}' and prev != ';' and prev != ':' and
                    next != '{' and next != '}' and next != ';' and next != ':')
                {
                    try result.append(alloc, ' ');
                }
            }
            continue;
        }

        try result.append(alloc, css[pos]);
        pos += 1;
    }

    return result.items;
}

// ─── Public API ────────────────────────────────────────────────────────────

/// Compile a list of candidate strings into CSS.
///
/// When `minify` is true the output is compressed (no whitespace);
/// when false the output is pretty-printed with indentation.
pub fn compile(
    alloc: Allocator,
    candidates: []const []const u8,
    theme_json: ?[]const u8,
    include_preflight: bool,
    minify: bool,
    custom_css: ?[]const u8,
    custom_utilities_json: ?[]const u8,
    plugin_css: ?[]const u8,
) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    var ctx = Context.init(arena_alloc, include_preflight, minify, custom_css, custom_utilities_json, plugin_css);

    try ctx.loadDefaults();
    try ctx.loadCustomUtilities();
    try ctx.loadPluginCss();

    if (theme_json) |json| {
        try ctx.applyThemeJson(json);
    }

    try ctx.seen.ensureTotalCapacity(@intCast(candidates.len));

    for (candidates) |candidate| {
        ctx.process(candidate) catch continue;
    }

    const result = try ctx.emit();
    return alloc.dupe(u8, result);
}

/// Validate a list of token strings, returning only those that are recognized
/// as valid Tailwind utilities. Does NOT generate CSS — just checks parsing
/// and registry membership. Used for compile-time safelist extraction.
pub fn validate(
    alloc: Allocator,
    tokens: []const []const u8,
) ![]const []const u8 {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    // Collect indices of valid tokens (using arena for temp storage)
    var valid_indices: std.ArrayList(usize) = .empty;

    for (tokens, 0..) |token, idx| {
        if (token.len == 0) continue;

        // Try parsing as a candidate
        const parsed = candidate_mod.parseCandidate(
            arena_alloc,
            token,
            &isStaticWrapper,
            &isFunctionalWrapper,
            &isVariantWrapper,
            &isFunctionalVariantRootWrapper,
        ) catch continue;

        if (parsed) |p| {
            // Reject bare functional utilities without a value (unless they have defaults)
            if (p.kind == .functional and p.value == null) {
                if (!utilities.hasDefaultValue(p.root)) continue;
            }

            // Reject negative prefix on utilities that don't support it
            if (p.negative) {
                if (!utilities.supportsNegative(p.root)) continue;
            }

            try valid_indices.append(arena_alloc, idx);
        }
    }

    // Build result using the caller's allocator (references original token slices)
    const result = try alloc.alloc([]const u8, valid_indices.items.len);
    for (valid_indices.items, 0..) |idx, i| {
        result[i] = tokens[idx];
    }

    return result;
}

// ─── Tests ─────────────────────────────────────────────────────────────────

test "validate: filters valid candidates" {
    const alloc = std.testing.allocator;

    const tokens = [_][]const u8{ "flex", "not-a-class", "hover:bg-blue-50", "hello", "p-4", "sm:text-lg" };
    const result = try validate(alloc, &tokens);
    defer alloc.free(result);

    // Should include valid utilities and reject invalid tokens
    var has_flex = false;
    var has_hover_bg = false;
    var has_p4 = false;
    var has_sm_text = false;
    var has_invalid = false;

    for (result) |r| {
        if (std.mem.eql(u8, r, "flex")) has_flex = true;
        if (std.mem.eql(u8, r, "hover:bg-blue-50")) has_hover_bg = true;
        if (std.mem.eql(u8, r, "p-4")) has_p4 = true;
        if (std.mem.eql(u8, r, "sm:text-lg")) has_sm_text = true;
        if (std.mem.eql(u8, r, "not-a-class") or std.mem.eql(u8, r, "hello")) has_invalid = true;
    }

    try std.testing.expect(has_flex);
    try std.testing.expect(has_hover_bg);
    try std.testing.expect(has_p4);
    try std.testing.expect(has_sm_text);
    try std.testing.expect(!has_invalid);
}

test "compile: basic static utilities" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{ "flex", "block", "hidden" };
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should contain the utility classes
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".block{display:block}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".hidden{display:none}") != null);
}

test "compile: static utility with variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"hover:flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should have hover media query wrapping
    try std.testing.expect(std.mem.indexOf(u8, result, "@media (hover:hover)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
}

test "compile: dark mode variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"dark:hidden"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@media (prefers-color-scheme:dark)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:none") != null);
}

test "compile: important flag" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"flex!"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex!important") != null);
}

test "compile: arbitrary property" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"[color:red]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "color:red") != null);
}

test "compile: deduplication" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{ "flex", "flex", "flex" };
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should only contain one .flex rule
    const first = std.mem.indexOf(u8, result, ".flex{") orelse unreachable;
    const second = std.mem.indexOf(u8, result[first + 1 ..], ".flex{");
    try std.testing.expect(second == null);
}

test "compile: spacing utility" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"p-4"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "padding:calc(var(--spacing) * 4)") != null);
}

test "compile: color utility" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-red-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-red-500)") != null);
}

test "compile: z-index" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"z-10"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "z-index:10") != null);
}

test "compile: arbitrary value" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-[#0088cc]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:#0088cc") != null);
}

test "compile: selector escaping" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"hover:underline"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, ".hover\\:underline") != null);
}

test "compile: responsive variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"sm:flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@media (width>=40rem)") != null);
}

test "compile: theme layer emits used variables" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-red-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@layer theme{:root{") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--color-red-500:") != null);
}

test "compile: negative spacing" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"-mt-4"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "margin-top:calc(var(--spacing) * -4)") != null);
}

test "compile: fraction value" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"w-1/2"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "width:calc(1 / 2 * 100%)") != null);
}

test "compile: special spacing keywords" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"w-full"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "width:100%") != null);
}

test "compile: data variant - basic arbitrary" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-[state=active]:bg-blue-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // data-[state=active] should produce [data-state=active] attribute selector
    try std.testing.expect(std.mem.indexOf(u8, result, "[data-state=active]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color") != null);
}

test "compile: data variant - named" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-active:bg-red-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "[data-active]") != null);
}

test "compile: data variant - arbitrary boolean" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-[disabled]:bg-gray-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "[data-disabled]") != null);
}

test "compile: data variant - compound group" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"group-data-[state=open]:flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should wrap in group ancestor selector with data attribute
    try std.testing.expect(std.mem.indexOf(u8, result, ".group[data-state=open]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
}

test "compile: data variant - compound has" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"has-data-[loading]:opacity-50"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should produce :has([data-loading])
    try std.testing.expect(std.mem.indexOf(u8, result, ":has([data-loading])") != null);
}

test "compile: aria variant - compound group" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"group-aria-checked:bg-blue-500"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Should wrap in group ancestor selector with aria attribute
    try std.testing.expect(std.mem.indexOf(u8, result, ".group[aria-checked=") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color") != null);
}

test "compile: custom CSS passthrough" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".custom{color:red}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".custom{color:red}") != null);
}

test "compile: custom CSS null is no-op" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
}

test "compile: custom utilities via JSON" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex", "btn-primary", "link-default" };
    const custom =
        \\{"btn-primary":"background:blue;color:white;padding:0.5rem 1rem","link-default":"color:inherit;text-decoration:underline"}
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, custom, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".btn-primary{background:blue;color:white;padding:0.5rem 1rem}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".link-default{color:inherit;text-decoration:underline}") != null);
}

test "compile: custom utilities with variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"hover:btn-primary"};
    const custom =
        \\{"btn-primary":"background:blue;color:white"}
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, custom, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "btn-primary") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background:blue") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@media (hover:hover)") != null);
}

test "compile: @apply resolves static utilities" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".btn{@apply font-bold flex;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // @apply should be replaced with resolved declarations
    // font-bold resolves to --tw-font-weight + font-weight using CSS var
    try std.testing.expect(std.mem.indexOf(u8, result, "font-weight:var(--font-weight-bold)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
    // The @apply directive itself should NOT be in the output
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
}

test "compile: @apply resolves functional utilities" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".btn{@apply py-4 px-8;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "padding-block:calc(var(--spacing) * 4)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "padding-inline:calc(var(--spacing) * 8)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
}

test "compile: @apply resolves static-only utilities" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".card{@apply flex hidden;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // Static utilities resolve directly
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex;display:none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
}

test "compile: @apply with rounded-lg" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".card{@apply rounded-lg;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-radius:var(--radius-lg)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
}

test "compile: theme() resolves color values" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".featured{--color-featured-bg:theme(colors.blue.900);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // theme(colors.blue.900) should be replaced with the actual oklch value
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(") == null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--color-featured-bg:oklch(") != null);
}

test "compile: theme() resolves spacing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ":root{--custom-spacing:theme(spacing);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--custom-spacing:0.25rem") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(") == null);
}

test "compile: @apply and theme() combined" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".btn{@apply font-bold;color:theme(colors.red.500);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-weight:var(--font-weight-bold)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "oklch(63.7%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(") == null);
}

test "compile: custom CSS without @apply or theme() passes through unchanged" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".custom{color:red;font-size:16px}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".custom{color:red;font-size:16px}") != null);
}

test "compile: @apply skips unknown classes gracefully" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".btn{@apply font-bold not-a-real-class flex;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // Known classes should still resolve
    try std.testing.expect(std.mem.indexOf(u8, result, "font-weight:var(--font-weight-bold)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "@apply") == null);
}

test "compile: theme() with unresolved path keeps original" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".x{color:theme(nonexistent.path);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // Unresolved theme() should be kept as-is
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(nonexistent.path)") != null);
}

test "compile: plugin_css registers color variables as theme colors" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-primary", "text-secondary" };
    const plugin =
        \\:root {
        \\  --color-primary: oklch(62.3% 0.214 259.815);
        \\  --color-secondary: oklch(71.1% 0.194 261.209);
        \\}
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-primary)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "color:var(--color-secondary)") != null);
}

test "compile: plugin_css includes component CSS in output" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const plugin =
        \\.btn { display: inline-flex; padding: 0.5rem; }
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".btn{") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:inline-flex") != null);
}

test "compile: plugin_css includes data-theme blocks" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const plugin =
        \\:root { --color-base-100: #fff; }
        \\[data-theme="dark"] { --color-base-100: #1a1a2e; }
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "[data-theme=\"dark\"]") != null);
}

test "compile: plugin_css colors work with opacity modifiers" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-brand/50"};
    const plugin =
        \\:root { --color-brand: oklch(62.3% 0.214 259.815); }
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    // Should use color-mix with the raw oklch value
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:color-mix(in srgb,oklch(62.3% 0.214 259.815) 50%,transparent)") != null);
}

test "compile: plugin_css null is no-op" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
}

test "compile: plugin_css works alongside custom_css" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-brand", "flex" };
    const plugin =
        \\:root { --color-brand: #ff0000; }
    ;
    const custom = ".my-custom{color:blue}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, plugin);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-brand)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".my-custom{color:blue}") != null);
}

test "compile: plugin_css works alongside stock theme colors" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-primary", "bg-red-500" };
    const plugin =
        \\:root { --color-primary: oklch(62.3% 0.214 259.815); }
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    // Both plugin and stock colors should work
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-primary)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-red-500)") != null);
}

test "compile: plugin_css minifies whitespace in output" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const plugin =
        \\.card {
        \\  border-radius: 0.5rem;
        \\  padding: 1rem;
        \\}
    ;
    const result = try compile(alloc, &candidates, null, false, true, null, null, plugin);
    defer alloc.free(result);
    // Whitespace should be collapsed
    try std.testing.expect(std.mem.indexOf(u8, result, ".card{border-radius:0.5rem;padding:1rem;}") != null);
}

test "compile: pretty print output" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{ "flex", "p-4" };
    const result = try compile(alloc, &candidates, null, false, false, null, null, null);
    defer alloc.free(result);

    // Pretty-printed output should have newlines and indentation
    try std.testing.expect(std.mem.indexOf(u8, result, "  .flex {\n    display: flex;\n  }") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "  .p-4 {\n    padding: calc(var(--spacing) * 4);\n  }") != null);
}

test "compile: minified output" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);

    // Minified output should have no newlines in rules
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
}

test "compile: pretty print with variants" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"hover:flex"};
    const result = try compile(alloc, &candidates, null, false, false, null, null, null);
    defer alloc.free(result);

    // Media query and nested rule should be indented
    try std.testing.expect(std.mem.indexOf(u8, result, "  @media (hover:hover) {\n") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "    .hover\\:flex:hover {\n") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "      display: flex;\n") != null);
}

// ─── Parity tests ─────────────────────────────────────────────────────────

test "compile: bg-[size:...] emits background-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-[size:auto]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-size:auto") != null);
    // Must NOT emit background-color
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:auto") == null);
}

test "compile: bg-[radial-gradient(...)] emits background-image" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-[radial-gradient(circle,red,blue)]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-image:radial-gradient(circle,red,blue)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:") == null);
}

test "compile: bg-[url(...)] emits background-image" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-[url('/img/bg.png')]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-image:url('/img/bg.png')") != null);
}

test "compile: bg-[linear-gradient(...)] emits background-image" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-[linear-gradient(to_right,red,blue)]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-image:linear-gradient(to right,red,blue)") != null);
}

test "compile: bg-[position:center] emits background-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-[position:center]"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-position:center") != null);
}

test "compile: rounded-full uses calc(infinity * 1px)" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"rounded-full"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "calc(infinity * 1px)") != null);
}

test "compile: w-1/2 uses calc expression" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"w-1/2"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "calc(1 / 2 * 100%)") != null);
}

test "compile: w-2/5 uses calc expression" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"w-2/5"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "calc(2 / 5 * 100%)") != null);
}

test "compile: transition emits --default-transition-duration in theme layer" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"transition"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--default-transition-duration:150ms") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--default-transition-timing-function:cubic-bezier(0.4, 0, 0.2, 1)") != null);
}

test "compile: text-xs line-height uses calc ratio" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"text-xs"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--text-xs--line-height:calc(1 / 0.75)") != null);
}

test "compile: bg color with opacity uses color-mix" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-white/10"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    // Base: color-mix in srgb with raw value
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:color-mix(in srgb,#fff 10%,transparent)") != null);
    // Enhanced: @supports with color-mix in oklab using var()
    try std.testing.expect(std.mem.indexOf(u8, result, "@supports (color:color-mix(in lab,red,red))") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:color-mix(in oklab,var(--color-white) 10%,transparent)") != null);
}

test "compile: border color with opacity uses color-mix" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"border-cyan-400/20"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-color:color-mix(in srgb,") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-color:color-mix(in oklab,var(--color-cyan-400) 20%,transparent)") != null);
}

test "compile: gradient from with opacity uses color-mix" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"from-violet-500/10"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--tw-gradient-from:color-mix(in srgb,") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--tw-gradient-from:color-mix(in oklab,var(--color-violet-500) 10%,transparent)") != null);
}

test "compile: ring color with opacity uses color-mix" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"ring-white/10"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--tw-ring-color:color-mix(in srgb,#fff 10%,transparent)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--tw-ring-color:color-mix(in oklab,var(--color-white) 10%,transparent)") != null);
}

test "compile: space-y uses :where() CSS nesting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"space-y-4"};
    const result = try compile(alloc, &candidates, null, false, false, null, null, null);
    defer alloc.free(result);
    // Should use .space-y-4 as the selector, NOT .space-y-4>:not(:last-child)
    try std.testing.expect(std.mem.indexOf(u8, result, ".space-y-4 {\n") != null);
    // Should contain :where(& > :not(:last-child)) nested block
    try std.testing.expect(std.mem.indexOf(u8, result, ":where(& > :not(:last-child))") != null);
}

test "compile: divide-y uses :where() CSS nesting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"divide-y"};
    const result = try compile(alloc, &candidates, null, false, false, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, ".divide-y {\n") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ":where(& > :not(:last-child))") != null);
}

test "compile: preflight includes var() font-family references" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const result = try compile(alloc, &candidates, null, true, true, null, null, null);
    defer alloc.free(result);
    // html,:host should have var(--default-font-family,...) font reference
    try std.testing.expect(std.mem.indexOf(u8, result, "var(--default-font-family,") != null);
    // code,kbd,samp,pre should have var(--default-mono-font-family,...) font reference
    try std.testing.expect(std.mem.indexOf(u8, result, "var(--default-mono-font-family,") != null);
}

test "compile: text-sm line-height uses calc ratio" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"text-sm"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "--text-sm--line-height:calc(1.25 / 0.875)") != null);
}

// ─── Missing variant tests ────────────────────────────────────────────────

test "compile: any-hover variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"any-hover:flex"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "@media (any-hover:hover)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
}

test "compile: prefers-reduced-transparency variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"prefers-reduced-transparency:hidden"};
    const result = try compile(alloc, &candidates, null, false, true, null, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "@media (prefers-reduced-transparency:reduce)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:none") != null);
}

// ─── theme() edge case tests ──────────────────────────────────────────────

test "compile: theme() CSS variable shorthand" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ":root{--featured:theme(--color-red-500);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // theme(--color-red-500) should resolve to the oklch value
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(") == null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--featured:oklch(") != null);
}

test "compile: theme() with opacity modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ":root{--bg:theme(colors.red.500 / 50%);}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    // Should resolve with opacity applied
    try std.testing.expect(std.mem.indexOf(u8, result, "theme(") == null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--bg:") != null);
}

// ─── @apply edge case tests ───────────────────────────────────────────────

test "compile: @apply with important modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"flex"};
    const custom = ".btn{@apply flex!;}";
    const result = try compile(alloc, &candidates, null, false, true, custom, null, null);
    defer alloc.free(result);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex!important") != null);
}

// ─── Theme JSON edge case tests ───────────────────────────────────────────

test "compile: theme JSON deep nesting (3 levels)" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-brand-light"};
    const theme_json =
        \\{"colors":{"brand":{"light":"#aabbcc","dark":"#112233"}}}
    ;
    const result2 = try compile(alloc, &candidates, theme_json, false, true, null, null, null);
    defer alloc.free(result2);
    try std.testing.expect(std.mem.indexOf(u8, result2, "background-color:var(--color-brand-light)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result2, "--color-brand-light:#aabbcc") != null);
}

test "compile: theme JSON recursive nesting (4+ levels)" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"bg-brand-primary-light"};
    const theme_json =
        \\{"colors":{"brand":{"primary":{"light":"#aabbcc","dark":"#112233"}}}}
    ;
    const result = try compile(alloc, &candidates, theme_json, false, true, null, null, null);
    defer alloc.free(result);
    // 4-level: colors -> brand -> primary -> light = --color-brand-primary-light
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-brand-primary-light)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--color-brand-primary-light:#aabbcc") != null);
}
