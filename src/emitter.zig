const std = @import("std");
const Allocator = std.mem.Allocator;
const Theme = @import("theme.zig").Theme;

// ─── CSS Rule Representation ───────────────────────────────────────────────

pub const Declaration = struct {
    property: []const u8,
    value: []const u8,
    important: bool = false,
    /// When set, emitter wraps this value in a nested @supports block
    /// for color-mix() progressive enhancement.
    supports_value: ?[]const u8 = null,
};

pub const RuleKind = enum {
    style,
    media,
    container,
    supports,
    at_starting_style,
    layer,
    at_property,
};

pub const AtProperty = struct {
    name: []const u8, // e.g. "--tw-shadow"
    syntax: []const u8, // e.g. "*" or "<length>"
    inherits: bool,
    initial_value: ?[]const u8, // e.g. "0 0 #0000"
};

pub const Keyframes = struct {
    name: []const u8,
    body: []const u8, // The full CSS body inside the @keyframes block
};

pub const Rule = struct {
    kind: RuleKind = .style,
    selector: ?[]const u8 = null,
    at_rule: ?[]const u8 = null, // e.g. "@media (hover:hover)"
    declarations: []const Declaration = &.{},
    children: []const Rule = &.{},
    /// Sort key for variant ordering
    variant_order: u64 = 0,
    /// Sort key for property ordering
    property_order: u32 = 0,
};

// ─── CSS Selector Escaping (CSS.escape spec) ───────────────────────────────

