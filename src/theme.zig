const std = @import("std");
const Allocator = std.mem.Allocator;
const default_theme = @import("default_theme.zig");

/// Theme holds resolved CSS custom property values.
/// It is constructed from the default theme + user overrides.
pub const Theme = struct {
    alloc: Allocator,

    /// All theme variables: key = "--color-red-500", value = "oklch(63.7% 0.237 25.331)"
    variables: std.StringHashMap([]const u8),

    /// Track which variables are actually used (for tree-shaking)
    used_variables: std.StringHashMap(void),

    /// Base spacing value (e.g., "0.25rem")
    spacing_base: []const u8 = "0.25rem",

    /// Breakpoints: name -> value (e.g., "sm" -> "40rem")
    breakpoints: std.StringHashMap([]const u8),

    /// Container sizes: name -> value (e.g., "lg" -> "32rem")
    containers: std.StringHashMap([]const u8),

    pub fn init(alloc: Allocator) Theme {
        return Theme{
            .alloc = alloc,
            .variables = std.StringHashMap([]const u8).init(alloc),
            .used_variables = std.StringHashMap(void).init(alloc),
            .breakpoints = std.StringHashMap([]const u8).init(alloc),
            .containers = std.StringHashMap([]const u8).init(alloc),
        };
    }

    pub fn deinit(self: *Theme) void {
        self.variables.deinit();
        self.used_variables.deinit();
        self.breakpoints.deinit();
        self.containers.deinit();
    }

    /// Load the default Tailwind v4 theme.
    pub fn loadDefaults(self: *Theme) !void {
        // Load colors
        for (default_theme.colors) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load breakpoints
        for (default_theme.breakpoints) |entry| {
            try self.breakpoints.put(entry.key, entry.value);
            const var_name = try std.fmt.allocPrint(self.alloc, "--breakpoint-{s}", .{entry.key});
            try self.variables.put(var_name, entry.value);
        }

        // Load container sizes
        for (default_theme.container_sizes) |entry| {
            try self.containers.put(entry.key, entry.value);
            const var_name = try std.fmt.allocPrint(self.alloc, "--container-{s}", .{entry.key});
            try self.variables.put(var_name, entry.value);
        }

        // Load font families
        for (default_theme.font_families) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load font sizes
        for (default_theme.font_sizes) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load font weights
        for (default_theme.font_weights) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load letter spacing
        for (default_theme.letter_spacings) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load line heights
        for (default_theme.line_heights) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load border radius
        for (default_theme.border_radii) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load shadows
        for (default_theme.shadows) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load inset shadows
        for (default_theme.inset_shadows) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load drop shadows
        for (default_theme.drop_shadows) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load blurs
        for (default_theme.blurs) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load easings
        for (default_theme.easings) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load animations
        for (default_theme.animations) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load perspectives
        for (default_theme.perspectives) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load aspect ratios
        for (default_theme.aspect_ratios) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load text shadows
        for (default_theme.text_shadows) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Load defaults
        for (default_theme.defaults) |entry| {
            try self.variables.put(entry.key, entry.value);
        }

        // Spacing base
        try self.variables.put("--spacing", "0.25rem");
    }

    /// Parse and apply user theme overrides from JSON.
    pub fn parseJson(self: *Theme, json_str: []const u8) !void {
        var parsed = try std.json.parseFromSlice(std.json.Value, self.alloc, json_str, .{});
        defer parsed.deinit();

        const root = parsed.value;
        if (root != .object) return;

        var iter = root.object.iterator();
        while (iter.next()) |entry| {
            const key = entry.key_ptr.*;
            const val = entry.value_ptr.*;

            if (std.mem.eql(u8, key, "spacing")) {
                if (val == .string) {
                    self.spacing_base = try self.alloc.dupe(u8, val.string);
                    try self.variables.put("--spacing", self.spacing_base);
                }
            } else if (std.mem.eql(u8, key, "breakpoints")) {
                if (val == .object) {
                    var bp_iter = val.object.iterator();
                    while (bp_iter.next()) |bp| {
                        if (bp.value_ptr.* == .string) {
                            const bp_key = try self.alloc.dupe(u8, bp.key_ptr.*);
                            const bp_val = try self.alloc.dupe(u8, bp.value_ptr.*.string);
                            try self.breakpoints.put(bp_key, bp_val);
                        }
                    }
                }
            } else if (std.mem.eql(u8, key, "colors")) {
                if (val == .object) {
                    try self.loadNestedThemeValues(val.object, "--color");
                }
            } else {
                // Map known JSON keys to CSS custom property prefixes
                const prefix = jsonKeyToPrefix(key);
                if (val == .object) {
                    try self.loadNestedThemeValues(val.object, prefix);
                } else if (val == .string) {
                    const var_name = try std.fmt.allocPrint(self.alloc, "{s}", .{prefix});
                    try self.variables.put(var_name, try self.alloc.dupe(u8, val.string));
                }
            }
        }
    }

    /// Load nested theme values from a JSON object into variables with a given prefix.
    /// E.g., {"heading": "Manrope, sans-serif"} with prefix "--font" → --font-heading = "Manrope, sans-serif"
    /// Handles arbitrary nesting depth (e.g., colors.brand.primary.light → --color-brand-primary-light).
    fn loadNestedThemeValues(self: *Theme, obj: std.json.ObjectMap, prefix: []const u8) !void {
        var obj_iter = obj.iterator();
        while (obj_iter.next()) |entry| {
            const k = entry.key_ptr.*;
            const v = entry.value_ptr.*;
            const var_name = try std.fmt.allocPrint(self.alloc, "{s}-{s}", .{ prefix, k });
            if (v == .string) {
                const var_val = try self.alloc.dupe(u8, v.string);
                try self.variables.put(var_name, var_val);
            } else if (v == .object) {
                // Recurse for deeper nesting
                try self.loadNestedThemeValues(v.object, var_name);
            }
        }
    }

    /// Resolve a named value in a given namespace.
    /// E.g., resolve("blue-500", "--color") checks for --color-blue-500 in variables.
    /// Returns true if the variable exists, false otherwise.
    pub fn resolve(self: *Theme, value: []const u8, namespace: []const u8) bool {
        // Build the variable name: namespace-value
        var buf: [512]u8 = undefined;
        const var_name = std.fmt.bufPrint(&buf, "{s}-{s}", .{ namespace, value }) catch return false;

        if (self.variables.get(var_name)) |_| {
            // Mark as used — must dupe the key since buf is stack-allocated
            const duped = self.alloc.dupe(u8, var_name) catch return true;
            self.used_variables.put(duped, {}) catch {};
            return true;
        }
        return false;
    }

    /// Get a raw theme variable value.
    pub fn get(self: *const Theme, var_name: []const u8) ?[]const u8 {
        return self.variables.get(var_name);
    }

    /// Mark a variable as used (for tree-shaking).
    pub fn markUsed(self: *Theme, var_name: []const u8) void {
        // Only insert if not already present to avoid duplicate key issues
        if (!self.used_variables.contains(var_name)) {
            const duped = self.alloc.dupe(u8, var_name) catch return;
            self.used_variables.put(duped, {}) catch {};
        }
    }

    /// Get a breakpoint value by name.
    pub fn getBreakpoint(self: *const Theme, name: []const u8) ?[]const u8 {
        return self.breakpoints.get(name);
    }

    /// Get a container size by name.
    pub fn getContainer(self: *const Theme, name: []const u8) ?[]const u8 {
        return self.containers.get(name);
    }
};

