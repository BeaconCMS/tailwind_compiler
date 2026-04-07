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
    at_properties: std.ArrayList(emitter_mod.AtProperty),
    keyframes: std.ArrayList(emitter_mod.Keyframes),

    pub fn init(alloc: Allocator, include_preflight: bool) Context {
        return Context{
            .alloc = alloc,
            .theme = Theme.init(alloc),
            .rules = .empty,
            .seen = std.StringHashMap(void).init(alloc),
            .include_preflight = include_preflight,
            .at_properties = .empty,
            .keyframes = .empty,
        };
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
        if (self.seen.contains(raw)) return;
        try self.seen.put(raw, {});

        // Parse the candidate
        const parsed = try candidate_mod.parseCandidate(
            self.alloc,
            raw,
            &isStaticWrapper,
            &isFunctionalWrapper,
            &isVariantWrapper,
        ) orelse return;

        // Resolve to CSS declarations
        const declarations = try self.resolveDeclarations(&parsed) orelse return;

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

        // Create base rule
        var base_rule = Rule{
            .kind = .style,
            .selector = selector,
            .declarations = final_decls,
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

        // Emit CSS
        var css_emitter = emitter_mod.CssEmitter.init(self.alloc);
        defer css_emitter.deinit();

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

// ─── Public API ────────────────────────────────────────────────────────────

/// Compile a list of candidate strings into minified CSS.
pub fn compile(
    alloc: Allocator,
    candidates: []const []const u8,
    theme_json: ?[]const u8,
    include_preflight: bool,
) ![]const u8 {
    // Use an arena for all intermediate allocations; only the final
    // result string is duped into the caller's allocator.
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    var ctx = Context.init(arena_alloc, include_preflight);

    try ctx.loadDefaults();

    if (theme_json) |json| {
        try ctx.applyThemeJson(json);
    }

    for (candidates) |candidate| {
        try ctx.process(candidate);
    }

    const result = try ctx.emit();
    return alloc.dupe(u8, result);
}

// ─── Tests ─────────────────────────────────────────────────────────────────

test "compile: basic static utilities" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{ "flex", "block", "hidden" };
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should contain the utility classes
    try std.testing.expect(std.mem.indexOf(u8, result, ".flex{display:flex}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".block{display:block}") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, ".hidden{display:none}") != null);
}

test "compile: static utility with variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"hover:flex"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should have hover media query wrapping
    try std.testing.expect(std.mem.indexOf(u8, result, "@media (hover:hover)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
}

test "compile: dark mode variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"dark:hidden"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@media (prefers-color-scheme:dark)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:none") != null);
}

test "compile: important flag" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"flex!"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex!important") != null);
}

test "compile: arbitrary property" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"[color:red]"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "color:red") != null);
}

test "compile: deduplication" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{ "flex", "flex", "flex" };
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should only contain one .flex rule
    const first = std.mem.indexOf(u8, result, ".flex{") orelse unreachable;
    const second = std.mem.indexOf(u8, result[first + 1 ..], ".flex{");
    try std.testing.expect(second == null);
}

test "compile: spacing utility" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"p-4"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "padding:calc(var(--spacing) * 4)") != null);
}

test "compile: color utility" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-red-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:var(--color-red-500)") != null);
}

test "compile: z-index" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"z-10"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "z-index:10") != null);
}

test "compile: arbitrary value" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-[#0088cc]"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "background-color:#0088cc") != null);
}

test "compile: selector escaping" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"hover:underline"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, ".hover\\:underline") != null);
}

test "compile: responsive variant" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"sm:flex"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@media (width>=40rem)") != null);
}

test "compile: theme layer emits used variables" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"bg-red-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "@layer theme{:root{") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "--color-red-500:") != null);
}

test "compile: negative spacing" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"-mt-4"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "margin-top:calc(var(--spacing) * -4)") != null);
}

test "compile: fraction value" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"w-1/2"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "width:50%") != null);
}

test "compile: special spacing keywords" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"w-full"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "width:100%") != null);
}

test "compile: data variant - basic arbitrary" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-[state=active]:bg-blue-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // data-[state=active] should produce [data-state=active] attribute selector
    try std.testing.expect(std.mem.indexOf(u8, result, "[data-state=active]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color") != null);
}

test "compile: data variant - named" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-active:bg-red-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "[data-active]") != null);
}

test "compile: data variant - arbitrary boolean" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"data-[disabled]:bg-gray-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "[data-disabled]") != null);
}

test "compile: data variant - compound group" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"group-data-[state=open]:flex"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should wrap in group ancestor selector with data attribute
    try std.testing.expect(std.mem.indexOf(u8, result, ".group[data-state=open]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "display:flex") != null);
}

test "compile: data variant - compound has" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"has-data-[loading]:opacity-50"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should produce :has([data-loading])
    try std.testing.expect(std.mem.indexOf(u8, result, ":has([data-loading])") != null);
}

test "compile: aria variant - compound group" {
    const alloc = std.testing.allocator;

    const candidates = [_][]const u8{"group-aria-checked:bg-blue-500"};
    const result = try compile(alloc, &candidates, null, false);
    defer alloc.free(result);

    // Should wrap in group ancestor selector with aria attribute
    try std.testing.expect(std.mem.indexOf(u8, result, ".group[aria-checked=") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "background-color") != null);
}
