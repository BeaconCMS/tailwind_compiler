const std = @import("std");
const root = @import("root.zig");

const allocator = std.mem.Allocator{
    .ptr = undefined,
    .vtable = &std.heap.WasmAllocator.vtable,
};

/// Allocate memory from the WASM linear memory. Called by the JS host to
/// prepare input buffers before invoking compile().
export fn alloc(len: usize) ?[*]u8 {
    const slice = allocator.alloc(u8, len) catch return null;
    return slice.ptr;
}

/// Free a pointer previously returned by alloc() or compile().
export fn free(ptr: [*]u8, len: usize) void {
    allocator.free(ptr[0..len]);
}

/// Compile Tailwind CSS from a newline-delimited list of candidate strings.
///
/// Parameters are pointers+lengths into WASM linear memory (written by the
/// JS host via alloc()). Pass 0/0 for optional parameters to omit them.
///
/// Returns a packed u64:  high 32 bits = pointer, low 32 bits = length.
/// The caller owns the returned buffer and must free() it when done.
/// Returns 0 on error.
export fn compile(
    candidates_ptr: [*]const u8,
    candidates_len: usize,
    theme_json_ptr: [*]const u8,
    theme_json_len: usize,
    include_preflight: bool,
    minify: bool,
    custom_css_ptr: [*]const u8,
    custom_css_len: usize,
    custom_utilities_json_ptr: [*]const u8,
    custom_utilities_json_len: usize,
    plugin_css_ptr: [*]const u8,
    plugin_css_len: usize,
) u64 {
    return compileInner(
        candidates_ptr,
        candidates_len,
        theme_json_ptr,
        theme_json_len,
        include_preflight,
        minify,
        custom_css_ptr,
        custom_css_len,
        custom_utilities_json_ptr,
        custom_utilities_json_len,
        plugin_css_ptr,
        plugin_css_len,
    ) catch return 0;
}

fn compileInner(
    candidates_ptr: [*]const u8,
    candidates_len: usize,
    theme_json_ptr: [*]const u8,
    theme_json_len: usize,
    include_preflight: bool,
    minify: bool,
    custom_css_ptr: [*]const u8,
    custom_css_len: usize,
    custom_utilities_json_ptr: [*]const u8,
    custom_utilities_json_len: usize,
    plugin_css_ptr: [*]const u8,
    plugin_css_len: usize,
) !u64 {
    // Parse newline-delimited candidates into a slice of slices.
    const candidates_raw = candidates_ptr[0..candidates_len];
    var candidate_list: std.ArrayList([]const u8) = .empty;
    defer candidate_list.deinit(allocator);

    var iter = std.mem.splitScalar(u8, candidates_raw, '\n');
    while (iter.next()) |line| {
        if (line.len > 0) {
            try candidate_list.append(allocator, line);
        }
    }

    const theme_json: ?[]const u8 = if (theme_json_len > 0) theme_json_ptr[0..theme_json_len] else null;
    const custom_css: ?[]const u8 = if (custom_css_len > 0) custom_css_ptr[0..custom_css_len] else null;
    const custom_utilities_json: ?[]const u8 = if (custom_utilities_json_len > 0) custom_utilities_json_ptr[0..custom_utilities_json_len] else null;
    const plugin_css: ?[]const u8 = if (plugin_css_len > 0) plugin_css_ptr[0..plugin_css_len] else null;

    const result = try root.compile(
        allocator,
        candidate_list.items,
        theme_json,
        include_preflight,
        minify,
        custom_css,
        custom_utilities_json,
        plugin_css,
    );

    // Pack pointer and length into a single u64 for the return value.
    const ptr_val: u32 = @intFromPtr(result.ptr);
    const len_val: u32 = @intCast(result.len);
    return (@as(u64, ptr_val) << 32) | @as(u64, len_val);
}
