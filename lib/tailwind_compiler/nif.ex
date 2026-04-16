if TailwindCompiler.Native.use_precompiled?() do
  defmodule TailwindCompiler.NIF do
    @moduledoc false

    @on_load :__load_nif__

    @doc false
    def __load_nif__ do
      path = TailwindCompiler.Native.nif_path() |> String.to_charlist()
      :erlang.load_nif(path, 0)
    end

    # Zigler registers NIF functions with a "marshalled-" prefix.
    # These stubs must match the names in the precompiled .so.
    def unquote(:"marshalled-compile")(_candidates, _theme_json, _preflight, _custom_css, _custom_utilities, _plugin_css),
      do: :erlang.nif_error(:not_loaded)

    def unquote(:"marshalled-validate")(_tokens),
      do: :erlang.nif_error(:not_loaded)

    def compile(candidates, theme_json, preflight, custom_css, custom_utilities, plugin_css),
      do: unquote(:"marshalled-compile")(candidates, theme_json, preflight, custom_css, custom_utilities, plugin_css)

    def validate(tokens),
      do: unquote(:"marshalled-validate")(tokens)
  end
else
  defmodule TailwindCompiler.NIF do
    @moduledoc false

    use Zig,
      otp_app: :tailwind_compiler,
      nifs: [compile: [:dirty_cpu], validate: [:dirty_cpu]],
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
    pub fn compile(candidates_term: beam.term, theme_json_term: beam.term, preflight_term: beam.term, custom_css_term: beam.term, custom_utilities_term: beam.term, plugin_css_term: beam.term) ![]u8 {
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

        // Marshal custom utilities JSON: binary -> ?[]const u8 (empty string = null)
        const custom_util_raw = beam.get([]const u8, custom_utilities_term, .{}) catch "";
        const custom_utilities: ?[]const u8 = if (custom_util_raw.len == 0) null else custom_util_raw;

        // Marshal plugin CSS: binary -> ?[]const u8 (empty string = null)
        const plugin_raw = beam.get([]const u8, plugin_css_term, .{}) catch "";
        const plugin_css: ?[]const u8 = if (plugin_raw.len == 0) null else plugin_raw;

        // Call the Zig compiler
        const css = try compiler.compile(alloc, candidates, theme_json, include_preflight, custom_css, custom_utilities, plugin_css);

        // Return owned slice (Zigler auto-marshals []u8 to binary)
        return try beam.allocator.dupe(u8, css);
    }

    /// Validate a list of token strings, returning only valid Tailwind utilities.
    /// Returns the valid tokens as a newline-separated binary string.
    pub fn validate(tokens_term: beam.term) ![]u8 {
        var arena = std.heap.ArenaAllocator.init(beam.allocator);
        defer arena.deinit();
        const alloc = arena.allocator();

        // Marshal tokens: list of binaries -> [][]const u8
        const tokens = try beam.get([][]const u8, tokens_term, .{ .allocator = alloc });

        // Call the Zig validator
        const valid = try compiler.validate(alloc, tokens);

        // Join valid tokens with newlines
        var total_len: usize = 0;
        for (valid) |v| {
            total_len += v.len + 1; // +1 for newline
        }
        if (total_len > 0) total_len -= 1; // no trailing newline

        if (total_len == 0) {
            return try beam.allocator.dupe(u8, "");
        }

        var result = try beam.allocator.alloc(u8, total_len);
        var pos: usize = 0;
        for (valid, 0..) |v, i| {
            @memcpy(result[pos .. pos + v.len], v);
            pos += v.len;
            if (i < valid.len - 1) {
                result[pos] = '\n';
                pos += 1;
            }
        }

        return result;
    }
    """
  end
end
