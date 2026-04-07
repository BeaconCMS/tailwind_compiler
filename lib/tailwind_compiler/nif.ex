defmodule TailwindCompiler.NIF do
  @moduledoc false

  use Zig,
    otp_app: :tailwind_compiler,
    nifs: [compile: [:dirty_cpu]],
    leak_check: false,
    extra_modules: [
      compiler: {"../../src/compiler.zig", []},
      candidate: {"../../src/candidate.zig", []},
      utilities: {"../../src/utilities.zig", []},
      variants: {"../../src/variants.zig", []},
      emitter: {"../../src/emitter.zig", []},
      theme: {"../../src/theme.zig", []},
      default_theme: {"../../src/default_theme.zig", []},
      color: {"../../src/color.zig", []}
    ]

  ~Z"""
  const beam = @import("beam");
  const std = @import("std");
  const compiler = @import("compiler");

  /// Compile a list of Tailwind CSS candidate strings into minified CSS.
  pub fn compile(candidates_term: beam.term, theme_json_term: beam.term, preflight_term: beam.term, custom_css_term: beam.term) ![]u8 {
      var arena = std.heap.ArenaAllocator.init(beam.allocator);
      defer arena.deinit();
      const alloc = arena.allocator();

      // Marshal candidates: list of binaries -> [][]const u8
      const candidates = try beam.get([][]const u8, candidates_term, .{ .allocator = alloc });

      // Marshal theme JSON: binary -> ?[]const u8 (empty string = null)
      const theme_raw = beam.get([]const u8, theme_json_term, .{}) catch "";
      const theme_json: ?[]const u8 = if (theme_raw.len == 0) null else theme_raw;

      // Marshal preflight flag
      const include_preflight = beam.get(bool, preflight_term, .{}) catch true;

      // Marshal custom CSS: binary -> ?[]const u8 (empty string = null)
      const custom_raw = beam.get([]const u8, custom_css_term, .{}) catch "";
      const custom_css: ?[]const u8 = if (custom_raw.len == 0) null else custom_raw;

      // Call the Zig compiler
      const css = try compiler.compile(alloc, candidates, theme_json, include_preflight, custom_css);

      // Return owned slice (Zigler auto-marshals []u8 to binary)
      return try beam.allocator.dupe(u8, css);
  }
  """
end