/// Escape a string for use as a CSS identifier, following the CSSOM CSS.escape() spec.
pub fn escapeCssIdentifier(alloc: Allocator, input: []const u8) ![]const u8 {
    if (input.len == 0) return "";

    // Fast path: most Tailwind classes like "flex", "block", "items-center" need no escaping.
    // Scan the input to check if any character requires escaping; if not, dupe and return.
    // This avoids the per-character ArrayList append overhead in the common case.
    var safe = true;
    for (input, 0..) |c, idx| {
        const is_safe = (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
            c == '-' or c == '_' or c >= 0x80 or
            (c >= '0' and c <= '9' and idx > 0);
        if (!is_safe) {
            safe = false;
            break;
        }
    }
    if (safe and !(input[0] == '-' and input.len == 1)) return alloc.dupe(u8, input);

    // Slow path: allocate and escape
    var result = try std.ArrayList(u8).initCapacity(alloc, input.len * 2);

    for (input, 0..) |c, i| {
        // NULL -> U+FFFD
        if (c == 0) {
            try result.appendSlice(alloc, "\xEF\xBF\xBD"); // UTF-8 for U+FFFD
            continue;
        }

        // Control characters U+0001 to U+001F, U+007F -> \hex
        if ((c >= 0x01 and c <= 0x1F) or c == 0x7F) {
            try appendHexEscape(alloc, &result, c);
            continue;
        }

        // Leading digit
        if (i == 0 and c >= '0' and c <= '9') {
            try appendHexEscape(alloc, &result, c);
            continue;
        }

        // Digit after leading -
        if (i == 1 and c >= '0' and c <= '9' and input[0] == '-') {
            try appendHexEscape(alloc, &result, c);
            continue;
        }

        // Solo -
        if (i == 0 and c == '-' and input.len == 1) {
            try result.append(alloc, '\\');
            try result.append(alloc, '-');
            continue;
        }

        // Safe characters: >= 0x80, -, _, 0-9, A-Z, a-z
        if (c >= 0x80 or c == '-' or c == '_' or
            (c >= '0' and c <= '9') or
            (c >= 'A' and c <= 'Z') or
            (c >= 'a' and c <= 'z'))
        {
            try result.append(alloc, c);
            continue;
        }

        // Everything else: backslash + literal
        try result.append(alloc, '\\');
        try result.append(alloc, c);
    }

    return result.toOwnedSlice(alloc);
}

fn appendHexEscape(alloc: Allocator, result: *std.ArrayList(u8), c: u8) !void {
    var buf: [8]u8 = undefined;
    const hex = std.fmt.bufPrint(&buf, "\\{x} ", .{c}) catch unreachable;
    try result.appendSlice(alloc, hex);
}

// ─── CSS Emitter ───────────────────────────────────────────────────────────

pub const CssEmitter = struct {
    alloc: Allocator,
    buf: std.ArrayList(u8),
    at_properties: std.ArrayList(AtProperty),
    keyframes: std.ArrayList(Keyframes),
    custom_css: ?[]const u8 = null,
    minify: bool,
    indent: u32 = 0,

    pub fn init(alloc: Allocator, custom_css: ?[]const u8, minify: bool) CssEmitter {
        return CssEmitter{
            .alloc = alloc,
            .buf = .empty,
            .at_properties = .empty,
            .keyframes = .empty,
            .custom_css = custom_css,
            .minify = minify,
        };
    }

    /// Write a newline followed by indentation (pretty mode only; no-op when minified).
    fn writeNewline(self: *CssEmitter) !void {
        if (self.minify) return;
        try self.buf.append(self.alloc, '\n');
        for (0..self.indent * 2) |_| {
            try self.buf.append(self.alloc, ' ');
        }
    }

    /// Write a space (pretty mode only).
    fn writeSpace(self: *CssEmitter) !void {
        if (self.minify) return;
        try self.buf.append(self.alloc, ' ');
    }

    pub fn deinit(self: *CssEmitter) void {
        self.buf.deinit(self.alloc);
        self.at_properties.deinit(self.alloc);
        self.keyframes.deinit(self.alloc);
    }

    pub fn addProperty(self: *CssEmitter, prop: AtProperty) !void {
        // Deduplicate by name
        for (self.at_properties.items) |existing| {
            if (std.mem.eql(u8, existing.name, prop.name)) return;
        }
        try self.at_properties.append(self.alloc, prop);
    }

    pub fn addKeyframes(self: *CssEmitter, kf: Keyframes) !void {
        for (self.keyframes.items) |existing| {
            if (std.mem.eql(u8, existing.name, kf.name)) return;
        }
        try self.keyframes.append(self.alloc, kf);
    }

    /// Emit the complete CSS output.
    pub fn emit(
        self: *CssEmitter,
        theme: *Theme,
        rules: []const Rule,
        include_preflight: bool,
    ) ![]const u8 {
        // Pre-size output buffer to avoid reallocations
        const estimated_size = rules.len * 80 + 4096; // ~80 bytes per rule + overhead for theme/base/properties
        try self.buf.ensureTotalCapacity(self.alloc, estimated_size);

        // @layer theme
        try self.emitThemeLayer(theme);

        // Initialize --tw-* custom properties that utilities depend on.
        // Tailwind v4 uses @property declarations for these, but for
        // browser compatibility we set them on the universal selector.
        // Only include properties that have safe, non-destructive defaults.
        try self.emitPropertiesLayer();

        // @layer base (preflight)
        if (include_preflight) {
            try self.emitBaseLayer();
        }

        // @layer utilities
        try self.emitUtilitiesLayer(rules);

        // Custom CSS (plugins, user stylesheets)
        if (self.custom_css) |css| {
            try self.buf.appendSlice(self.alloc, css);
            try self.writeNewline();
        }

        // @property declarations
        try self.emitAtProperties();

        // @keyframes declarations
        try self.emitKeyframes();

        // Return items slice directly — the caller (compile) dupes into its own allocator
        // before the arena is freed, so this avoids a redundant copy.
        return self.buf.items;
    }

    /// Emit @layer theme with used CSS variables.
    fn emitThemeLayer(self: *CssEmitter, theme: *Theme) !void {
        // Collect used variables
        var used_vars: std.ArrayList(UsedVar) = .empty;
        var iter = theme.used_variables.iterator();
        while (iter.next()) |entry| {
            if (theme.get(entry.key_ptr.*)) |value| {
                try used_vars.append(self.alloc, .{ .name = entry.key_ptr.*, .value = value });
            }
        }

        // Also emit companion variables (--line-height, --letter-spacing, --font-weight)
        // for any used --text-* variables. These companion vars may not be in used_variables
        // because they're referenced indirectly via var() fallback chains.
        var vars_iter = theme.variables.iterator();
        while (vars_iter.next()) |entry| {
            const name = entry.key_ptr.*;
            if (std.mem.startsWith(u8, name, "--text-") and std.mem.endsWith(u8, name, "--line-height")) {
                const base_end = std.mem.lastIndexOf(u8, name, "--line-height") orelse continue;
                const base_name = name[0..base_end];
                if (theme.used_variables.contains(base_name) and !theme.used_variables.contains(name)) {
                    try used_vars.append(self.alloc, .{ .name = name, .value = entry.value_ptr.* });
                }
            }
        }

        if (used_vars.items.len == 0) return;

        // Sort for deterministic output
        std.mem.sort(UsedVar, used_vars.items, {}, struct {
            fn lessThan(_: void, a: UsedVar, b: UsedVar) bool {
                return std.mem.order(u8, a.name, b.name) == .lt;
            }
        }.lessThan);

        try self.buf.appendSlice(self.alloc, "@layer theme");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        try self.writeNewline();
        if (self.minify) {
            try self.buf.appendSlice(self.alloc, ":root,:host");
        } else {
            try self.buf.appendSlice(self.alloc, ":root, :host");
        }
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        for (used_vars.items, 0..) |v, i| {
            if (i > 0 and self.minify) try self.buf.append(self.alloc, ';');
            try self.writeNewline();
            try self.buf.appendSlice(self.alloc, v.name);
            try self.buf.append(self.alloc, ':');
            try self.writeSpace();
            try self.buf.appendSlice(self.alloc, v.value);
            if (!self.minify) try self.buf.append(self.alloc, ';');
        }
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
        try self.writeNewline();
    }

    /// Emit @layer base (preflight).
    fn emitBaseLayer(self: *CssEmitter) !void {
        try self.buf.appendSlice(self.alloc, "@layer base");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        try self.buf.appendSlice(self.alloc, preflight_css);
        try self.buf.append(self.alloc, '}');
        try self.writeNewline();
    }

    /// Emit @layer properties with default --tw-* custom properties.
    fn emitPropertiesLayer(self: *CssEmitter) !void {
        const props = [_][2][]const u8{
            .{ "--tw-border-style", "solid" },
            .{ "--tw-content", "\"\"" },
            .{ "--tw-outline-style", "solid" },
            .{ "--tw-ring-shadow", "0 0 #0000" },
            .{ "--tw-inset-ring-shadow", "0 0 #0000" },
            .{ "--tw-ring-offset-width", "0px" },
            .{ "--tw-ring-offset-color", "#fff" },
            .{ "--tw-ring-offset-shadow", "0 0 #0000" },
            .{ "--tw-shadow", "0 0 #0000" },
            .{ "--tw-inset-shadow", "0 0 #0000" },
            .{ "--tw-shadow-alpha", "100%" },
            .{ "--tw-inset-shadow-alpha", "100%" },
            .{ "--tw-divide-x-reverse", "0" },
            .{ "--tw-divide-y-reverse", "0" },
            .{ "--tw-space-x-reverse", "0" },
            .{ "--tw-space-y-reverse", "0" },
        };

        try self.buf.appendSlice(self.alloc, "@layer properties");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        try self.writeNewline();
        try self.buf.appendSlice(self.alloc, "*,:before,:after,::backdrop");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        for (props, 0..) |prop, i| {
            if (i > 0 and self.minify) try self.buf.append(self.alloc, ';');
            try self.writeNewline();
            try self.buf.appendSlice(self.alloc, prop[0]);
            try self.buf.append(self.alloc, ':');
            try self.writeSpace();
            try self.buf.appendSlice(self.alloc, prop[1]);
            if (!self.minify) try self.buf.append(self.alloc, ';');
        }
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');

        // @supports fallback for browsers that don't support @property
        try self.writeNewline();
        try self.buf.appendSlice(self.alloc, "@supports ((-webkit-hyphens:none) and (not (margin-trim:inline))) or ((-moz-orient:inline) and (not (color:rgb(from red r g b))))");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        try self.writeNewline();
        try self.buf.appendSlice(self.alloc, "*,::before,::after,::backdrop");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        for (props, 0..) |prop, i| {
            if (i > 0 and self.minify) try self.buf.append(self.alloc, ';');
            try self.writeNewline();
            try self.buf.appendSlice(self.alloc, prop[0]);
            try self.buf.append(self.alloc, ':');
            try self.writeSpace();
            try self.buf.appendSlice(self.alloc, prop[1]);
            if (!self.minify) try self.buf.append(self.alloc, ';');
        }
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');

        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
        try self.writeNewline();
    }

    /// Emit @property declarations.
    fn emitAtProperties(self: *CssEmitter) !void {
        std.mem.sort(AtProperty, self.at_properties.items, {}, struct {
            fn lessThan(_: void, a: AtProperty, b: AtProperty) bool {
                return std.mem.order(u8, a.name, b.name) == .lt;
            }
        }.lessThan);

        for (self.at_properties.items) |prop| {
            try self.buf.appendSlice(self.alloc, "@property ");
            try self.buf.appendSlice(self.alloc, prop.name);
            try self.writeSpace();
            try self.buf.append(self.alloc, '{');
            self.indent += 1;
            try self.writeNewline();
            try self.buf.appendSlice(self.alloc, "syntax:");
            try self.writeSpace();
            try self.buf.appendSlice(self.alloc, "\"");
            try self.buf.appendSlice(self.alloc, prop.syntax);
            try self.buf.appendSlice(self.alloc, "\";");
            try self.writeNewline();
            try self.buf.appendSlice(self.alloc, "inherits:");
            try self.writeSpace();
            if (prop.inherits) {
                try self.buf.appendSlice(self.alloc, "true");
            } else {
                try self.buf.appendSlice(self.alloc, "false");
            }
            if (prop.initial_value) |iv| {
                try self.buf.append(self.alloc, ';');
                try self.writeNewline();
                try self.buf.appendSlice(self.alloc, "initial-value:");
                try self.writeSpace();
                try self.buf.appendSlice(self.alloc, iv);
            }
            self.indent -= 1;
            try self.writeNewline();
            try self.buf.append(self.alloc, '}');
            try self.writeNewline();
        }
    }

    /// Emit @keyframes declarations.
    fn emitKeyframes(self: *CssEmitter) !void {
        std.mem.sort(Keyframes, self.keyframes.items, {}, struct {
            fn lessThan(_: void, a: Keyframes, b: Keyframes) bool {
                return std.mem.order(u8, a.name, b.name) == .lt;
            }
        }.lessThan);
        for (self.keyframes.items) |kf| {
            try self.buf.appendSlice(self.alloc, "@keyframes ");
            try self.buf.appendSlice(self.alloc, kf.name);
            try self.writeSpace();
            try self.buf.append(self.alloc, '{');
            try self.buf.appendSlice(self.alloc, kf.body);
            try self.buf.append(self.alloc, '}');
            try self.writeNewline();
        }
    }

    /// Emit @layer utilities with all generated rules.
    fn emitUtilitiesLayer(self: *CssEmitter, rules: []const Rule) !void {
        if (rules.len == 0) return;

        try self.buf.appendSlice(self.alloc, "@layer utilities");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        for (rules) |rule| {
            try self.emitRule(&rule);
        }
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
        try self.writeNewline();
    }

    /// Emit a single CSS rule.
    fn emitRule(self: *CssEmitter, rule: *const Rule) !void {
        switch (rule.kind) {
            .style => {
                if (rule.selector) |sel| {
                    try self.writeNewline();
                    try self.buf.appendSlice(self.alloc, sel);
                    try self.writeSpace();
                    try self.buf.append(self.alloc, '{');
                    self.indent += 1;
                    try self.emitDeclarations(rule.declarations);
                    try self.emitSupportsEnhancement(rule.declarations);
                    for (rule.children) |child| {
                        try self.emitRule(&child);
                    }
                    self.indent -= 1;
                    try self.writeNewline();
                    try self.buf.append(self.alloc, '}');
                }
            },
            .media, .container, .supports, .layer => {
                const at = rule.at_rule orelse return;
                try self.writeNewline();
                try self.buf.appendSlice(self.alloc, at);
                try self.writeSpace();
                try self.buf.append(self.alloc, '{');
                self.indent += 1;
                for (rule.children) |child| {
                    try self.emitRule(&child);
                }
                self.indent -= 1;
                try self.writeNewline();
                try self.buf.append(self.alloc, '}');
            },
            .at_starting_style => {
                try self.writeNewline();
                try self.buf.appendSlice(self.alloc, "@starting-style");
                try self.writeSpace();
                try self.buf.append(self.alloc, '{');
                self.indent += 1;
                for (rule.children) |child| {
                    try self.emitRule(&child);
                }
                self.indent -= 1;
                try self.writeNewline();
                try self.buf.append(self.alloc, '}');
            },
            .at_property => {
                // @property rules are emitted separately via emitAtProperties
            },
        }
    }

    /// Emit a nested @supports block for color-mix() progressive enhancement.
    /// Only emits if any declarations have supports_value set.
    fn emitSupportsEnhancement(self: *CssEmitter, decls: []const Declaration) !void {
        var has_any = false;
        for (decls) |d| {
            if (d.supports_value != null) { has_any = true; break; }
        }
        if (!has_any) return;

        try self.writeNewline();
        try self.buf.appendSlice(self.alloc, "@supports (color:color-mix(in lab,red,red))");
        try self.writeSpace();
        try self.buf.append(self.alloc, '{');
        self.indent += 1;
        for (decls) |decl| {
            if (decl.supports_value) |enhanced| {
                try self.writeNewline();
                try self.buf.appendSlice(self.alloc, decl.property);
                try self.buf.append(self.alloc, ':');
                try self.writeSpace();
                try self.buf.appendSlice(self.alloc, enhanced);
                if (decl.important) {
                    try self.writeSpace();
                    try self.buf.appendSlice(self.alloc, "!important");
                }
                if (!self.minify) try self.buf.append(self.alloc, ';');
            }
        }
        self.indent -= 1;
        try self.writeNewline();
        try self.buf.append(self.alloc, '}');
    }

    /// Emit declarations for a rule block.
    fn emitDeclarations(self: *CssEmitter, decls: []const Declaration) !void {
        if (self.minify) {
            // Minified: no whitespace
            var total: usize = 0;
            for (decls, 0..) |decl, i| {
                if (i > 0) total += 1;
                total += decl.property.len + 1 + decl.value.len;
                if (decl.important) total += 10;
            }
            try self.buf.ensureUnusedCapacity(self.alloc, total);

            for (decls, 0..) |decl, i| {
                if (i > 0) self.buf.appendAssumeCapacity(';');
                self.buf.appendSliceAssumeCapacity(decl.property);
                self.buf.appendAssumeCapacity(':');
                self.buf.appendSliceAssumeCapacity(decl.value);
                if (decl.important) self.buf.appendSliceAssumeCapacity("!important");
            }
        } else {
            // Pretty: one declaration per line with indentation
            for (decls) |decl| {
                try self.writeNewline();
                try self.buf.appendSlice(self.alloc, decl.property);
                try self.buf.appendSlice(self.alloc, ": ");
                try self.buf.appendSlice(self.alloc, decl.value);
                if (decl.important) try self.buf.appendSlice(self.alloc, " !important");
                try self.buf.append(self.alloc, ';');
            }
        }
    }

    pub fn getOutput(self: *const CssEmitter) []const u8 {
        return self.buf.items;
    }
};

const UsedVar = struct {
    name: []const u8,
    value: []const u8,
};

// ─── Minified Preflight CSS ────────────────────────────────────────────────

pub const preflight_css =
    \\*,::after,::before,::backdrop,::file-selector-button{box-sizing:border-box;margin:0;padding:0;border:0 solid}html,:host{line-height:1.5;-webkit-text-size-adjust:100%;tab-size:4;font-family:var(--default-font-family,ui-sans-serif,system-ui,sans-serif,'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol','Noto Color Emoji');font-feature-settings:var(--default-font-feature-settings,normal);font-variation-settings:var(--default-font-variation-settings,normal);-webkit-tap-highlight-color:transparent}hr{height:0;color:inherit;border-top-width:1px}abbr:where([title]){-webkit-text-decoration:underline dotted;text-decoration:underline dotted}h1,h2,h3,h4,h5,h6{font-size:inherit;font-weight:inherit}a{color:inherit;-webkit-text-decoration:inherit;text-decoration:inherit}b,strong{font-weight:bolder}code,kbd,samp,pre{font-family:var(--default-mono-font-family,ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,'Liberation Mono','Courier New',monospace);font-feature-settings:var(--default-mono-font-feature-settings,normal);font-variation-settings:var(--default-mono-font-variation-settings,normal);font-size:1em}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sub{bottom:-.25em}sup{top:-.5em}table{text-indent:0;border-color:inherit;border-collapse:collapse}:-moz-focusring{outline:auto}progress{vertical-align:baseline}summary{display:list-item}ol,ul,menu{list-style:none}img,svg,video,canvas,audio,iframe,embed,object{display:block;vertical-align:middle}img,video{max-width:100%;height:auto}button,input,select,optgroup,textarea,::file-selector-button{font:inherit;font-feature-settings:inherit;font-variation-settings:inherit;letter-spacing:inherit;color:inherit;border-radius:0;background-color:transparent;opacity:1}:where(select:is([multiple],[size])) optgroup{font-weight:bolder}:where(select:is([multiple],[size])) optgroup option{padding-inline-start:20px}::file-selector-button{margin-inline-end:4px}::placeholder{opacity:1}@supports (not (-webkit-appearance:-apple-pay-button)) or (contain-intrinsic-size:1px){::placeholder{color:color-mix(in oklab,currentcolor 50%,transparent)}}textarea{resize:vertical}::-webkit-search-decoration{-webkit-appearance:none}::-webkit-date-and-time-value{min-height:1lh;text-align:inherit}::-webkit-datetime-edit{display:inline-flex}::-webkit-datetime-edit-fields-wrapper{padding:0}::-webkit-datetime-edit,::-webkit-datetime-edit-year-field,::-webkit-datetime-edit-month-field,::-webkit-datetime-edit-day-field,::-webkit-datetime-edit-hour-field,::-webkit-datetime-edit-minute-field,::-webkit-datetime-edit-second-field,::-webkit-datetime-edit-millisecond-field,::-webkit-datetime-edit-meridiem-field{padding-block:0}::-webkit-calendar-picker-indicator{line-height:1}:-moz-ui-invalid{box-shadow:none}button,input:where([type='button'],[type='reset'],[type='submit']),::file-selector-button{appearance:button}::-webkit-inner-spin-button,::-webkit-outer-spin-button{height:auto}[hidden]:where(:not([hidden='until-found'])){display:none!important}
;

// ─── Tests ─────────────────────────────────────────────────────────────────

test "escapeCssIdentifier: basic" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "flex");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("flex", result);
}

test "escapeCssIdentifier: colon" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "hover:underline");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("hover\\:underline", result);
}

test "escapeCssIdentifier: slash" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "w-1/2");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("w-1\\/2", result);
}

test "escapeCssIdentifier: brackets" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "bg-[#0088cc]");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("bg-\\[\\#0088cc\\]", result);
}

test "escapeCssIdentifier: dot" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "m-1.5");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("m-1\\.5", result);
}

test "escapeCssIdentifier: leading digit" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "2xl");
    defer alloc.free(result);
    // Leading digit gets hex escaped: \32 xl
    try std.testing.expectEqualStrings("\\32 xl", result);
}

test "escapeCssIdentifier: exclamation" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "underline!");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("underline\\!", result);
}

test "escapeCssIdentifier: percent" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "w-75%");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("w-75\\%", result);
}

test "escapeCssIdentifier: at sign" {
    const alloc = std.testing.allocator;

    const result = try escapeCssIdentifier(alloc, "@lg");
    defer alloc.free(result);
    try std.testing.expectEqualStrings("\\@lg", result);
}
