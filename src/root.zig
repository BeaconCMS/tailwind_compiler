//! Tailwind CSS v4-compatible compiler written in Zig.
//!
//! Accepts a list of CSS class candidate strings and returns minified production CSS.
//! Everything happens in memory — no filesystem, no external processes.

const std = @import("std");
pub const compiler = @import("compiler.zig");
pub const candidate = @import("candidate.zig");
pub const utilities = @import("utilities.zig");
pub const variants = @import("variants.zig");
pub const emitter = @import("emitter.zig");
pub const theme = @import("theme.zig");
pub const default_theme = @import("default_theme.zig");
pub const color = @import("color.zig");

/// Compile a list of candidate strings into minified CSS.
///
/// - `candidates`: Tailwind class names (e.g., "flex", "hover:bg-blue-500/50")
/// - `theme_json`: Optional JSON string with theme overrides
/// - `include_preflight`: Whether to include the base CSS reset
/// - `custom_css`: Optional raw CSS to append after @layer utilities
/// - `custom_utilities_json`: Optional JSON object mapping class names to CSS declarations
/// - `plugin_css`: Optional CSS output from a Tailwind plugin (e.g., DaisyUI).
///   Color variables (--color-*) are extracted and registered as theme colors,
///   and all CSS (components, theme blocks) is included in the output.
///
/// Returns minified CSS string. Caller owns the returned memory.
pub fn compile(
    alloc: std.mem.Allocator,
    candidates: []const []const u8,
    theme_json: ?[]const u8,
    include_preflight: bool,
    custom_css: ?[]const u8,
    custom_utilities_json: ?[]const u8,
    plugin_css: ?[]const u8,
) ![]const u8 {
    return compiler.compile(alloc, candidates, theme_json, include_preflight, custom_css, custom_utilities_json, plugin_css);
}

pub const tw_tests = @import("tw_tests.zig");

test {
    // Run all tests from submodules
    std.testing.refAllDeclsRecursive(@This());
}
