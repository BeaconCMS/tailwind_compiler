const std = @import("std");
const tailwind = @import("tailwind_compiler");

pub fn main() !void {
    var gpa_instance = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa_instance.deinit();
    const gpa = gpa_instance.allocator();

    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    // Mode: if --time flag, print timing to stderr
    var time_mode = false;
    var file_arg: ?[]const u8 = null;
    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "--time")) {
            time_mode = true;
        } else {
            file_arg = arg;
        }
    }

    // Read candidates from file
    const input = if (file_arg) |path|
        try std.fs.cwd().readFileAlloc(gpa, path, 4 * 1024 * 1024)
    else
        return error.NoInputFile;
    defer gpa.free(input);

    // Split into lines
    var lines: std.ArrayList([]const u8) = .empty;
    defer lines.deinit(gpa);

    var iter = std.mem.splitScalar(u8, input, '\n');
    while (iter.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \t\r");
        if (trimmed.len > 0) {
            try lines.append(gpa, trimmed);
        }
    }

    // Compile with timing
    var timer = std.time.Timer.start() catch unreachable;

    const css = try tailwind.compile(gpa, lines.items, null, true, null);
    defer gpa.free(css);

    const elapsed_ns = timer.read();
    const elapsed_us: f64 = @as(f64, @floatFromInt(elapsed_ns)) / 1000.0;
    const elapsed_ms: f64 = elapsed_us / 1000.0;

    // Write CSS to stdout
    const stdout = std.fs.File.stdout();
    try stdout.writeAll(css);

    // Write timing to stderr if requested
    if (time_mode) {
        var stderr_buf: [256]u8 = undefined;
        var stderr_writer = std.fs.File.stderr().writer(&stderr_buf);
        const stderr = &stderr_writer.interface;
        try stderr.print("{{\"elapsed_us\":{d:.0},\"elapsed_ms\":{d:.3},\"candidates\":{d},\"output_bytes\":{d}}}\n", .{
            elapsed_us,
            elapsed_ms,
            lines.items.len,
            css.len,
        });
        try stderr.flush();
    }
}