// ─── Tests ─────────────────────────────────────────────────────────────────

/// Map JSON theme key names to CSS custom property prefixes.
fn jsonKeyToPrefix(key: []const u8) []const u8 {
    const map = std.StaticStringMap([]const u8).initComptime(.{
        .{ "fontFamily", "--font" },
        .{ "fontSize", "--text" },
        .{ "fontWeight", "--font-weight" },
        .{ "letterSpacing", "--tracking" },
        .{ "lineHeight", "--leading" },
        .{ "borderRadius", "--radius" },
        .{ "maxWidth", "--max-width" },
        .{ "height", "--height" },
        .{ "boxShadow", "--shadow" },
        .{ "transitionDuration", "--duration" },
        .{ "transitionProperty", "--transition-property" },
        .{ "gridTemplateColumns", "--grid-template-columns" },
        .{ "gridTemplateRows", "--grid-template-rows" },
        .{ "aspectRatio", "--aspect" },
        .{ "spacing", "--spacing" },
    });
    return map.get(key) orelse "--unknown";
}

test "Theme: init and basic operations" {
    const alloc = std.testing.allocator;
    var theme = Theme.init(alloc);
    defer theme.deinit();

    try theme.variables.put("--color-red-500", "oklch(63.7% 0.237 25.331)");
    try std.testing.expectEqualStrings("oklch(63.7% 0.237 25.331)", theme.get("--color-red-500").?);
}

test "Theme: resolve namespace" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    var theme = Theme.init(alloc);
    defer theme.deinit();

    try theme.variables.put("--color-red-500", "oklch(63.7% 0.237 25.331)");
    const resolved = theme.resolve("red-500", "--color");
    try std.testing.expect(resolved);
}

test "Theme: parse JSON" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    var theme = Theme.init(alloc);
    defer theme.deinit();

    const json =
        \\{"spacing":"0.5rem","colors":{"brand":"#3f3cbb"}}
    ;
    try theme.parseJson(json);

    try std.testing.expectEqualStrings("0.5rem", theme.spacing_base);
    try std.testing.expect(theme.get("--color-brand") != null);
}
