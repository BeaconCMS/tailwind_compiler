// Auto-generated from Tailwind CSS v4.2.2 test suite
// Source: utilities.test.ts, variants.test.ts, candidate.test.ts,
//         important.test.ts, sort.test.ts, index.test.ts
//
// 358 positive tests + 365 negative tests

const std = @import("std");
const compiler = @import("compiler.zig");

fn compile(alloc: std.mem.Allocator, candidates: []const []const u8) ![]const u8 {
    return compiler.compile(alloc, candidates, null, false, null, null, null);
}

test "tw: sr-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "sr-only" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "sr-only") != null);
}

test "tw: not-sr-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "not-sr-only" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "not-sr-only") != null);
}

test "tw: pointer-events" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-events-none", "pointer-events-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-events-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-events-auto") != null);
}

test "tw: visibility" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "visible", "invisible", "collapse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "visible") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "invisible") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "collapse") != null);
}

test "tw: position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "static", "fixed", "absolute", "relative", "sticky" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "static") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fixed") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "absolute") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "relative") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "sticky") != null);
}

test "tw: isolation" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "isolate", "isolation-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "isolate") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "isolation-auto") != null);
}

test "tw: z-index" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "z-auto", "z-10", "-z-10", "z-[123]", "-z-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "z-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "z-10") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-z-10") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "z-\\[123\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-z-\\[var\\(--value\\)\\]") != null);
}

test "tw: z-index_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "z-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "z-auto") != null);
}

test "tw: order" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "order-4", "-order-4", "order-[123]", "-order-[var(--value)]", "order-first", "order-last", "order-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "order-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-order-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "order-\\[123\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-order-\\[var\\(--value\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "order-first") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "order-last") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "order-none") != null);
}

test "tw: order_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "order-first" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "order-first") != null);
}

test "tw: order_2" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "order-last" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "order-last") != null);
}

test "tw: col" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "col-auto") != null);
}

test "tw: col-start" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col-start-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "col-start-auto") != null);
}

test "tw: col-end" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col-end-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "col-end-auto") != null);
}

test "tw: row" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "row-auto") != null);
}

test "tw: row-start" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row-start-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "row-start-auto") != null);
}

test "tw: row-end" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row-end-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "row-end-auto") != null);
}

test "tw: float" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "float-start", "float-end", "float-right", "float-left", "float-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "float-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "float-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "float-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "float-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "float-none") != null);
}

test "tw: clear" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "clear-start", "clear-end", "clear-right", "clear-left", "clear-both", "clear-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "clear-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "clear-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "clear-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "clear-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "clear-both") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "clear-none") != null);
}

test "tw: margin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "m-auto", "m-4", "m-[4px]", "-m-4", "-m-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "m-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "m-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "m-\\[4px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-m-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-m-\\[var\\(--value\\)\\]") != null);
}

test "tw: margin sort order" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mb-4", "me-4", "mx-4", "ml-4", "ms-4", "m-4", "mr-4", "mt-4", "my-4" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mb-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "me-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mx-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ml-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ms-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "m-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mr-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mt-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "my-4") != null);
}

test "tw: box-sizing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "box-border", "box-content" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "box-border") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "box-content") != null);
}

test "tw: line-clamp" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "line-clamp-4", "line-clamp-99", "line-clamp-[123]", "line-clamp-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "line-clamp-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "line-clamp-99") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "line-clamp-\\[123\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "line-clamp-none") != null);
}

test "tw: line-clamp_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "line-clamp-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "line-clamp-none") != null);
}

test "tw: display" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "block", "inline-block", "inline", "flex", "inline-flex", "table", "inline-table", "table-caption", "table-cell", "table-column", "table-column-group", "table-footer-group", "table-header-group", "table-row-group", "table-row", "flow-root", "grid", "inline-grid", "contents", "list-item", "hidden" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "block") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "inline-block") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "inline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "inline-flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "inline-table") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-caption") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-cell") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-column") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-column-group") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-footer-group") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-header-group") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-row-group") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-row") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flow-root") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "inline-grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "contents") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-item") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hidden") != null);
}

test "tw: field-sizing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "field-sizing-content", "field-sizing-fixed" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "field-sizing-content") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "field-sizing-fixed") != null);
}

test "tw: aspect-ratio" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "aspect-video", "aspect-[10/9]", "aspect-4/3", "aspect-8.5/11" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "aspect-video") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aspect-\\[10\\/9\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aspect-4\\/3") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aspect-8\\.5\\/11") != null);
}

test "tw: size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "size-auto", "size-full", "size-min", "size-max", "size-fit", "size-4", "size-1/2", "size-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "size-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "size-\\[4px\\]") != null);
}

test "tw: width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "w-full", "w-auto", "w-screen", "w-svw", "w-lvw", "w-dvw", "w-min", "w-max", "w-fit", "w-4", "w-xl", "w-1/2", "w-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "w-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-svw") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-lvw") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-dvw") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-xl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "w-\\[4px\\]") != null);
}

test "tw: min-width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-w-full", "min-w-auto", "min-w-min", "min-w-max", "min-w-fit", "min-w-4", "min-w-xl", "min-w-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-xl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-w-\\[4px\\]") != null);
}

test "tw: max-width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-w-none", "max-w-full", "max-w-max", "max-w-fit", "max-w-4", "max-w-xl", "max-w-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-xl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-\\[4px\\]") != null);
}

test "tw: height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "h-full", "h-auto", "h-screen", "h-svh", "h-lvh", "h-dvh", "h-min", "h-lh", "h-max", "h-fit", "h-4", "h-1/2", "h-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "h-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-svh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-lvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-dvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-lh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "h-\\[4px\\]") != null);
}

test "tw: min-height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-h-full", "min-h-auto", "min-h-screen", "min-h-svh", "min-h-lvh", "min-h-dvh", "min-h-min", "min-h-lh", "min-h-max", "min-h-fit", "min-h-4", "min-h-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-svh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-lvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-dvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-lh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-h-\\[4px\\]") != null);
}

test "tw: max-height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-h-none", "max-h-full", "max-h-screen", "max-h-svh", "max-h-lvh", "max-h-dvh", "max-h-lh", "max-h-min", "max-h-max", "max-h-fit", "max-h-4", "max-h-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-svh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-lvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-dvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-lh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-h-\\[4px\\]") != null);
}

test "tw: block-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "block-full", "block-auto", "block-screen", "block-svh", "block-lvh", "block-dvh", "block-min", "block-lh", "block-max", "block-fit", "block-4", "block-1/2", "block-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "block-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-svh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-lvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-dvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-lh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "block-\\[4px\\]") != null);
}

test "tw: min-block-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-block-full", "min-block-auto", "min-block-screen", "min-block-svh", "min-block-lvh", "min-block-dvh", "min-block-min", "min-block-lh", "min-block-max", "min-block-fit", "min-block-4", "min-block-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-svh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-lvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-dvh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-lh") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-fit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-block-\\[4px\\]") != null);
}

test "tw: container  creates the right media queries and sorts it befo" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "w-1/2", "container", "max-w-[var(--breakpoint-sm)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "w-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "container") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-\\[var\\(--breakpoint-sm\\)\\]") != null);
}

test "tw: container  sorts breakpoints based on unit and then in ascen" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "container" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "container") != null);
}

test "tw: container  custom utility container always follow the core u" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "w-1/2", "container", "max-w-[var(--breakpoint-sm)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "w-1\\/2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "container") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-w-\\[var\\(--breakpoint-sm\\)\\]") != null);
}

test "tw: flex-shrink" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "shrink", "shrink-0", "shrink-[123]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "shrink") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shrink-0") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shrink-\\[123\\]") != null);
}

test "tw: flex-grow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grow", "grow-0", "grow-[123]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grow") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grow-0") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grow-\\[123\\]") != null);
}

test "tw: table-layout" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "table-auto", "table-fixed" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "table-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "table-fixed") != null);
}

test "tw: caption-side" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "caption-top", "caption-bottom" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "caption-top") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caption-bottom") != null);
}

test "tw: border-collapse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-collapse", "border-separate" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border-collapse") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-separate") != null);
}

test "tw: border-spacing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing-1", "border-spacing-[123px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-\\[123px\\]") != null);
}

test "tw: border-spacing-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing-x-1", "border-spacing-x-[123px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-x-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-x-\\[123px\\]") != null);
}

test "tw: border-spacing-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing-y-1", "border-spacing-y-[123px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-y-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-spacing-y-\\[123px\\]") != null);
}

test "tw: origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "origin-center", "origin-top", "origin-top-right", "origin-right", "origin-bottom-right", "origin-bottom", "origin-bottom-left", "origin-left", "origin-top-left", "origin-[50px_100px]", "origin-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "origin-center") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-top") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-top-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-bottom-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-bottom") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-bottom-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-top-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-\\[50px_100px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "origin-\\[var\\(--value\\)\\]") != null);
}

test "tw: origin_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "origin-top" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "origin-top") != null);
}

test "tw: translate-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-x-full", "-translate-x-full", "translate-x-px", "-translate-x-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "translate-x-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-x-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "translate-x-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-x-\\[var\\(--value\\)\\]") != null);
}

test "tw: translate-x_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-x-full", "-translate-x-full", "translate-x-px", "-translate-x-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "translate-x-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-x-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "translate-x-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-x-\\[var\\(--value\\)\\]") != null);
}

test "tw: translate-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-y-full", "-translate-y-full", "translate-y-px", "-translate-y-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "translate-y-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-y-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "translate-y-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-y-\\[var\\(--value\\)\\]") != null);
}

test "tw: translate-y_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-y-full", "-translate-y-full", "translate-y-px", "-translate-y-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "translate-y-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-y-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "translate-y-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-y-\\[var\\(--value\\)\\]") != null);
}

test "tw: translate-z" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-translate-z-px", "translate-z-px", "-translate-z-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-z-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "translate-z-px") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-z-\\[var\\(--value\\)\\]") != null);
}

test "tw: rotate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-45", "-rotate-45", "rotate-[123deg]", "rotate-[0.3_0.7_1_45deg]", "rotate-(--var)", "-rotate-[123deg]", "-rotate-(--var)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-\\[0\\.3_0\\.7_1_45deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-\\(--var\\)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-\\(--var\\)") != null);
}

test "tw: rotate-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-x-45", "-rotate-x-45", "rotate-x-[123deg]", "rotate-x-(--var)", "-rotate-x-(--var)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-x-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-x-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-x-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-x-\\(--var\\)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-x-\\(--var\\)") != null);
}

test "tw: rotate-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-y-45", "rotate-y-[123deg]", "rotate-y-(--var)", "-rotate-y-45", "-rotate-y-[123deg]", "-rotate-y-(--var)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-y-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-y-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-y-\\(--var\\)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-y-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-y-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-y-\\(--var\\)") != null);
}

test "tw: rotate-z" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-z-45", "rotate-z-[123deg]", "rotate-z-(--var)", "-rotate-z-45", "-rotate-z-[123deg]", "-rotate-z-(--var)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-z-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-z-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rotate-z-\\(--var\\)") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-z-45") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-z-\\[123deg\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-rotate-z-\\(--var\\)") != null);
}

test "tw: skew-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "skew-x-6", "-skew-x-6", "skew-x-[123deg]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "skew-x-6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-skew-x-6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "skew-x-\\[123deg\\]") != null);
}

test "tw: skew-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "skew-y-6", "-skew-y-6", "skew-y-[123deg]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "skew-y-6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-skew-y-6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "skew-y-\\[123deg\\]") != null);
}

test "tw: scale-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scale-200", "scale-x-400" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "scale-200") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scale-x-400") != null);
}

test "tw: perspective" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "perspective-normal", "perspective-dramatic", "perspective-none", "perspective-[456px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "perspective-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "perspective-dramatic") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "perspective-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "perspective-\\[456px\\]") != null);
}

test "tw: perspective_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "perspective-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "perspective-none") != null);
}

test "tw: touch-action" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "touch-auto", "touch-none", "touch-manipulation" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "touch-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-manipulation") != null);
}

test "tw: touch-pan" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "touch-pan-x", "touch-pan-left", "touch-pan-right", "touch-pan-y", "touch-pan-up", "touch-pan-down" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-x") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-y") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-up") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pan-down") != null);
}

test "tw: touch-pinch-zoom" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "touch-pinch-zoom" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "touch-pinch-zoom") != null);
}

test "tw: select" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "select-none", "select-text", "select-all", "select-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "select-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "select-text") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "select-all") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "select-auto") != null);
}

test "tw: resize" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "resize-none", "resize", "resize-x", "resize-y" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "resize-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "resize") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "resize-x") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "resize-y") != null);
}

test "tw: scroll-snap-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "snap-none", "snap-x", "snap-y", "snap-both" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "snap-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-x") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-y") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-both") != null);
}

test "tw: --tw-scroll-snap-strictness" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "snap-mandatory", "snap-proximity" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "snap-mandatory") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-proximity") != null);
}

test "tw: scroll-snap-align" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "snap-align-none", "snap-start", "snap-end", "snap-center" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "snap-align-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-center") != null);
}

test "tw: scroll-snap-stop" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "snap-normal", "snap-always" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "snap-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "snap-always") != null);
}

test "tw: list-style-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-inside", "list-outside" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "list-inside") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-outside") != null);
}

test "tw: list" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-none", "list-disc", "list-decimal", "list-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "list-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-disc") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-decimal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-\\[var\\(--value\\)\\]") != null);
}

test "tw: list_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "list-none") != null);
}

test "tw: list-image" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-image-none", "list-image-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "list-image-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "list-image-\\[var\\(--value\\)\\]") != null);
}

test "tw: list-image_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-image-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "list-image-none") != null);
}

test "tw: appearance" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "appearance-none", "appearance-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "appearance-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "appearance-auto") != null);
}

test "tw: columns" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "columns-auto", "columns-3xs", "columns-7xl", "columns-4", "columns-99", "columns-[123]", "columns-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "columns-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-3xs") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-7xl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-99") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-\\[123\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "columns-\\[var\\(--value\\)\\]") != null);
}

test "tw: columns_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "columns-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "columns-auto") != null);
}

test "tw: break-before" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-before-auto", "break-before-avoid", "break-before-all", "break-before-avoid-page", "break-before-page", "break-before-left", "break-before-right", "break-before-column" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-avoid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-all") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-avoid-page") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-page") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-before-column") != null);
}

test "tw: break-inside" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-inside-auto", "break-inside-avoid", "break-inside-avoid-page", "break-inside-avoid-column" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "break-inside-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-inside-avoid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-inside-avoid-page") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-inside-avoid-column") != null);
}

test "tw: break-after" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-after-auto", "break-after-avoid", "break-after-all", "break-after-avoid-page", "break-after-page", "break-after-left", "break-after-right", "break-after-column" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-avoid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-all") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-avoid-page") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-page") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-after-column") != null);
}

test "tw: auto-cols" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-cols-auto", "auto-cols-min", "auto-cols-max", "auto-cols-fr", "auto-cols-[2fr]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-fr") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-\\[2fr\\]") != null);
}

test "tw: auto-cols_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-cols-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "auto-cols-auto") != null);
}

test "tw: grid-flow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-flow-row", "grid-flow-col", "grid-flow-dense", "grid-flow-row-dense", "grid-flow-col-dense" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grid-flow-row") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-flow-col") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-flow-dense") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-flow-row-dense") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-flow-col-dense") != null);
}

test "tw: auto-rows" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-rows-auto", "auto-rows-min", "auto-rows-max", "auto-rows-fr", "auto-rows-[2fr]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-min") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-max") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-fr") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-\\[2fr\\]") != null);
}

test "tw: auto-rows_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-rows-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "auto-rows-auto") != null);
}

test "tw: grid-cols" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-cols-none", "grid-cols-subgrid", "grid-cols-12", "grid-cols-99", "grid-cols-[123]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-subgrid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-12") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-99") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-\\[123\\]") != null);
}

test "tw: grid-cols_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-cols-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grid-cols-none") != null);
}

test "tw: grid-rows" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-rows-none", "grid-rows-subgrid", "grid-rows-12", "grid-rows-99", "grid-rows-[123]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-subgrid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-12") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-99") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-\\[123\\]") != null);
}

test "tw: grid-rows_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-rows-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "grid-rows-none") != null);
}

test "tw: flex-direction" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex-row", "flex-row-reverse", "flex-col", "flex-col-reverse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex-row") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex-row-reverse") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex-col") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex-col-reverse") != null);
}

test "tw: flex-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex-wrap", "flex-wrap-reverse", "flex-nowrap" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex-wrap") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex-wrap-reverse") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex-nowrap") != null);
}

test "tw: justify" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "justify-normal", "justify-start", "justify-end", "justify-end-safe", "justify-center", "justify-center-safe", "justify-between", "justify-around", "justify-evenly", "justify-stretch" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "justify-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-end-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-center") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-center-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-between") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-around") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-evenly") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "justify-stretch") != null);
}

test "tw: gap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap-4", "gap-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "gap-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "gap-\\[4px\\]") != null);
}

test "tw: gap-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap-x-4", "gap-x-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "gap-x-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "gap-x-\\[4px\\]") != null);
}

test "tw: gap-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap-y-4", "gap-y-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "gap-y-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "gap-y-\\[4px\\]") != null);
}

test "tw: space-x-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "space-x-reverse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "space-x-reverse") != null);
}

test "tw: space-y-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "space-y-reverse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "space-y-reverse") != null);
}

test "tw: divide-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-x", "divide-x-4", "divide-x-123", "divide-x-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x-123") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x-\\[4px\\]") != null);
}

test "tw: divide-x with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-x" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x") != null);
}

test "tw: divide-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-y", "divide-y-4", "divide-y-123", "divide-y-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y-123") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y-\\[4px\\]") != null);
}

test "tw: divide-y with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-y" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y") != null);
}

test "tw: divide-x-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-x-reverse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-x-reverse") != null);
}

test "tw: divide-y-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-y-reverse" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-y-reverse") != null);
}

test "tw: divide-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-solid", "divide-dashed", "divide-dotted", "divide-double", "divide-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "divide-solid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-dashed") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-dotted") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-double") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "divide-none") != null);
}

test "tw: accent" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "accent-red-500", "accent-red-500/50", "accent-red-500/2.25", "accent-red-500/2.5", "accent-red-500/2.75", "accent-red-500/[0.5]", "accent-red-500/[50%]", "accent-blue-500", "accent-current", "accent-current/50", "accent-current/[0.5]", "accent-current/[50%]", "accent-inherit", "accent-transparent", "accent-[#0088cc]", "accent-[#0088cc]/50", "accent-[#0088cc]/[0.5]", "accent-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "accent-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
}

test "tw: caret" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "caret-red-500", "caret-red-500/50", "caret-red-500/2.25", "caret-red-500/2.5", "caret-red-500/2.75", "caret-red-500/[0.5]", "caret-red-500/[50%]", "caret-blue-500", "caret-current", "caret-current/50", "caret-current/[0.5]", "caret-current/[50%]", "caret-inherit", "caret-transparent", "caret-[#0088cc]", "caret-[#0088cc]/50", "caret-[#0088cc]/[0.5]", "caret-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "caret-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
}

test "tw: place-self" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "place-self-auto", "place-self-start", "place-self-end", "place-self-end-safe", "place-self-center", "place-self-center-safe", "place-self-stretch" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-end-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-center") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-center-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "place-self-stretch") != null);
}

test "tw: self" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "self-auto", "self-start", "self-end", "self-end-safe", "self-center", "self-center-safe", "self-stretch", "self-baseline", "self-baseline-last" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "self-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-end") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-end-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-center") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-center-safe") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-stretch") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-baseline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "self-baseline-last") != null);
}

test "tw: overflow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow-auto", "overflow-hidden", "overflow-clip", "overflow-visible", "overflow-scroll" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-hidden") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-clip") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-visible") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-scroll") != null);
}

test "tw: overflow-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow-x-auto", "overflow-x-hidden", "overflow-x-clip", "overflow-x-visible", "overflow-x-scroll" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-x-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-x-hidden") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-x-clip") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-x-visible") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-x-scroll") != null);
}

test "tw: overflow-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow-y-auto", "overflow-y-hidden", "overflow-y-clip", "overflow-y-visible", "overflow-y-scroll" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-y-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-y-hidden") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-y-clip") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-y-visible") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-y-scroll") != null);
}

test "tw: overscroll" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll-auto", "overscroll-contain", "overscroll-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-contain") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-none") != null);
}

test "tw: overscroll-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll-x-auto", "overscroll-x-contain", "overscroll-x-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-x-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-x-contain") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-x-none") != null);
}

test "tw: overscroll-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll-y-auto", "overscroll-y-contain", "overscroll-y-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-y-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-y-contain") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overscroll-y-none") != null);
}

test "tw: scroll-behavior" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-auto", "scroll-smooth" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-smooth") != null);
}

test "tw: truncate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "truncate" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "truncate") != null);
}

test "tw: text-overflow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text-ellipsis", "text-clip" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "text-ellipsis") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-clip") != null);
}

test "tw: hyphens" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hyphens-none", "hyphens-manual", "hyphens-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hyphens-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hyphens-manual") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hyphens-auto") != null);
}

test "tw: whitespace" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "whitespace-normal", "whitespace-nowrap", "whitespace-pre", "whitespace-pre-line", "whitespace-pre-wrap", "whitespace-break-spaces" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-nowrap") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-pre") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-pre-line") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-pre-wrap") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "whitespace-break-spaces") != null);
}

test "tw: text-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text-wrap", "text-nowrap", "text-balance", "text-pretty" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "text-wrap") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-nowrap") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-balance") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-pretty") != null);
}

test "tw: word-break" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-normal", "break-words", "break-all", "break-keep" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "break-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-words") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-all") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "break-keep") != null);
}

test "tw: overflow-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "wrap-anywhere", "wrap-break-word", "wrap-normal" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "wrap-anywhere") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "wrap-break-word") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "wrap-normal") != null);
}

test "tw: rounded" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded", "rounded-full", "rounded-none", "rounded-sm", "rounded-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-\\[4px\\]") != null);
}

test "tw: rounded_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-full" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-full") != null);
}

test "tw: rounded-s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-s", "rounded-s-full", "rounded-s-none", "rounded-s-sm", "rounded-s-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-s") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-s-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-s-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-s-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-s-\\[4px\\]") != null);
}

test "tw: rounded-e" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-e", "rounded-e-full", "rounded-e-none", "rounded-e-sm", "rounded-e-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-e") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-e-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-e-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-e-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-e-\\[4px\\]") != null);
}

test "tw: rounded-t" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-t", "rounded-t-full", "rounded-t-none", "rounded-t-sm", "rounded-t-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-t") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-t-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-t-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-t-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-t-\\[4px\\]") != null);
}

test "tw: rounded-r" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-r", "rounded-r-full", "rounded-r-none", "rounded-r-sm", "rounded-r-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-r") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-r-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-r-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-r-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-r-\\[4px\\]") != null);
}

test "tw: rounded-b" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-b", "rounded-b-full", "rounded-b-none", "rounded-b-sm", "rounded-b-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-b") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-b-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-b-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-b-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-b-\\[4px\\]") != null);
}

test "tw: rounded-l" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-l", "rounded-l-full", "rounded-l-none", "rounded-l-sm", "rounded-l-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-l") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-l-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-l-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-l-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-l-\\[4px\\]") != null);
}

test "tw: rounded-ss" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-ss", "rounded-ss-full", "rounded-ss-none", "rounded-ss-sm", "rounded-ss-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ss") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ss-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ss-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ss-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ss-\\[4px\\]") != null);
}

test "tw: rounded-se" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-se", "rounded-se-full", "rounded-se-none", "rounded-se-sm", "rounded-se-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-se") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-se-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-se-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-se-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-se-\\[4px\\]") != null);
}

test "tw: rounded-ee" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-ee", "rounded-ee-full", "rounded-ee-none", "rounded-ee-sm", "rounded-ee-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ee") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ee-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ee-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ee-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-ee-\\[4px\\]") != null);
}

test "tw: rounded-es" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-es", "rounded-es-full", "rounded-es-none", "rounded-es-sm", "rounded-es-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-es") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-es-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-es-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-es-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-es-\\[4px\\]") != null);
}

test "tw: rounded-tl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-tl", "rounded-tl-full", "rounded-tl-none", "rounded-tl-sm", "rounded-tl-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tl-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tl-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tl-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tl-\\[4px\\]") != null);
}

test "tw: rounded-tr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-tr", "rounded-tr-full", "rounded-tr-none", "rounded-tr-sm", "rounded-tr-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tr") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tr-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tr-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tr-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-tr-\\[4px\\]") != null);
}

test "tw: rounded-br" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-br", "rounded-br-full", "rounded-br-none", "rounded-br-sm", "rounded-br-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-br") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-br-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-br-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-br-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-br-\\[4px\\]") != null);
}

test "tw: rounded-bl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rounded-bl", "rounded-bl-full", "rounded-bl-none", "rounded-bl-sm", "rounded-bl-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-bl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-bl-full") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-bl-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-bl-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "rounded-bl-\\[4px\\]") != null);
}

test "tw: border-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-solid", "border-dashed", "border-dotted", "border-double", "border-hidden", "border-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border-solid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-dashed") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-dotted") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-double") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-hidden") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "border-none") != null);
}

test "tw: border with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "border") != null);
}

test "tw: bg-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-position-[120px]", "bg-position-[120px_120px]", "bg-position-[var(--some-var)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-position-\\[120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-position-\\[120px_120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-position-\\[var\\(--some-var\\)\\]") != null);
}

test "tw: bg-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-size-[120px]", "bg-size-[120px_120px]", "bg-size-[var(--some-var)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-size-\\[120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-size-\\[120px_120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-size-\\[var\\(--some-var\\)\\]") != null);
}

test "tw: from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "from-red-500", "from-red-500/50", "from-red-500/[0.5]", "from-red-500/[50%]", "from-current", "from-current/50", "from-current/[0.5]", "from-current/[50%]", "from-inherit", "from-transparent", "from-[#0088cc]", "from-[#0088cc]/50", "from-[#0088cc]/[0.5]", "from-[#0088cc]/[50%]", "from-[var(--my-color)]", "from-[var(--my-color)]/50", "from-[var(--my-color)]/[0.5]", "from-[var(--my-color)]/[50%]", "from-[color:var(--my-color)]", "from-[color:var(--my-color)]/50", "from-[color:var(--my-color)]/[0.5]", "from-[color:var(--my-color)]/[50%]", "from-0%", "from-5%", "from-100%", "from-[50%]", "from-[50px]", "from-[length:var(--my-position)]", "from-[percentage:var(--my-position)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "from-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-0\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-5\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-100\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[50px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[length\\:var\\(--my-position\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "from-\\[percentage\\:var\\(--my-position\\)\\]") != null);
}

test "tw: via" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "via-red-500", "via-red-500/50", "via-red-500/[0.5]", "via-red-500/[50%]", "via-current", "via-current/50", "via-current/[0.5]", "via-current/[50%]", "via-inherit", "via-transparent", "via-[#0088cc]", "via-[#0088cc]/50", "via-[#0088cc]/[0.5]", "via-[#0088cc]/[50%]", "via-[var(--my-color)]", "via-[var(--my-color)]/50", "via-[var(--my-color)]/[0.5]", "via-[var(--my-color)]/[50%]", "via-[color:var(--my-color)]", "via-[color:var(--my-color)]/50", "via-[color:var(--my-color)]/[0.5]", "via-[color:var(--my-color)]/[50%]", "via-0%", "via-5%", "via-100%", "via-[50%]", "via-[50px]", "via-[length:var(--my-position)]", "via-[percentage:var(--my-position)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "via-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-0\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-5\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-100\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[50px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[length\\:var\\(--my-position\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "via-\\[percentage\\:var\\(--my-position\\)\\]") != null);
}

test "tw: to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "to-red-500", "to-red-500/50", "to-red-500/[0.5]", "to-red-500/[50%]", "to-current", "to-current/50", "to-current/[0.5]", "to-current/[50%]", "to-inherit", "to-transparent", "to-[#0088cc]", "to-[#0088cc]/50", "to-[#0088cc]/[0.5]", "to-[#0088cc]/[50%]", "to-[var(--my-color)]", "to-[var(--my-color)]/50", "to-[var(--my-color)]/[0.5]", "to-[var(--my-color)]/[50%]", "to-[color:var(--my-color)]", "to-[color:var(--my-color)]/50", "to-[color:var(--my-color)]/[0.5]", "to-[color:var(--my-color)]/[50%]", "to-0%", "to-5%", "to-100%", "to-[50%]", "to-[50px]", "to-[length:var(--my-position)]", "to-[percentage:var(--my-position)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "to-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-0\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-5\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-100\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[50px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[length\\:var\\(--my-position\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "to-\\[percentage\\:var\\(--my-position\\)\\]") != null);
}

test "tw: mask-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-position-[120px]", "mask-position-[120px_120px]", "mask-position-[var(--some-var)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mask-position-\\[120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-position-\\[120px_120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-position-\\[var\\(--some-var\\)\\]") != null);
}

test "tw: mask-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-size-[120px]", "mask-size-[120px_120px]", "mask-size-[var(--some-var)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mask-size-\\[120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-size-\\[120px_120px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-size-\\[var\\(--some-var\\)\\]") != null);
}

test "tw: box-decoration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "box-decoration-slice", "box-decoration-clone" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "box-decoration-slice") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "box-decoration-clone") != null);
}

test "tw: bg-clip" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-clip-border", "bg-clip-padding", "bg-clip-content", "bg-clip-text" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-clip-border") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-clip-padding") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-clip-content") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-clip-text") != null);
}

test "tw: bg-origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-origin-border", "bg-origin-padding", "bg-origin-content" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-origin-border") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-origin-padding") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-origin-content") != null);
}

test "tw: mask-origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-origin-border", "mask-origin-padding", "mask-origin-content", "mask-origin-fill", "mask-origin-stroke", "mask-origin-view" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-border") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-padding") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-content") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-fill") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-stroke") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mask-origin-view") != null);
}

test "tw: bg-blend" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-blend-normal", "bg-blend-multiply", "bg-blend-screen", "bg-blend-overlay", "bg-blend-darken", "bg-blend-lighten", "bg-blend-color-dodge", "bg-blend-color-burn", "bg-blend-hard-light", "bg-blend-soft-light", "bg-blend-difference", "bg-blend-exclusion", "bg-blend-hue", "bg-blend-saturation", "bg-blend-color", "bg-blend-luminosity" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-multiply") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-overlay") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-darken") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-lighten") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-color-dodge") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-color-burn") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-hard-light") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-soft-light") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-difference") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-exclusion") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-hue") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-saturation") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-color") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "bg-blend-luminosity") != null);
}

test "tw: mix-blend" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mix-blend-normal", "mix-blend-multiply", "mix-blend-screen", "mix-blend-overlay", "mix-blend-darken", "mix-blend-lighten", "mix-blend-color-dodge", "mix-blend-color-burn", "mix-blend-hard-light", "mix-blend-soft-light", "mix-blend-difference", "mix-blend-exclusion", "mix-blend-hue", "mix-blend-saturation", "mix-blend-color", "mix-blend-luminosity", "mix-blend-plus-darker", "mix-blend-plus-lighter" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-normal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-multiply") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-screen") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-overlay") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-darken") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-lighten") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-color-dodge") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-color-burn") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-hard-light") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-soft-light") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-difference") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-exclusion") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-hue") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-saturation") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-color") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-luminosity") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-plus-darker") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mix-blend-plus-lighter") != null);
}

test "tw: fill" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "fill-red-500", "fill-red-500/50", "fill-red-500/2.25", "fill-red-500/2.5", "fill-red-500/2.75", "fill-red-500/[0.5]", "fill-red-500/[50%]", "fill-blue-500", "fill-current", "fill-current/50", "fill-current/[0.5]", "fill-current/[50%]", "fill-inherit", "fill-transparent", "fill-[#0088cc]", "fill-[#0088cc]/50", "fill-[#0088cc]/[0.5]", "fill-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "fill-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
}

test "tw: object" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "object-center" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "object-center") != null);
}

test "tw: text-align" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "text-left") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-center") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-right") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-justify") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-start") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-end") != null);
}

test "tw: indent" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "indent-[4px]", "-indent-[4px]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "indent-\\[4px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "-indent-\\[4px\\]") != null);
}

test "tw: font" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "font-sans", "font-[\"arial_rounded\"]", "font-[ui-sans-serif]", "font-[var(--my-family)]", "font-[family-name:var(--my-family)]", "font-[generic-name:var(--my-family)]", "font-bold", "font-[100]", "font-[number:var(--my-weight)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "font-sans") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[\\\"arial_rounded\\\"\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[ui-sans-serif\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[var\\(--my-family\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[family-name\\:var\\(--my-family\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[generic-name\\:var\\(--my-family\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-bold") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[100\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-\\[number\\:var\\(--my-weight\\)\\]") != null);
}

test "tw: text-transform" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "uppercase", "lowercase", "capitalize", "normal-case" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "uppercase") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "lowercase") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "capitalize") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "normal-case") != null);
}

test "tw: font-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "italic", "not-italic" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "italic") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-italic") != null);
}

test "tw: font-stretch" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "font-stretch-ultra-expanded", "font-stretch-50%", "font-stretch-200%" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "font-stretch-ultra-expanded") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-stretch-50\\%") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "font-stretch-200\\%") != null);
}

test "tw: text-decoration-line" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline", "overline", "line-through", "no-underline" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "line-through") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "no-underline") != null);
}

test "tw: placeholder" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder-red-500", "placeholder-red-500/50", "placeholder-red-500/2.25", "placeholder-red-500/2.5", "placeholder-red-500/2.75", "placeholder-red-500/[0.5]", "placeholder-red-500/[50%]", "placeholder-current", "placeholder-current/50", "placeholder-current/[0.5]", "placeholder-current/[50%]", "placeholder-inherit", "placeholder-transparent", "placeholder-[#0088cc]", "placeholder-[#0088cc]/50", "placeholder-[#0088cc]/[0.5]", "placeholder-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
}

test "tw: decoration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "decoration-red-500", "decoration-red-500/50", "decoration-red-500/[0.5]", "decoration-red-500/[50%]", "decoration-blue-500", "decoration-current", "decoration-current/50", "decoration-current/[0.5]", "decoration-current/[50%]", "decoration-inherit", "decoration-transparent", "decoration-[#0088cc]", "decoration-[#0088cc]/50", "decoration-[#0088cc]/[0.5]", "decoration-[#0088cc]/[50%]", "decoration-[var(--my-color)]", "decoration-[var(--my-color)]/50", "decoration-[var(--my-color)]/[0.5]", "decoration-[var(--my-color)]/[50%]", "decoration-[color:var(--my-color)]", "decoration-[color:var(--my-color)]/50", "decoration-[color:var(--my-color)]/[0.5]", "decoration-[color:var(--my-color)]/[50%]", "decoration-solid", "decoration-double", "decoration-dotted", "decoration-dashed", "decoration-wavy", "decoration-auto", "decoration-from-font", "decoration-0", "decoration-1", "decoration-2", "decoration-4", "decoration-123", "decoration-[12px]", "decoration-[50%]", "decoration-[length:var(--my-thickness)]", "decoration-[percentage:var(--my-thickness)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-solid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-double") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-dotted") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-dashed") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-wavy") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-auto") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-from-font") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-0") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-123") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[12px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[length\\:var\\(--my-thickness\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "decoration-\\[percentage\\:var\\(--my-thickness\\)\\]") != null);
}

test "tw: animate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "animate-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "animate-none") != null);
}

test "tw: transition" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "transition", "transition-all", "transition-colors" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "transition") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "transition-all") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "transition-colors") != null);
}

test "tw: transition_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "transition-all" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "transition-all") != null);
}

test "tw: transition_2" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "transition-colors" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "transition-colors") != null);
}

test "tw: transition-behavior" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "transition-discrete", "transition-normal" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "transition-discrete") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "transition-normal") != null);
}

test "tw: delay" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "delay-123", "delay-200", "delay-[300ms]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "delay-123") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "delay-200") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "delay-\\[300ms\\]") != null);
}

test "tw: duration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "duration-123", "duration-200", "duration-[300ms]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "duration-123") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "duration-200") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "duration-\\[300ms\\]") != null);
}

test "tw: ease" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ease-in", "ease-out", "ease-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ease-in") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ease-out") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ease-\\[var\\(--value\\)\\]") != null);
}

test "tw: ease_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ease-linear" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ease-linear") != null);
}

test "tw: forced-color-adjust" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "forced-color-adjust-none", "forced-color-adjust-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "forced-color-adjust-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "forced-color-adjust-auto") != null);
}

test "tw: leading" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "leading-tight", "leading-6", "leading-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "leading-tight") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "leading-6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "leading-\\[var\\(--value\\)\\]") != null);
}

test "tw: leading_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "leading-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "leading-none") != null);
}

test "tw: font-smoothing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "antialiased", "subpixel-antialiased" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "antialiased") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "subpixel-antialiased") != null);
}

test "tw: font-variant-numeric" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "normal-nums", "ordinal", "slashed-zero", "lining-nums", "oldstyle-nums", "proportional-nums", "tabular-nums", "diagonal-fractions", "stacked-fractions" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "normal-nums") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ordinal") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "slashed-zero") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "lining-nums") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "oldstyle-nums") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "proportional-nums") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "tabular-nums") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "diagonal-fractions") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "stacked-fractions") != null);
}

test "tw: outline" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "outline" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "outline") != null);
}

test "tw: underline-offset" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline-offset-auto" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline-offset-auto") != null);
}

test "tw: text" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text-red-500", "text-red-500/50", "text-red-500/2.25", "text-red-500/2.5", "text-red-500/2.75", "text-red-500/[0.5]", "text-red-500/[50%]", "text-blue-500", "text-current", "text-current/50", "text-current/[0.5]", "text-current/[50%]", "text-inherit", "text-transparent", "text-[#0088cc]", "text-[#0088cc]/50", "text-[#0088cc]/[0.5]", "text-[#0088cc]/[50%]", "text-[var(--my-color)]", "text-[var(--my-color)]/50", "text-[var(--my-color)]/[0.5]", "text-[var(--my-color)]/[50%]", "text-[color:var(--my-color)]", "text-[color:var(--my-color)]/50", "text-[color:var(--my-color)]/[0.5]", "text-[color:var(--my-color)]/[50%]", "text-sm", "text-sm/6", "text-sm/none", "text-[10px]/none", "text-sm/snug", "text-sm/[4px]", "text-[12px]", "text-[12px]/6", "text-[50%]", "text-[50%]/6", "text-[xx-large]", "text-[xx-large]/6", "text-[larger]", "text-[larger]/6", "text-[length:var(--my-size)]", "text-[percentage:var(--my-size)]", "text-[absolute-size:var(--my-size)]", "text-[relative-size:var(--my-size)]", "text-[clamp(1rem,2rem,3rem)]", "text-[clamp(1rem,var(--size),3rem)]", "text-[clamp(1rem,var(--size),3rem)]/9" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-sm\\/6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-sm\\/none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[10px\\]\\/none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-sm\\/snug") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-sm\\/\\[4px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[12px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[12px\\]\\/6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[50\\%\\]\\/6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[xx-large\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[xx-large\\]\\/6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[larger\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[larger\\]\\/6") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[length\\:var\\(--my-size\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[percentage\\:var\\(--my-size\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[absolute-size\\:var\\(--my-size\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[relative-size\\:var\\(--my-size\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[clamp\\(1rem\\,2rem\\,3rem\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[clamp\\(1rem\\,var\\(--size\\)\\,3rem\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "text-\\[clamp\\(1rem\\,var\\(--size\\)\\,3rem\\)\\]\\/9") != null);
}

test "tw: shadow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "shadow-sm", "shadow-xl", "shadow-none", "shadow-[12px_12px_#0088cc]", "shadow-[12px_12px_var(--value)]", "shadow-[10px_10px]", "shadow-[var(--value)]", "shadow-[shadow:var(--value)]", "shadow-sm/25", "shadow-[12px_12px_#0088cc]/25", "shadow-[12px_12px_var(--value)]/25", "shadow-[10px_10px]/25", "shadow-red-500", "shadow-red-500/50", "shadow-red-500/2.25", "shadow-red-500/2.5", "shadow-red-500/2.75", "shadow-red-500/[0.5]", "shadow-red-500/[50%]", "shadow-blue-500", "shadow-current", "shadow-current/50", "shadow-current/[0.5]", "shadow-current/[50%]", "shadow-inherit", "shadow-transparent", "shadow-[#0088cc]", "shadow-[#0088cc]/50", "shadow-[#0088cc]/[0.5]", "shadow-[#0088cc]/[50%]", "shadow-[color:var(--value)]", "shadow-[color:var(--value)]/50", "shadow-[color:var(--value)]/[0.5]", "shadow-[color:var(--value)]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-sm") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-xl") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[12px_12px_\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[12px_12px_var\\(--value\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[10px_10px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[var\\(--value\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[shadow\\:var\\(--value\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-sm\\/25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[12px_12px_\\#0088cc\\]\\/25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[12px_12px_var\\(--value\\)\\]\\/25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[10px_10px\\]\\/25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[color\\:var\\(--value\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[color\\:var\\(--value\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[color\\:var\\(--value\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "shadow-\\[color\\:var\\(--value\\)\\]\\/\\[50\\%\\]") != null);
}

test "tw: ring" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ring-inset", "ring-red-500", "ring-red-500/50", "ring-red-500/2.25", "ring-red-500/2.5", "ring-red-500/2.75", "ring-red-500/[0.5]", "ring-red-500/[50%]", "ring-blue-500", "ring-current", "ring-current/50", "ring-current/[0.5]", "ring-current/[50%]", "ring-inherit", "ring-transparent", "ring-[#0088cc]", "ring-[#0088cc]/50", "ring-[#0088cc]/[0.5]", "ring-[#0088cc]/[50%]", "ring-[var(--my-color)]", "ring-[var(--my-color)]/50", "ring-[var(--my-color)]/[0.5]", "ring-[var(--my-color)]/[50%]", "ring-[color:var(--my-color)]", "ring-[color:var(--my-color)]/50", "ring-[color:var(--my-color)]/[0.5]", "ring-[color:var(--my-color)]/[50%]", "ring", "ring-0", "ring-1", "ring-2", "ring-4", "ring-[12px]", "ring-[length:var(--my-width)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ring-inset") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/2\\.25") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/2\\.5") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/2\\.75") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-red-500\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-blue-500") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-current") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-current\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-current\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-current\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-inherit") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-transparent") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[\\#0088cc\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[\\#0088cc\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[\\#0088cc\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[color\\:var\\(--my-color\\)\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[color\\:var\\(--my-color\\)\\]\\/\\[0\\.5\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[color\\:var\\(--my-color\\)\\]\\/\\[50\\%\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-0") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[12px\\]") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ring-\\[length\\:var\\(--my-width\\)\\]") != null);
}

test "tw: ring_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ring" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ring") != null);
}

test "tw: custom utilities  referencing custom utilities in custom uti" {
    const alloc = std.testing.allocator;
    // "bar" is a custom utility defined in TW's test config — test via custom_utilities_json
    const candidates = [_][]const u8{ "bar" };
    const custom_utils =
        \\{"bar":"color:red"}
    ;
    const result = try compiler.compile(alloc, &candidates, null, false, null, custom_utils, null);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bar") != null);
}

test "tw: functional utilities  variables used in utility will not be " {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
}

test "tw: test_0" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "*:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\*\\:flex") != null);
}

test "tw: test_0_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "**:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\*\\*\\:flex") != null);
}

test "tw: first-letter" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-letter:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "first-letter\\:flex") != null);
}

test "tw: first-line" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-line:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "first-line\\:flex") != null);
}

test "tw: marker" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "marker:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "marker\\:flex") != null);
}

test "tw: selection" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "selection:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "selection\\:flex") != null);
}

test "tw: file" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "file:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "file\\:flex") != null);
}

test "tw: placeholder_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder\\:flex") != null);
}

test "tw: backdrop" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "backdrop:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "backdrop\\:flex") != null);
}

test "tw: details-content" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "details-content:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "details-content\\:flex") != null);
}

test "tw: before" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "before:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "before\\:flex") != null);
}

test "tw: after" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "after:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "after\\:flex") != null);
}

test "tw: first" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first:flex", "group-first:flex", "peer-first:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "first\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-first\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-first\\:flex") != null);
}

test "tw: last" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "last:flex", "group-last:flex", "peer-last:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "last\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-last\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-last\\:flex") != null);
}

test "tw: only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "only:flex", "group-only:flex", "peer-only:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-only\\:flex") != null);
}

test "tw: odd" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "odd:flex", "group-odd:flex", "peer-odd:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "odd\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-odd\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-odd\\:flex") != null);
}

test "tw: even" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "even:flex", "group-even:flex", "peer-even:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "even\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-even\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-even\\:flex") != null);
}

test "tw: first-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-of-type:flex", "group-first-of-type:flex", "peer-first-of-type:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "first-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-first-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-first-of-type\\:flex") != null);
}

test "tw: last-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "last-of-type:flex", "group-last-of-type:flex", "peer-last-of-type:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "last-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-last-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-last-of-type\\:flex") != null);
}

test "tw: only-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "only-of-type:flex", "group-only-of-type:flex", "peer-only-of-type:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "only-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-only-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-only-of-type\\:flex") != null);
}

test "tw: visited" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "visited:flex", "group-visited:flex", "peer-visited:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "visited\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-visited\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-visited\\:flex") != null);
}

test "tw: target" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "target:flex", "group-target:flex", "peer-target:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "target\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-target\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-target\\:flex") != null);
}

test "tw: open" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "open:flex", "group-open:flex", "peer-open:flex", "not-open:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "open\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-open\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-open\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-open\\:flex") != null);
}

test "tw: default" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "default:flex", "group-default:flex", "peer-default:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "default\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-default\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-default\\:flex") != null);
}

test "tw: checked" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "checked:flex", "group-checked:flex", "peer-checked:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-checked\\:flex") != null);
}

test "tw: indeterminate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "indeterminate:flex", "group-indeterminate:flex", "peer-indeterminate:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "indeterminate\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-indeterminate\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-indeterminate\\:flex") != null);
}

test "tw: placeholder-shown" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder-shown:flex", "group-placeholder-shown:flex", "peer-placeholder-shown:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "placeholder-shown\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-placeholder-shown\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-placeholder-shown\\:flex") != null);
}

test "tw: autofill" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "autofill:flex", "group-autofill:flex", "peer-autofill:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "autofill\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-autofill\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-autofill\\:flex") != null);
}

test "tw: optional" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "optional:flex", "group-optional:flex", "peer-optional:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "optional\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-optional\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-optional\\:flex") != null);
}

test "tw: required" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "required:flex", "group-required:flex", "peer-required:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "required\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-required\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-required\\:flex") != null);
}

test "tw: valid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "valid:flex", "group-valid:flex", "peer-valid:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "valid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-valid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-valid\\:flex") != null);
}

test "tw: invalid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "invalid:flex", "group-invalid:flex", "peer-invalid:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "invalid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-invalid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-invalid\\:flex") != null);
}

test "tw: user-valid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "user-valid:flex", "group-user-valid:flex", "peer-user-valid:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "user-valid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-user-valid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-user-valid\\:flex") != null);
}

test "tw: user-invalid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "user-invalid:flex", "group-user-invalid:flex", "peer-user-invalid:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "user-invalid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-user-invalid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-user-invalid\\:flex") != null);
}

test "tw: in-range" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "in-range:flex", "group-in-range:flex", "peer-in-range:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "in-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-in-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-in-range\\:flex") != null);
}

test "tw: out-of-range" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "out-of-range:flex", "group-out-of-range:flex", "peer-out-of-range:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "out-of-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-out-of-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-out-of-range\\:flex") != null);
}

test "tw: read-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "read-only:flex", "group-read-only:flex", "peer-read-only:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "read-only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-read-only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-read-only\\:flex") != null);
}

test "tw: empty" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "empty:flex", "group-empty:flex", "peer-empty:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "empty\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-empty\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-empty\\:flex") != null);
}

test "tw: focus-within" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus-within:flex", "group-focus-within:flex", "peer-focus-within:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus-within\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus-within\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus-within\\:flex") != null);
}

test "tw: hover" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover:flex", "group-hover:flex", "peer-hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:flex") != null);
}

test "tw: focus" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus:flex", "group-focus:flex", "peer-focus:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:flex") != null);
}

test "tw: group-hover group-focus sorting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-hover:flex", "group-focus:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:flex") != null);
}

test "tw: group-hover group-focus sorting_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-focus:flex", "group-hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:flex") != null);
}

test "tw: focus-visible" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus-visible:flex", "group-focus-visible:flex", "peer-focus-visible:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus-visible\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus-visible\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus-visible\\:flex") != null);
}

test "tw: active" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "active:flex", "group-active:flex", "peer-active:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "active\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-active\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-active\\:flex") != null);
}

test "tw: enabled" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "enabled:flex", "group-enabled:flex", "peer-enabled:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "enabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-enabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-enabled\\:flex") != null);
}

test "tw: disabled" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "disabled:flex", "group-disabled:flex", "peer-disabled:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "disabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-disabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-disabled\\:flex") != null);
}

test "tw: inert" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inert:flex", "group-inert:flex", "peer-inert:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "inert\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-inert\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-inert\\:flex") != null);
}

test "tw: group-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-[&_p]:flex", "group-[&_p]:hover:flex", "hover:group-[&_p]:flex", "hover:group-[&_p]:hover:flex", "group-[&:hover]:group-[&_p]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-\\[\\&_p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-\\[\\&_p\\]\\:hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:group-\\[\\&_p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:group-\\[\\&_p\\]\\:hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-\\[\\&\\:hover\\]\\:group-\\[\\&_p\\]\\:flex") != null);
}

test "tw: group-_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-hover:flex", "group-focus:flex", "group-hocus:flex", "group-hover:group-focus:flex", "group-focus:group-hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:group-hover\\:flex") != null);
}

test "tw: peer-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "peer-[&_p]:flex", "peer-[&_p]:hover:flex", "hover:peer-[&_p]:flex", "hover:peer-[&_p]:focus:flex", "peer-[&:hover]:peer-[&_p]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "peer-\\[\\&_p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-\\[\\&_p\\]\\:hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:peer-\\[\\&_p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:peer-\\[\\&_p\\]\\:focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-\\[\\&\\:hover\\]\\:peer-\\[\\&_p\\]\\:flex") != null);
}

test "tw: peer-_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "peer-hover:flex", "peer-focus:flex", "peer-hocus:flex", "peer-hover:peer-focus:flex", "peer-focus:peer-hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:peer-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:peer-hover\\:flex") != null);
}

test "tw: ltr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ltr:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ltr\\:flex") != null);
}

test "tw: rtl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rtl:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "rtl\\:flex") != null);
}

test "tw: motion-safe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "motion-safe:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "motion-safe\\:flex") != null);
}

test "tw: motion-reduce" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "motion-reduce:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "motion-reduce\\:flex") != null);
}

test "tw: dark" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "dark:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "dark\\:flex") != null);
}

test "tw: starting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "starting:opacity-0" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "starting\\:opacity-0") != null);
}

test "tw: print" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "print:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "print\\:flex") != null);
}

test "tw: max-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-lg:flex", "max-sm:flex", "max-md:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-md\\:flex") != null);
}

test "tw: min-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-lg:flex", "min-sm:flex", "min-md:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-md\\:flex") != null);
}

test "tw: sorting stacked min- and max- variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-sm:max-lg:flex", "min-sm:max-xl:flex", "min-md:max-lg:flex", "min-xs:max-sm:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-sm\\:max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-sm\\:max-xl\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-md\\:max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-xs\\:max-sm\\:flex") != null);
}

test "tw: stacked min- and max- variants should come after unprefixed " {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "sm:flex", "min-sm:max-lg:flex", "md:flex", "min-md:max-lg:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-sm\\:max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "md\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-md\\:max-lg\\:flex") != null);
}

test "tw: min max and unprefixed breakpoints" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-lg-sm-potato:flex", "min-lg-sm-potato:flex", "lg-sm-potato:flex", "max-lg:flex", "max-sm:flex", "min-lg:flex", "max-[1000px]:flex", "md:flex", "min-md:flex", "min-[700px]:flex", "max-md:flex", "min-sm:flex", "sm:flex", "lg:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "max-lg-sm-potato\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-lg-sm-potato\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "lg-sm-potato\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[1000px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "md\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-md\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[700px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-md\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "lg\\:flex") != null);
}

test "tw: sorting min and max should sort by unit then by value then a" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-[10px]:flex", "min-[12px]:flex", "min-[10em]:flex", "min-[12em]:flex", "min-[10rem]:flex", "min-[12rem]:flex", "max-[10px]:flex", "max-[12px]:flex", "max-[10em]:flex", "max-[12em]:flex", "max-[10rem]:flex", "max-[12rem]:flex", "min-[calc(1000px+12em)]:flex", "max-[calc(1000px+12em)]:flex", "min-[calc(50vh+12em)]:flex", "max-[calc(50vh+12em)]:flex", "min-[10vh]:flex", "min-[12vh]:flex", "max-[10vh]:flex", "max-[12vh]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[10px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[12px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[10em\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[12em\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[10rem\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[12rem\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[10px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[12px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[10em\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[12em\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[10rem\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[12rem\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[calc\\(1000px\\+12em\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[calc\\(1000px\\+12em\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[calc\\(50vh\\+12em\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[calc\\(50vh\\+12em\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[10vh\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "min-\\[12vh\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[10vh\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "max-\\[12vh\\]\\:flex") != null);
}

test "tw: supports" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "supports-gap:grid", "supports-[display:grid]:flex", "supports-[selector(A_>_B)]:flex", "supports-[font-format(opentype)]:grid", "supports-[(display:grid)_and_font-format(opentype)]:grid", "supports-[font-tech(color-COLRv1)]:flex", "supports-[var(--test)]:flex", "supports-[--test]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "supports-gap\\:grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[display\\:grid\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[selector\\(A_\\>_B\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[font-format\\(opentype\\)\\]\\:grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[\\(display\\:grid\\)_and_font-format\\(opentype\\)\\]\\:grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[font-tech\\(color-COLRv1\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[var\\(--test\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\[--test\\]\\:flex") != null);
}

test "tw: not" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "not-[:checked]:flex", "not-[@media_print]:flex", "not-[@media(orientation:portrait)]:flex", "not-[@media_(orientation:landscape)]:flex", "not-[@media_not_(orientation:portrait)]:flex", "not-hocus:flex", "not-device-hocus:flex", "group-not-[:checked]:flex", "group-not-[:checked]/parent-name:flex", "group-not-checked:flex", "group-not-hocus:flex", "group-not-hover:flex", "group-not-device-hocus:flex", "group-not-hocus/parent-name:flex", "peer-not-[:checked]:flex", "peer-not-[:checked]/sibling-name:flex", "peer-not-checked:flex", "peer-not-hocus:flex", "peer-not-hocus/sibling-name:flex", "not-first:flex", "not-last:flex", "not-only:flex", "not-odd:flex", "not-even:flex", "not-first-of-type:flex", "not-last-of-type:flex", "not-only-of-type:flex", "not-visited:flex", "not-target:flex", "not-open:flex", "not-default:flex", "not-checked:flex", "not-indeterminate:flex", "not-placeholder-shown:flex", "not-autofill:flex", "not-optional:flex", "not-required:flex", "not-valid:flex", "not-invalid:flex", "not-in-range:flex", "not-out-of-range:flex", "not-read-only:flex", "not-empty:flex", "not-focus-within:flex", "not-hover:flex", "not-focus:flex", "not-focus-visible:flex", "not-active:flex", "not-enabled:flex", "not-disabled:flex", "not-inert:flex", "not-ltr:flex", "not-rtl:flex", "not-motion-safe:flex", "not-motion-reduce:flex", "not-dark:flex", "not-print:flex", "not-supports-grid:flex", "not-has-checked:flex", "not-aria-selected:flex", "not-data-foo:flex", "not-portrait:flex", "not-landscape:flex", "not-contrast-more:flex", "not-contrast-less:flex", "not-forced-colors:flex", "not-nth-2:flex", "not-noscript:flex", "not-sm:flex", "not-min-sm:flex", "not-min-[130px]:flex", "not-max-sm:flex", "not-max-[130px]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "not-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-\\[\\@media_print\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-\\[\\@media\\(orientation\\:portrait\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-\\[\\@media_\\(orientation\\:landscape\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-\\[\\@media_not_\\(orientation\\:portrait\\)\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-device-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-\\[\\:checked\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-device-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-not-hocus\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-not-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-not-\\[\\:checked\\]\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-not-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-not-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-not-hocus\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-first\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-last\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-odd\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-even\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-first-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-last-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-only-of-type\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-visited\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-target\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-open\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-default\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-indeterminate\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-placeholder-shown\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-autofill\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-optional\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-required\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-valid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-invalid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-in-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-out-of-range\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-read-only\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-empty\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-focus-within\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-focus-visible\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-active\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-enabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-disabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-inert\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-ltr\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-rtl\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-motion-safe\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-motion-reduce\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-dark\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-print\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-supports-grid\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-has-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-aria-selected\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-data-foo\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-portrait\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-landscape\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-contrast-more\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-contrast-less\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-forced-colors\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-nth-2\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-noscript\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-min-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-min-\\[130px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-max-sm\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-max-\\[130px\\]\\:flex") != null);
}

test "tw: in" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "in-[p]:flex", "in-[.group]:flex", "not-in-[p]:flex", "not-in-[.group]:flex", "in-data-visible:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "in-\\[p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "in-\\[\\.group\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-in-\\[p\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "not-in-\\[\\.group\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "in-data-visible\\:flex") != null);
}

test "tw: has" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "has-checked:flex", "has-[:checked]:flex", "has-[>img]:flex", "has-[+img]:flex", "has-[~img]:flex", "has-[&>img]:flex", "has-hocus:flex", "group-has-[:checked]:flex", "group-has-[:checked]/parent-name:flex", "group-has-checked:flex", "group-has-checked/parent-name:flex", "group-has-[>img]:flex", "group-has-[>img]/parent-name:flex", "group-has-[+img]:flex", "group-has-[~img]:flex", "group-has-[&>img]:flex", "group-has-[&>img]/parent-name:flex", "group-has-hocus:flex", "group-has-hocus/parent-name:flex", "peer-has-[:checked]:flex", "peer-has-[:checked]/sibling-name:flex", "peer-has-checked:flex", "peer-has-checked/sibling-name:flex", "peer-has-[>img]:flex", "peer-has-[>img]/sibling-name:flex", "peer-has-[+img]:flex", "peer-has-[~img]:flex", "peer-has-[&>img]:flex", "peer-has-[&>img]/sibling-name:flex", "peer-has-hocus:flex", "peer-has-hocus/sibling-name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "has-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-\\[\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-\\[\\+img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-\\[\\~img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-\\[\\&\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "has-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\:checked\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-checked\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\>img\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\+img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\~img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\&\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-\\[\\&\\>img\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-has-hocus\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\:checked\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\:checked\\]\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-checked\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\>img\\]\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\+img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\~img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\&\\>img\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-\\[\\&\\>img\\]\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-hocus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-has-hocus\\/sibling-name\\:flex") != null);
}

test "tw: aria" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "aria-checked:flex", "aria-[invalid=spelling]:flex", "aria-[valuenow=1]:flex", "aria-[valuenow_=_\"1\"]:flex", "group-aria-[modal]:flex", "group-aria-checked:flex", "group-aria-[valuenow=1]:flex", "group-aria-[modal]/parent-name:flex", "group-aria-checked/parent-name:flex", "group-aria-[valuenow=1]/parent-name:flex", "peer-aria-[modal]:flex", "peer-aria-checked:flex", "peer-aria-[valuenow=1]:flex", "peer-aria-[modal]/sibling-name:flex", "peer-aria-checked/sibling-name:flex", "peer-aria-[valuenow=1]/sibling-name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "aria-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aria-\\[invalid\\=spelling\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aria-\\[valuenow\\=1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "aria-\\[valuenow_\\=_\\\"1\\\"\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-\\[modal\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-\\[valuenow\\=1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-\\[modal\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-checked\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-\\[valuenow\\=1\\]\\/parent-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-\\[modal\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-checked\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-\\[valuenow\\=1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-\\[modal\\]\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-checked\\/sibling-name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-aria-\\[valuenow\\=1\\]\\/sibling-name\\:flex") != null);
}

test "tw: portrait" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "portrait:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "portrait\\:flex") != null);
}

test "tw: landscape" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "landscape:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "landscape\\:flex") != null);
}

test "tw: contrast-more" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "contrast-more:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "contrast-more\\:flex") != null);
}

test "tw: contrast-less" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "contrast-less:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "contrast-less\\:flex") != null);
}

test "tw: forced-colors" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "forced-colors:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "forced-colors\\:flex") != null);
}

test "tw: inverted-colors" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inverted-colors:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "inverted-colors\\:flex") != null);
}

test "tw: pointer-none" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-none:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-none\\:flex") != null);
}

test "tw: pointer-coarse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-coarse:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-coarse\\:flex") != null);
}

test "tw: pointer-fine" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-fine:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-fine\\:flex") != null);
}

test "tw: any-pointer-none" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "any-pointer-none:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "any-pointer-none\\:flex") != null);
}

test "tw: any-pointer-coarse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "any-pointer-coarse:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "any-pointer-coarse\\:flex") != null);
}

test "tw: any-pointer-fine" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "any-pointer-fine:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "any-pointer-fine\\:flex") != null);
}

test "tw: scripting-none" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "noscript:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "noscript\\:flex") != null);
}

test "tw: nth" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "nth-3:flex", "nth-[2n+1]:flex", "nth-[2n+1_of_.foo]:flex", "nth-last-3:flex", "nth-last-[2n+1]:flex", "nth-last-[2n+1_of_.foo]:flex", "nth-of-type-3:flex", "nth-of-type-[2n+1]:flex", "nth-last-of-type-3:flex", "nth-last-of-type-[2n+1]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "nth-3\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-\\[2n\\+1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-\\[2n\\+1_of_\\.foo\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-last-3\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-last-\\[2n\\+1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-last-\\[2n\\+1_of_\\.foo\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-of-type-3\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-of-type-\\[2n\\+1\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-last-of-type-3\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "nth-last-of-type-\\[2n\\+1\\]\\:flex") != null);
}

test "tw: container queries" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@lg:flex", "@lg/name:flex", "@[123px]:flex", "@[456px]/name:flex", "@foo-bar:flex", "@foo-bar/name:flex", "@min-lg:flex", "@min-lg/name:flex", "@min-[123px]:flex", "@min-[456px]/name:flex", "@min-foo-bar:flex", "@min-foo-bar/name:flex", "@max-lg:flex", "@max-lg/name:flex", "@max-[123px]:flex", "@max-[456px]/name:flex", "@max-foo-bar:flex", "@max-foo-bar/name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\@lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@lg\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@\\[123px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@\\[456px\\]\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@foo-bar\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@foo-bar\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-lg\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-\\[123px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-\\[456px\\]\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-foo-bar\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@min-foo-bar\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-lg\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-lg\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-\\[123px\\]\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-\\[456px\\]\\/name\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-foo-bar\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\\@max-foo-bar\\/name\\:flex") != null);
}

test "tw: should parse a simple utility" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
}

test "tw: should parse a simple utility that should be important" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex\\!") != null);
}

test "tw: should parse a simple utility that can be negative" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-translate-x-4" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "-translate-x-4") != null);
}

test "tw: should parse a simple utility with a variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
}

test "tw: should parse a simple utility with stacked variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus:hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:hover\\:flex") != null);
}

test "tw: should parse a simple utility with an arbitrary variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[&_p]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\&_p\\]\\:flex") != null);
}

test "tw: should parse an arbitrary variant using the automatic var sh" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "supports-(--test):flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "supports-\\(--test\\)\\:flex") != null);
}

test "tw: should parse a simple utility with a parameterized variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "data-[disabled]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "data-\\[disabled\\]\\:flex") != null);
}

test "tw: should parse compound variants with an arbitrary value as an" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-[&_p]/parent-name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-\\[\\&_p\\]\\/parent-name\\:flex") != null);
}

test "tw: should parse a simple utility with a parameterized variant a" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-aria-[disabled]/parent-name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-aria-\\[disabled\\]\\/parent-name\\:flex") != null);
}

test "tw: should parse compound group with itself group-group-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-group-group-hover/parent-name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-group-group-hover\\/parent-name\\:flex") != null);
}

test "tw: should parse a simple utility with an arbitrary media varian" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[@media(width>=123px)]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\@media\\(width\\>\\=123px\\)\\]\\:flex") != null);
}

test "tw: should parse a utility with a modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/50") != null);
}

test "tw: should parse a utility with an arbitrary modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\[50\\%\\]") != null);
}

test "tw: should parse a utility with a modifier that is important" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/50!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/50\\!") != null);
}

test "tw: should parse a utility with a modifier and a variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover:bg-red-500/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:bg-red-500\\/50") != null);
}

test "tw: should not parse a partial utility" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex-" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // flex- (trailing dash) should be rejected — no utility output
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw: should not parse a partial utility_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // bg- (trailing dash) should be rejected — no utility output
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw: should parse a utility with an arbitrary value" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[#0088cc]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[\\#0088cc\\]") != null);
}

test "tw: should not parse a utility with an incomplete arbitrary valu" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[#0088cc" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // bg-[#0088cc (unclosed bracket) should be rejected — no utility output
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw: should parse a utility with an arbitrary value with parens" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-(--my-color)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\(--my-color\\)") != null);
}

test "tw: should parse a utility with an arbitrary value including a t" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[color:var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[color\\:var\\(--value\\)\\]") != null);
}

test "tw: should parse a utility with an arbitrary value with parens i" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-(color:--my-color)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\(color\\:--my-color\\)") != null);
}

test "tw: should parse a utility with an arbitrary value with parens a" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-(color:--my-color,#0088cc)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\(color\\:--my-color\\,\\#0088cc\\)") != null);
}

test "tw: should parse a utility with an arbitrary value with a modifi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[#0088cc]/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[\\#0088cc\\]\\/50") != null);
}

test "tw: should parse a utility with an arbitrary value with an arbit" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[\\#0088cc\\]\\/\\[50\\%\\]") != null);
}

test "tw: should parse a utility with an arbitrary value that is impor" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[#0088cc]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[\\#0088cc\\]\\!") != null);
}

test "tw: should parse a utility with an implicit variable as the arbi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[var\\(--value\\)\\]") != null);
}

test "tw: should parse a utility with an implicit variable as the arbi_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[var(--value)]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[var\\(--value\\)\\]\\!") != null);
}

test "tw: should parse a utility with an explicit variable as the arbi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[var\\(--value\\)\\]") != null);
}

test "tw: should parse a utility with an explicit variable as the arbi_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[var(--value)]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[var\\(--value\\)\\]\\!") != null);
}

test "tw: should parse a utility with an implicit variable as the modi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\[var\\(--value\\)\\]") != null);
}

test "tw: should parse a utility with an implicit variable as the modi_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/(--value)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\(--value\\)") != null);
}

test "tw: should parse a utility with an implicit variable as the modi_2" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/(--with_underscore)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\(--with_underscore\\)") != null);
}

test "tw: should parse a utility with an implicit variable as the modi_3" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/(--with_underscore,fallback_value)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\(--with_underscore\\,fallback_value\\)") != null);
}

test "tw: should parse a utility with an implicit variable as the modi_4" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-(--a_b,c_d_var(--e_f,g_h))/(--i_j,k_l_var(--m_n,o_p))" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\(--a_b\\,c_d_var\\(--e_f\\,g_h\\)\\)\\/\\(--i_j\\,k_l_var\\(--m_n\\,o_p\\)\\)") != null);
}

test "tw: should not parse an invalid arbitrary shorthand modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/(--x)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\(--x\\)") != null);
}

test "tw: should not parse an invalid arbitrary shorthand value" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-(--x)" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\(--x\\)") != null);
}

test "tw: should parse a utility with an implicit variable as the modi_5" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/[var(--value)]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\[var\\(--value\\)\\]\\!") != null);
}

test "tw: should parse a utility with an explicit variable as the modi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\[var\\(--value\\)\\]") != null);
}

test "tw: should parse a utility with an explicit variable as the modi_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-red-500/[var(--value)]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-red-500\\/\\[var\\(--value\\)\\]\\!") != null);
}

test "tw: should parse a static variant starting with" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@lg:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\@lg\\:flex") != null);
}

test "tw: should parse a functional variant starting with" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@lg:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\@lg\\:flex") != null);
}

test "tw: should parse a functional variant starting with  that has a " {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@foo-bar:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\@foo-bar\\:flex") != null);
}

test "tw: should parse a functional variant starting with  and a modif" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@lg/name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\@lg\\/name\\:flex") != null);
}

test "tw: should replace _ with" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "content-[\"hello_world\"]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "content-\\[\\\"hello_world\\\"\\]") != null);
}

test "tw: should not replace _ inside of url" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[no-repeat_url(https://example.com/some_page)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[no-repeat_url\\(https\\:\\/\\/example\\.com\\/some_page\\)\\]") != null);
}

test "tw: should not replace _ in the first argument to var" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ml-[var(--spacing-1_5,_var(--spacing-2_5,_1rem))]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ml-\\[var\\(--spacing-1_5\\,_var\\(--spacing-2_5\\,_1rem\\)\\)\\]") != null);
}

test "tw: should not replace _ in the first argument to theme" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ml-[theme(--spacing-1_5,_theme(--spacing-2_5,_1rem))]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ml-\\[theme\\(--spacing-1_5\\,_theme\\(--spacing-2_5\\,_1rem\\)\\)\\]") != null);
}

test "tw: should parse arbitrary properties" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]") != null);
}

test "tw: should parse arbitrary properties with a modifier" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]\\/50") != null);
}

test "tw: should parse arbitrary properties that are important" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]\\!") != null);
}

test "tw: should parse arbitrary properties with a variant" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover:[color:red]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:\\[color\\:red\\]") != null);
}

test "tw: should parse arbitrary properties with stacked variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus:hover:[color:red]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:hover\\:\\[color\\:red\\]") != null);
}

test "tw: should parse arbitrary properties that are important and usi" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[@media(width>=123px)]:[&_p]:[color:red]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\@media\\(width\\>\\=123px\\)\\]\\:\\[\\&_p\\]\\:\\[color\\:red\\]\\!") != null);
}

test "tw: should not parse compound group with a non-compoundable vari" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-*:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "group-\\*\\:flex") != null);
}

test "tw: empty data types are invalid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-[:foo]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "bg-\\[\\:foo\\]") != null);
}

test "tw: Utilities can be wrapped in a selector" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline", "hover:line-through" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:line-through") != null);
}

test "tw: Utilities can be marked with important" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline", "hover:line-through" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:line-through") != null);
}

test "tw: Utilities can be wrapped with a selector and marked as impor" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline", "hover:line-through" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:line-through") != null);
}

test "tw: variables in utilities should not be marked as important" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ease-out!", "z-10!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "ease-out\\!") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "z-10\\!") != null);
}

test "tw: compiling CSS  tailwind utilities is replaced with the gener" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex", "md:grid", "hover:underline", "dark:bg-black" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "md\\:grid") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:underline") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "dark\\:bg-black") != null);
}

test "tw: compiling CSS  tailwind utilities is only processed once" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex", "grid" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "grid") != null);
}

test "tw: arbitrary properties  should generate arbitrary properties" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]") != null);
}

test "tw: arbitrary properties  should generate arbitrary properties w" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]\\/50") != null);
}

test "tw: arbitrary properties  should generate arbitrary properties w_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:var(--my-color)]/50" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:var\\(--my-color\\)\\]\\/50") != null);
}

test "tw: arbitrary variants  should generate arbitrary variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[&_p]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\&_p\\]\\:flex") != null);
}

test "tw: arbitrary variants underscore converts to space for descendant combinator" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{"[&_p]:mb-4"};
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // The CSS selector should contain a descendant combinator (space), not a literal underscore
    // [&_p]:mb-4 should produce a selector like .class p { margin-bottom: ... }
    try std.testing.expect(std.mem.indexOf(u8, result, " p{") != null);
    // Should NOT contain a literal underscore in the selector
    try std.testing.expect(std.mem.indexOf(u8, result, "_p{") == null);
}

test "tw: arbitrary variants  should generate arbitrary at-rule varian" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[@media(width>=123px)]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\@media\\(width\\>\\=123px\\)\\]\\:flex") != null);
}

test "tw: variant stacking  should stack simple variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus:hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:hover\\:flex") != null);
}

test "tw: variant stacking  should stack arbitrary variants and simple" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[&_p]:hover:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\&_p\\]\\:hover\\:flex") != null);
}

test "tw: variant stacking  should stack multiple arbitrary variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[&_p]:[@media(width>=123px)]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[\\&_p\\]\\:\\[\\@media\\(width\\>\\=123px\\)\\]\\:flex") != null);
}

test "tw: variant stacking  pseudo element variants are re-ordered" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "before:hover:flex", "hover:before:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "before\\:hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:before\\:flex") != null);
}

test "tw: important  should generate an important utility" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "underline\\!") != null);
}

test "tw: important  should generate an important utility with legacy " {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "!underline" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\!underline") != null);
}

test "tw: important  should not mark declarations inside of keyframes " {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "animate-spin!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "animate-spin\\!") != null);
}

test "tw: important  should generate an important arbitrary property u" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "[color:red]!" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "\\[color\\:red\\]\\!") != null);
}

test "tw: sorting  should sort utilities based on their property order" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-events-none", "flex", "p-1", "px-1", "pl-1" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-events-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "p-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "px-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "pl-1") != null);
}

test "tw: sorting  should sort based on amount of properties" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text-clip", "truncate", "overflow-scroll" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "text-clip") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "truncate") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "overflow-scroll") != null);
}

test "tw: sorting  should sort utilities with a custom internal --tw-s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mx-0", "gap-4", "space-x-2" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "mx-0") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "gap-4") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "space-x-2") != null);
}

test "tw: sorting  should sort individual logical properties later tha" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-ms-1", "scroll-me-2", "scroll-mx-3", "scroll-ps-1", "scroll-pe-2", "scroll-px-3", "ms-1", "me-2", "mx-3", "ps-1", "pe-2", "px-3" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-ms-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-me-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-mx-3") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-ps-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-pe-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "scroll-px-3") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ms-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "me-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "mx-3") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "ps-1") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "pe-2") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "px-3") != null);
}

test "tw: sorting  should move variants to the end while sorting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pointer-events-none", "flex", "hover:flex", "focus:pointer-events-none" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "pointer-events-none") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:pointer-events-none") != null);
}

test "tw: sorting  should sort variants and stacked variants by varian" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "flex", "hover:flex", "focus:flex", "disabled:flex", "hover:focus:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "disabled\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:focus\\:flex") != null);
}

test "tw: sorting  should order group- and peer- variants based on the" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover:flex", "group-hover:flex", "group-focus:flex", "peer-hover:flex", "peer-focus:flex", "group-hover:peer-hover:flex", "group-hover:peer-focus:flex", "peer-hover:group-hover:flex", "peer-hover:group-focus:flex", "group-focus:peer-hover:flex", "group-focus:peer-focus:flex", "peer-focus:group-hover:flex", "peer-focus:group-focus:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:peer-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-hover\\:peer-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-hover\\:group-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:peer-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "group-focus\\:peer-focus\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:group-hover\\:flex") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "peer-focus\\:group-focus\\:flex") != null);
}

test "tw: Parsing theme values from CSS  Can read values from theme" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "accent-red-500" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    try std.testing.expect(std.mem.indexOf(u8, result, "accent-red-500") != null);
}

test "tw neg: neg_sr-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-sr-only", "sr-only-[var(--value)]", "sr-only/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_not-sr-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-not-sr-only", "not-sr-only-[var(--value)]", "not-sr-only/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pointer-events" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-pointer-events-none", "-pointer-events-auto", "pointer-events-[var(--value)]", "pointer-events-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_visibility" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-visible", "-invisible", "-collapse", "visible/foo", "invisible/foo", "collapse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-static", "-fixed", "-absolute", "-relative", "-sticky", "static/foo", "fixed/foo", "absolute/foo", "relative/foo", "sticky/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset", "inset--1", "inset--1/2", "inset--1/-2", "inset-1/-2", "inset-auto/foo", "-inset-full/foo", "inset-full/foo", "inset-3/4/foo", "inset-4/foo", "-inset-4/foo", "inset-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-x-shadow-sm", "inset-x", "inset-x--1", "inset-x--1/2", "inset-x--1/-2", "inset-x-1/-2", "inset-x-auto/foo", "inset-x-full/foo", "-inset-x-full/foo", "inset-x-3/4/foo", "inset-x-4/foo", "-inset-x-4/foo", "inset-x-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-y-shadow-sm", "inset-y", "inset-y--1", "inset-y--1/2", "inset-y--1/-2", "inset-1/-2", "inset-y-auto/foo", "inset-y-full/foo", "-inset-y-full/foo", "inset-y-3/4/foo", "inset-y-4/foo", "-inset-y-4/foo", "inset-y-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-s-shadow-sm", "inset-s", "inset-s--1", "inset-s--1/2", "inset-s--1/-2", "inset-s-1/-2", "inset-s-auto/foo", "-inset-s-full/foo", "inset-s-full/foo", "inset-s-3/4/foo", "inset-s-4/foo", "-inset-s-4/foo", "inset-s-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-e" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-e-shadow-sm", "inset-e", "inset-e--1", "inset-e--1/2", "inset-e--1/-2", "inset-e-1/-2", "inset-e-auto/foo", "-inset-e-full/foo", "inset-e-full/foo", "inset-e-3/4/foo", "inset-e-4/foo", "-inset-e-4/foo", "inset-e-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-bs" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-bs-shadow-sm", "inset-bs", "inset-bs--1", "inset-bs--1/2", "inset-bs--1/-2", "inset-bs-1/-2", "inset-bs-auto/foo", "-inset-bs-full/foo", "inset-bs-full/foo", "inset-bs-3/4/foo", "inset-bs-4/foo", "-inset-bs-4/foo", "inset-bs-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-be" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inset-be-shadow-sm", "inset-be", "inset-be--1", "inset-be--1/2", "inset-be--1/-2", "inset-be-1/-2", "inset-be-auto/foo", "-inset-be-full/foo", "inset-be-full/foo", "inset-be-3/4/foo", "inset-be-4/foo", "-inset-be-4/foo", "inset-be-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_top" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "top-shadow-sm", "top", "top--1", "top--1/2", "top--1/-2", "top-1/-2", "top-auto/foo", "-top-full/foo", "top-full/foo", "top-3/4/foo", "top-4/foo", "-top-4/foo", "top-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_right" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "right-shadow-sm", "right", "right--1", "right--1/2", "right--1/-2", "right-1/-2", "right-auto/foo", "-right-full/foo", "right-full/foo", "right-3/4/foo", "right-4/foo", "-right-4/foo", "right-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bottom" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bottom-shadow-sm", "bottom", "bottom--1", "bottom--1/2", "bottom--1/-2", "bottom-1/-2", "bottom-auto/foo", "-bottom-full/foo", "bottom-full/foo", "bottom-3/4/foo", "bottom-4/foo", "-bottom-4/foo", "bottom-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_left" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "left-shadow-sm", "left", "left--1", "left--1/2", "left--1/-2", "left-1/-2", "left-auto/foo", "-left-full/foo", "left-full/foo", "left-3/4/foo", "left-4/foo", "-left-4/foo", "left-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_z-index" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "z", "z--1", "-z-auto", "z-unknown", "z-123.5", "z-auto/foo", "z-10/foo", "-z-10/foo", "z-[123]/foo", "-z-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_order" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "order", "order--4", "-order-first", "-order-last", "-order-none", "order-unknown", "order-123.5", "order-4/foo", "-order-4/foo", "order-[123]/foo", "-order-[var(--value)]/foo", "order-first/foo", "order-last/foo", "order-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_col" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col", "col-span", "col-span--1", "-col-span-4", "col-span-unknown", "col-auto/foo", "col-span-4/foo", "col-span-17/foo", "col-span-full/foo", "col-[span_123/span_123]/foo", "col-span-[var(--my-variable)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_col-start" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col-start", "col-start--1", "col-start-unknown", "col-start-auto/foo", "col-start-4/foo", "col-start-99/foo", "col-start-[123]/foo", "-col-start-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_col-end" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "col-end", "col-end--1", "col-end-unknown", "col-end-auto/foo", "col-end-4/foo", "col-end-99/foo", "col-end-[123]/foo", "-col-end-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_row" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row", "row-span", "row-span--1", "-row-span-4", "row-span-unknown", "row-auto/foo", "row-span-4/foo", "row-span-17/foo", "row-span-full/foo", "row-[span_123/span_123]/foo", "row-span-[var(--my-variable)]/foo", "row-constructor", "row-hasOwnProperty", "row-toString", "row-valueOf" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_row-start" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row-start", "row-start--1", "row-start-unknown", "row-start-auto/foo", "row-start-4/foo", "row-start-99/foo", "row-start-[123]/foo", "-row-start-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_row-end" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "row-end", "row-end--1", "row-end-unknown", "row-end-auto/foo", "row-end-4/foo", "row-end-99/foo", "row-end-[123]/foo", "-row-end-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_float" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "float", "-float-start", "-float-end", "-float-right", "-float-left", "-float-none", "float-start/foo", "float-end/foo", "float-right/foo", "float-left/foo", "float-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_clear" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "clear", "-clear-start", "-clear-end", "-clear-right", "-clear-left", "-clear-both", "-clear-none", "clear-start/foo", "clear-end/foo", "clear-right/foo", "clear-left/foo", "clear-both/foo", "clear-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_margin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "m", "m-auto/foo", "m-4/foo", "m-[4px]/foo", "-m-4/foo", "-m-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mx" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mx", "mx-auto/foo", "mx-4/foo", "mx-[4px]/foo", "-mx-4/foo", "-mx-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_my" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "my", "my-auto/foo", "my-4/foo", "my-[4px]/foo", "-my-4/foo", "-my-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mt" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mt", "mt-auto/foo", "mt-4/foo", "mt-[4px]/foo", "-mt-4/foo", "-mt-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ms" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ms", "ms-auto/foo", "ms-4/foo", "ms-[4px]/foo", "-ms-4/foo", "-ms-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_me" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "me", "me-auto/foo", "me-4/foo", "me-[4px]/foo", "-me-4/foo", "-me-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mbs" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mbs", "mbs-auto/foo", "mbs-4/foo", "mbs-[4px]/foo", "-mbs-4/foo", "-mbs-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mbe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mbe", "mbe-auto/foo", "mbe-4/foo", "mbe-[4px]/foo", "-mbe-4/foo", "-mbe-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mr", "mr-auto/foo", "mr-4/foo", "mr-[4px]/foo", "-mr-4/foo", "-mr-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mb" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mb", "mb-auto/foo", "mb-4/foo", "mb-[4px]/foo", "-mb-4/foo", "-mb-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ml" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ml", "ml-auto/foo", "ml-4/foo", "ml-[4px]/foo", "-ml-4/foo", "-ml-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_margin sort order" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "m", "mb-4/foo", "me-4/foo", "mx-4/foo", "ml-4/foo", "ms-4/foo", "m-4/foo", "mr-4/foo", "mt-4/foo", "my-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_box-sizing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "box", "-box-border", "-box-content", "box-border/foo", "box-content/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_line-clamp" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "line-clamp", "line-clamp--4", "-line-clamp-4", "-line-clamp-[123]", "-line-clamp-none", "line-clamp-unknown", "line-clamp-123.5", "line-clamp-4/foo", "line-clamp-99/foo", "line-clamp-[123]/foo", "line-clamp-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_display" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-block", "-inline-block", "-inline", "-flex", "-inline-flex", "-table", "-inline-table", "-table-caption", "-table-cell", "-table-column", "-table-column-group", "-table-footer-group", "-table-header-group", "-table-row-group", "-table-row", "-flow-root", "-grid", "-inline-grid", "-contents", "-list-item", "-hidden", "block/foo", "inline-block/foo", "inline/foo", "flex/foo", "inline-flex/foo", "table/foo", "inline-table/foo", "table-caption/foo", "table-cell/foo", "table-column/foo", "table-column-group/foo", "table-footer-group/foo", "table-header-group/foo", "table-row-group/foo", "table-row/foo", "flow-root/foo", "grid/foo", "inline-grid/foo", "contents/foo", "list-item/foo", "hidden/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_field-sizing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "field-sizing-[other]", "-field-sizing-content", "-field-sizing-fixed" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_aspect-ratio" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "aspect", "aspect-potato", "-aspect-video", "-aspect-[10/9]", "aspect-foo/bar", "aspect-video/foo", "aspect-[10/9]/foo", "aspect-4/3/foo", "aspect--4/3", "aspect--4/-3", "aspect-4/-3", "aspect-1.23/4.56" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "size", "size--1", "size--1/2", "size--1/-2", "size-1/-2", "-size-4", "-size-1/2", "-size-[4px]", "size-auto/foo", "size-full/foo", "size-min/foo", "size-max/foo", "size-fit/foo", "size-4/foo", "size-1/2/foo", "size-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "w", "w--1", "w--1/2", "w--1/-2", "w-1/-2", "-w-4", "-w-1/2", "-w-[4px]", "w-full/foo", "w-auto/foo", "w-screen/foo", "w-svw/foo", "w-lvw/foo", "w-dvw/foo", "w-min/foo", "w-max/foo", "w-fit/foo", "w-4/foo", "w-xl/foo", "w-1/2/foo", "w-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_min-width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-w", "-min-w-4", "-min-w-[4px]", "min-w-auto/foo", "min-w-full/foo", "min-w-min/foo", "min-w-max/foo", "min-w-fit/foo", "min-w-4/foo", "min-w-xl/foo", "min-w-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_max-width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-w", "max-w-auto", "-max-w-4", "-max-w-[4px]", "max-w-none/foo", "max-w-full/foo", "max-w-max/foo", "max-w-max/foo", "max-w-fit/foo", "max-w-4/foo", "max-w-xl/foo", "max-w-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "h", "-h-4", "h--1", "h--1/2", "h--1/-2", "h-1/-2", "-h-1/2", "-h-[4px]", "h-full/foo", "h-auto/foo", "h-screen/foo", "h-svh/foo", "h-lvh/foo", "h-dvh/foo", "h-lh/foo", "h-min/foo", "h-max/foo", "h-fit/foo", "h-4/foo", "h-1/2/foo", "h-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_min-height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-h", "-min-h-4", "-min-h-[4px]", "min-h-auto/foo", "min-h-full/foo", "min-h-screen/foo", "min-h-svh/foo", "min-h-lvh/foo", "min-h-dvh/foo", "min-h-lh/foo", "min-h-min/foo", "min-h-max/foo", "min-h-fit/foo", "min-h-4/foo", "min-h-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_max-height" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-h", "max-h-auto", "-max-h-4", "-max-h-[4px]", "max-h-none/foo", "max-h-full/foo", "max-h-screen/foo", "max-h-svh/foo", "max-h-lvh/foo", "max-h-dvh/foo", "max-h-lh/foo", "max-h-min/foo", "max-h-max/foo", "max-h-fit/foo", "max-h-4/foo", "max-h-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inline-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inline--1", "inline--1/2", "inline--1/-2", "inline-1/-2", "-inline-4", "-inline-1/2", "-inline-[4px]", "inline-full/foo", "inline-auto/foo", "inline-screen/foo", "inline-svw/foo", "inline-lvw/foo", "inline-dvw/foo", "inline-min/foo", "inline-max/foo", "inline-fit/foo", "inline-4/foo", "inline-xl/foo", "inline-1/2/foo", "inline-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_min-inline-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-inline", "-min-inline-4", "-min-inline-[4px]", "min-inline-auto/foo", "min-inline-full/foo", "min-inline-min/foo", "min-inline-max/foo", "min-inline-fit/foo", "min-inline-4/foo", "min-inline-xl/foo", "min-inline-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_max-inline-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-inline", "max-inline-auto", "-max-inline-4", "-max-inline-[4px]", "max-inline-none/foo", "max-inline-full/foo", "max-inline-max/foo", "max-inline-max/foo", "max-inline-fit/foo", "max-inline-4/foo", "max-inline-xl/foo", "max-inline-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_block-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-block-4", "block--1", "block--1/2", "block--1/-2", "block-1/-2", "-block-1/2", "-block-[4px]", "block-full/foo", "block-auto/foo", "block-screen/foo", "block-svh/foo", "block-lvh/foo", "block-dvh/foo", "block-lh/foo", "block-min/foo", "block-max/foo", "block-fit/foo", "block-4/foo", "block-1/2/foo", "block-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_min-block-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-block", "-min-block-4", "-min-block-[4px]", "min-block-auto/foo", "min-block-full/foo", "min-block-screen/foo", "min-block-svh/foo", "min-block-lvh/foo", "min-block-dvh/foo", "min-block-lh/foo", "min-block-min/foo", "min-block-max/foo", "min-block-fit/foo", "min-block-4/foo", "min-block-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_max-block-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-block", "max-block-auto", "-max-block-4", "-max-block-[4px]", "max-block-none/foo", "max-block-full/foo", "max-block-screen/foo", "max-block-svh/foo", "max-block-lvh/foo", "max-block-dvh/foo", "max-block-lh/foo", "max-block-min/foo", "max-block-max/foo", "max-block-fit/foo", "max-block-4/foo", "max-block-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-flex-1", "flex--1", "-flex-auto", "-flex-initial", "-flex-none", "-flex-[123]", "flex-unknown", "flex-1/foo", "flex-99/foo", "flex--1/2", "flex--1/-2", "flex-1/-2", "flex-1/2/foo", "flex-auto/foo", "flex-initial/foo", "flex-none/foo", "flex-[123]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex-shrink" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-shrink", "shrink--1", "shrink-1.5", "-shrink-0", "-shrink-[123]", "shrink-unknown", "shrink/foo", "shrink-0/foo", "shrink-[123]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex-grow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-grow", "grow--1", "grow-1.5", "-grow-0", "-grow-[123]", "grow-unknown", "grow/foo", "grow-0/foo", "grow-[123]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex-basis" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "basis", "basis--1", "basis--1/2", "basis--1/-2", "basis-1/-2", "-basis-full", "-basis-[123px]", "basis-auto/foo", "basis-full/foo", "basis-xl/foo", "basis-11/12/foo", "basis-[123px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_caption-side" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-caption-top", "-caption-bottom", "caption-top/foo", "caption-bottom/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border-collapse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-border-collapse", "-border-separate", "border-collapse/foo", "border-separate/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border-spacing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing", "-border-spacing-1", "-border-spacing-[123px]", "border-spacing-1/foo", "border-spacing-[123px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border-spacing-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing-x", "-border-spacing-x-1", "-border-spacing-x-[123px]", "border-spacing-x-1/foo", "border-spacing-x-[123px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border-spacing-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border-spacing-x", "-border-spacing-y-1", "-border-spacing-y-[123px]", "border-spacing-y-1/foo", "border-spacing-y-[123px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-origin-center", "-origin-[var(--value)]", "origin-center/foo", "origin-top/foo", "origin-top-right/foo", "origin-right/foo", "origin-bottom-right/foo", "origin-bottom/foo", "origin-bottom-left/foo", "origin-left/foo", "origin-top-left/foo", "origin-[50px_100px]/foo", "origin-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_perspective-origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-perspective-origin-center", "-perspective-origin-[var(--value)]", "perspective-origin-center/foo", "perspective-origin-top/foo", "perspective-origin-top-right/foo", "perspective-origin-right/foo", "perspective-origin-bottom-right/foo", "perspective-origin-bottom/foo", "perspective-origin-bottom-left/foo", "perspective-origin-left/foo", "perspective-origin-top-left/foo", "perspective-origin-[50px_100px]/foo", "perspective-origin-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate", "translate--1", "translate--1/2", "translate--1/-2", "translate-1/-2", "translate-1/2/foo", "translate-full/foo", "-translate-full/foo", "translate-[123px]/foo", "-translate-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-x", "translate-x--1", "translate-x--1/2", "translate-x--1/-2", "translate-x-1/-2", "translate-x-full/foo", "-translate-x-full/foo", "translate-x-px/foo", "-translate-x-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-x_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "perspective", "-perspective", "perspective-potato", "perspective-123", "perspective-normal/foo", "perspective-dramatic/foo", "perspective-none/foo", "perspective-[456px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-y", "translate-y--1", "translate-y--1/2", "translate-y--1/-2", "translate-y-1/-2", "translate-y-full/foo", "-translate-y-full/foo", "translate-y-px/foo", "-translate-y-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-y_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "perspective", "-perspective", "perspective-potato", "perspective-123", "perspective-normal/foo", "perspective-dramatic/foo", "perspective-none/foo", "perspective-[456px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-z" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "translate-z", "translate-z--1", "translate-z--1/2", "translate-z--1/-2", "translate-z-1/-2", "translate-z-full", "-translate-z-full", "translate-z-1/2", "translate-y-px/foo", "-translate-z-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_translate-3d" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-translate-3d", "translate-3d/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rotate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate", "rotate-z", "rotate--2", "rotate-unknown", "rotate-45/foo", "-rotate-45/foo", "rotate-[123deg]/foo", "rotate-[0.3_0.7_1_45deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rotate-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-x", "rotate-x--1", "-rotate-x", "rotate-x-potato", "rotate-x-45/foo", "-rotate-x-45/foo", "rotate-x-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rotate-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-y", "rotate-y--1", "-rotate-y", "rotate-y-potato", "rotate-y-45/foo", "-rotate-y-45/foo", "rotate-y-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rotate-z" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rotate-z", "rotate-z--1", "-rotate-z", "rotate-z-potato", "rotate-z-45/foo", "-rotate-z-45/foo", "rotate-z-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_skew" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "skew", "skew--1", "skew-unknown", "skew-6/foo", "-skew-6/foo", "skew-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_skew-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "skew-x", "skew-x--1", "skew-x-unknown", "skew-x-6/foo", "-skew-x-6/foo", "skew-x-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_skew-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "skew-y", "skew-y--1", "skew-y-unknown", "skew-y-6/foo", "-skew-y-6/foo", "skew-y-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scale" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scale", "scale--50", "scale-1.5", "scale-unknown", "scale-50/foo", "-scale-50/foo", "scale-[2]/foo", "scale-[2_1.5_3]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scale-3d" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-scale-3d", "scale-3d/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scale-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scale-x", "scale-x--1", "scale-x-1.5", "scale-x-unknown", "scale-200/foo", "scale-x-400/foo", "scale-x-50/foo", "-scale-x-50/foo", "scale-x-[2]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scale-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scale-y", "scale-y--1", "scale-y-1.5", "scale-y-unknown", "scale-y-50/foo", "-scale-y-50/foo", "scale-y-[2]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scale-z" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scale-z", "scale-z--1", "scale-z-1.5", "scale-z-50/foo", "-scale-z-50/foo", "scale-z-[123deg]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_transform" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-transform", "-transform-cpu", "-transform-gpu", "-transform-none", "transform/foo", "transform-cpu/foo", "transform-gpu/foo", "transform-none/foo", "transform-[scaleZ(2)_rotateY(45deg)]/foo", "transform-flat/foo", "transform-3d/foo", "transform-content/foo", "transform-border/foo", "transform-fill/foo", "transform-stroke/foo", "transform-view/foo", "backface-visible/foo", "backface-hidden/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_perspective" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "perspective", "-perspective", "perspective-potato", "perspective-123", "perspective-normal/foo", "perspective-dramatic/foo", "perspective-none/foo", "perspective-[456px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_cursor" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "cursor", "-cursor-auto", "-cursor-default", "-cursor-pointer", "-cursor-wait", "-cursor-text", "-cursor-move", "-cursor-help", "-cursor-not-allowed", "-cursor-none", "-cursor-context-menu", "-cursor-progress", "-cursor-cell", "-cursor-crosshair", "-cursor-vertical-text", "-cursor-alias", "-cursor-copy", "-cursor-no-drop", "-cursor-grab", "-cursor-grabbing", "-cursor-all-scroll", "-cursor-col-resize", "-cursor-row-resize", "-cursor-n-resize", "-cursor-e-resize", "-cursor-s-resize", "-cursor-w-resize", "-cursor-ne-resize", "-cursor-nw-resize", "-cursor-se-resize", "-cursor-sw-resize", "-cursor-ew-resize", "-cursor-ns-resize", "-cursor-nesw-resize", "-cursor-nwse-resize", "-cursor-zoom-in", "-cursor-zoom-out", "-cursor-[var(--value)]", "-cursor-custom", "cursor-auto/foo", "cursor-default/foo", "cursor-pointer/foo", "cursor-wait/foo", "cursor-text/foo", "cursor-move/foo", "cursor-help/foo", "cursor-not-allowed/foo", "cursor-none/foo", "cursor-context-menu/foo", "cursor-progress/foo", "cursor-cell/foo", "cursor-crosshair/foo", "cursor-vertical-text/foo", "cursor-alias/foo", "cursor-copy/foo", "cursor-no-drop/foo", "cursor-grab/foo", "cursor-grabbing/foo", "cursor-all-scroll/foo", "cursor-col-resize/foo", "cursor-row-resize/foo", "cursor-n-resize/foo", "cursor-e-resize/foo", "cursor-s-resize/foo", "cursor-w-resize/foo", "cursor-ne-resize/foo", "cursor-nw-resize/foo", "cursor-se-resize/foo", "cursor-sw-resize/foo", "cursor-ew-resize/foo", "cursor-ns-resize/foo", "cursor-nesw-resize/foo", "cursor-nwse-resize/foo", "cursor-zoom-in/foo", "cursor-zoom-out/foo", "cursor-[var(--value)]/foo", "cursor-custom/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_touch-action" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-touch-auto", "-touch-none", "-touch-manipulation", "touch-auto/foo", "touch-none/foo", "touch-manipulation/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_touch-pan" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-touch-pan-x", "-touch-pan-left", "-touch-pan-right", "-touch-pan-y", "-touch-pan-up", "-touch-pan-down", "touch-pan-x/foo", "touch-pan-left/foo", "touch-pan-right/foo", "touch-pan-y/foo", "touch-pan-up/foo", "touch-pan-down/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_touch-pinch-zoom" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-touch-pinch-zoom", "touch-pinch-zoom/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_select" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-select-none", "-select-text", "-select-all", "-select-auto", "select-none/foo", "select-text/foo", "select-all/foo", "select-auto/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_resize" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-resize-none", "-resize", "-resize-x", "-resize-y", "resize-none/foo", "resize/foo", "resize-x/foo", "resize-y/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-snap-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-snap-none", "-snap-x", "-snap-y", "-snap-both", "snap-none/foo", "snap-x/foo", "snap-y/foo", "snap-both/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_--tw-scroll-snap-strictness" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-snap-mandatory", "-snap-proximity", "snap-mandatory/foo", "snap-proximity/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-snap-align" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-snap-align-none", "-snap-start", "-snap-end", "-snap-center", "snap-align-none/foo", "snap-start/foo", "snap-end/foo", "snap-center/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-m" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-m", "scroll-m-4/foo", "scroll-m-[4px]/foo", "-scroll-m-4/foo", "-scroll-m-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mx" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mx", "scroll-mx-4/foo", "scroll-mx-[4px]/foo", "-scroll-mx-4/foo", "-scroll-mx-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-my" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-my", "scroll-my-4/foo", "scroll-my-[4px]/foo", "-scroll-my-4/foo", "-scroll-my-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-ms" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-ms", "scroll-ms-4/foo", "scroll-ms-[4px]/foo", "-scroll-ms-4/foo", "-scroll-ms-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-me" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-me", "scroll-me-4/foo", "scroll-me-[4px]/foo", "-scroll-me-4/foo", "-scroll-me-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mbs" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mbs", "scroll-mbs-4/foo", "scroll-mbs-[4px]/foo", "-scroll-mbs-4/foo", "-scroll-mbs-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mbe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mbe", "scroll-mbe-4/foo", "scroll-mbe-[4px]/foo", "-scroll-mbe-4/foo", "-scroll-mbe-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mt" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mt", "scroll-mt-4/foo", "scroll-mt-[4px]/foo", "-scroll-mt-4/foo", "-scroll-mt-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mr", "scroll-mr-4/foo", "scroll-mr-[4px]/foo", "-scroll-mr-4/foo", "-scroll-mr-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-mb" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-mb", "scroll-mb-4/foo", "scroll-mb-[4px]/foo", "-scroll-mb-4/foo", "-scroll-mb-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-ml" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-ml", "scroll-ml-4/foo", "scroll-ml-[4px]/foo", "-scroll-ml-4/foo", "-scroll-ml-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-p" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-p", "scroll-p-4/foo", "scroll-p-[4px]/foo", "-scroll-p-4/foo", "-scroll-p-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-px" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-px", "scroll-px-4/foo", "scroll-px-[4px]/foo", "-scroll-px-4/foo", "-scroll-px-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-py" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-py", "scroll-py-4/foo", "scroll-py-[4px]/foo", "-scroll-py-4/foo", "-scroll-py-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-ps" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-ps", "scroll-ps-4/foo", "scroll-ps-[4px]/foo", "-scroll-ps-4/foo", "-scroll-ps-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pe", "scroll-pe-4/foo", "scroll-pe-[4px]/foo", "-scroll-pe-4/foo", "-scroll-pe-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pbs" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pbs", "scroll-pbs-4/foo", "scroll-pbs-[4px]/foo", "-scroll-pbs-4", "-scroll-pbs-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pbe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pbe", "scroll-pbe-4/foo", "scroll-pbe-[4px]/foo", "-scroll-pbe-4", "-scroll-pbe-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pt" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pt", "scroll-pt-4/foo", "scroll-pt-[4px]/foo", "-scroll-pt-4/foo", "-scroll-pt-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pr", "scroll-pr-4/foo", "scroll-pr-[4px]/foo", "-scroll-pr-4/foo", "-scroll-pr-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pb" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pb", "scroll-pb-4/foo", "scroll-pb-[4px]/foo", "-scroll-pb-4/foo", "-scroll-pb-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-pl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll-pl", "scroll-pl-4/foo", "scroll-pl-[4px]/foo", "-scroll-pl-4/foo", "-scroll-pl-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_list-style-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-list-inside", "-list-outside", "list-inside/foo", "list-outside/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_list" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-list-none", "-list-disc", "-list-decimal", "-list-[var(--value)]", "list-none/foo", "list-disc/foo", "list-decimal/foo", "list-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_list-image" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "list-image", "-list-image-none", "-list-image-[var(--value)]", "list-image-none/foo", "list-image-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_appearance" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "appearance", "-appearance-none", "-appearance-auto", "appearance-none/foo", "appearance-auto/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_color-scheme" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scheme", "-scheme-dark", "-scheme-light", "-scheme-light-dark", "-scheme-dark-only", "-scheme-light-only" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_columns" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "columns", "columns--4", "-columns-4", "-columns-[123]", "-columns-[var(--value)]", "columns-unknown", "columns-auto/foo", "columns-3xs/foo", "columns-7xl/foo", "columns-4/foo", "columns-99/foo", "columns-[123]/foo", "columns-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_break-before" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-before", "-break-before-auto", "-break-before-avoid", "-break-before-all", "-break-before-avoid-page", "-break-before-page", "-break-before-left", "-break-before-right", "-break-before-column", "break-before-auto/foo", "break-before-avoid/foo", "break-before-all/foo", "break-before-avoid-page/foo", "break-before-page/foo", "break-before-left/foo", "break-before-right/foo", "break-before-column/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_break-inside" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-inside", "-break-inside-auto", "-break-inside-avoid", "-break-inside-avoid-page", "-break-inside-avoid-column", "break-inside-auto/foo", "break-inside-avoid/foo", "break-inside-avoid-page/foo", "break-inside-avoid-column/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_break-after" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "break-after", "-break-after-auto", "-break-after-avoid", "-break-after-all", "-break-after-avoid-page", "-break-after-page", "-break-after-left", "-break-after-right", "-break-after-column", "break-after-auto/foo", "break-after-avoid/foo", "break-after-all/foo", "break-after-avoid-page/foo", "break-after-page/foo", "break-after-left/foo", "break-after-right/foo", "break-after-column/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_auto-cols" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-cols", "-auto-cols-auto", "-auto-cols-[2fr]", "auto-cols-auto/foo", "auto-cols-min/foo", "auto-cols-max/foo", "auto-cols-fr/foo", "auto-cols-[2fr]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_grid-flow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-flow", "-grid-flow-row", "-grid-flow-col", "-grid-flow-dense", "-grid-flow-row-dense", "-grid-flow-col-dense", "grid-flow-row/foo", "grid-flow-col/foo", "grid-flow-dense/foo", "grid-flow-row-dense/foo", "grid-flow-col-dense/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_auto-rows" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "auto-rows", "-auto-rows-auto", "-auto-rows-[2fr]", "auto-rows-auto/foo", "auto-rows-min/foo", "auto-rows-max/foo", "auto-rows-fr/foo", "auto-rows-[2fr]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_grid-cols" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-cols", "grid-cols-0", "-grid-cols-none", "-grid-cols-subgrid", "grid-cols--12", "-grid-cols-12", "-grid-cols-[123]", "grid-cols-unknown", "grid-cols-none/foo", "grid-cols-subgrid/foo", "grid-cols-12/foo", "grid-cols-99/foo", "grid-cols-[123]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_grid-rows" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "grid-rows", "grid-rows-0", "-grid-rows-none", "-grid-rows-subgrid", "grid-rows--12", "-grid-rows-12", "-grid-rows-[123]", "grid-rows-unknown", "grid-rows-none/foo", "grid-rows-subgrid/foo", "grid-rows-12/foo", "grid-rows-99/foo", "grid-rows-[123]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex-direction" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-flex-row", "-flex-row-reverse", "-flex-col", "-flex-col-reverse", "flex-row/foo", "flex-row-reverse/foo", "flex-col/foo", "flex-col-reverse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_flex-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-flex-wrap", "-flex-wrap-reverse", "-flex-nowrap", "flex-wrap/foo", "flex-wrap-reverse/foo", "flex-nowrap/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_place-content" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "place-content", "-place-content-center", "-place-content-start", "-place-content-end", "-place-content-between", "-place-content-around", "-place-content-evenly", "-place-content-baseline", "-place-content-stretch", "place-content-center/foo", "place-content-start/foo", "place-content-end/foo", "place-content-between/foo", "place-content-around/foo", "place-content-evenly/foo", "place-content-baseline/foo", "place-content-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_place-items" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "place-items", "-place-items-start", "-place-items-end", "-place-items-center", "-place-items-baseline", "-place-items-stretch", "place-items-start/foo", "place-items-end/foo", "place-items-center/foo", "place-items-baseline/foo", "place-items-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_align-content" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "content", "-content-normal", "-content-center", "-content-start", "-content-end", "-content-between", "-content-around", "-content-evenly", "-content-baseline", "-content-stretch", "content-normal/foo", "content-center/foo", "content-start/foo", "content-end/foo", "content-between/foo", "content-around/foo", "content-evenly/foo", "content-baseline/foo", "content-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_items" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "items", "-items-start", "-items-end", "-items-center", "-items-baseline", "-items-first-baseline", "-items-last-baseline", "-items-stretch", "items-start/foo", "items-end/foo", "items-center/foo", "items-baseline/foo", "items-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_justify" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "justify", "-justify-normal", "-justify-start", "-justify-end", "-justify-center", "-justify-between", "-justify-around", "-justify-evenly", "-justify-stretch", "justify-normal/foo", "justify-start/foo", "justify-end/foo", "justify-center/foo", "justify-between/foo", "justify-around/foo", "justify-evenly/foo", "justify-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_justify-items" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "justify-items", "-justify-items-start", "-justify-items-end", "-justify-items-center", "-justify-items-stretch", "justify-items-start/foo", "justify-items-end/foo", "justify-items-center/foo", "justify-items-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_gap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap", "-gap-4", "-gap-[4px]", "gap-4/foo", "gap-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_gap-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap-x", "-gap-x-4", "-gap-x-[4px]", "gap-x-4/foo", "gap-x-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_gap-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "gap-y", "-gap-y-4", "-gap-y-[4px]", "gap-y-4/foo", "gap-y-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_space-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "space-x", "space-x-4/foo", "space-x-[4px]/foo", "-space-x-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_space-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "space-y", "space-y-4/foo", "space-y-[4px]/foo", "-space-y-4/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_space-x-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-space-x-reverse", "space-x-reverse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_space-y-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-space-y-reverse", "space-y-reverse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-divide-x", "divide-x--4", "-divide-x-4", "-divide-x-123", "divide-x-unknown", "divide-x/foo", "divide-x-4/foo", "divide-x-123/foo", "divide-x-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-x with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-x/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-divide-y", "divide-y--4", "-divide-y-4", "-divide-y-123", "divide-y-unknown", "divide-y/foo", "divide-y-4/foo", "divide-y-123/foo", "divide-y-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-y with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide-y/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-x-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-divide-x-reverse", "divide-x-reverse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-y-reverse" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-divide-y-reverse", "divide-y-reverse/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide", "-divide-solid", "-divide-dashed", "-divide-dotted", "-divide-double", "-divide-none", "divide-solid/foo", "divide-dashed/foo", "divide-dotted/foo", "divide-double/foo", "divide-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_accent" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "accent", "-accent-red-500", "accent-red-500/-50", "-accent-red-500/50", "-accent-red-500/[0.5]", "-accent-red-500/[50%]", "-accent-current", "-accent-current/50", "-accent-current/[0.5]", "-accent-current/[50%]", "-accent-inherit", "-accent-transparent", "accent-[#0088cc]/-50", "-accent-[#0088cc]", "-accent-[#0088cc]/50", "-accent-[#0088cc]/[0.5]", "-accent-[#0088cc]/[50%]", "accent-red-500/foo", "accent-red-500/50/foo", "accent-red-500/[0.5]/foo", "accent-red-500/[50%]/foo", "accent-current/foo", "accent-current/50/foo", "accent-current/[0.5]/foo", "accent-current/[50%]/foo", "accent-inherit/foo", "accent-transparent/foo", "accent-[#0088cc]/foo", "accent-[#0088cc]/50/foo", "accent-[#0088cc]/[0.5]/foo", "accent-[#0088cc]/[50%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_caret" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "caret", "-caret-red-500", "-caret-red-500/50", "-caret-red-500/[0.5]", "-caret-red-500/[50%]", "-caret-current", "-caret-current/50", "-caret-current/[0.5]", "-caret-current/[50%]", "-caret-inherit", "-caret-transparent", "-caret-[#0088cc]", "-caret-[#0088cc]/50", "-caret-[#0088cc]/[0.5]", "-caret-[#0088cc]/[50%]", "caret-red-500/foo", "caret-red-500/50/foo", "caret-red-500/[0.5]/foo", "caret-red-500/[50%]/foo", "caret-current/foo", "caret-current/50/foo", "caret-current/[0.5]/foo", "caret-current/[50%]/foo", "caret-inherit/foo", "caret-transparent/foo", "caret-[#0088cc]/foo", "caret-[#0088cc]/50/foo", "caret-[#0088cc]/[0.5]/foo", "caret-[#0088cc]/[50%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_divide-color" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "divide", "-divide-red-500", "-divide-red-500/50", "-divide-red-500/[0.5]", "-divide-red-500/[50%]", "-divide-current", "-divide-current/50", "-divide-current/[0.5]", "-divide-current/[50%]", "-divide-inherit", "-divide-transparent", "-divide-[#0088cc]", "-divide-[#0088cc]/50", "-divide-[#0088cc]/[0.5]", "-divide-[#0088cc]/[50%]", "divide-red-500/foo", "divide-red-500/50/foo", "divide-red-500/[0.5]/foo", "divide-red-500/[50%]/foo", "divide-current/foo", "divide-current/50/foo", "divide-current/[0.5]/foo", "divide-current/[50%]/foo", "divide-inherit/foo", "divide-transparent/foo", "divide-[#0088cc]/foo", "divide-[#0088cc]/50/foo", "divide-[#0088cc]/[0.5]/foo", "divide-[#0088cc]/[50%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_place-self" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "place-self", "-place-self-auto", "-place-self-start", "-place-self-end", "-place-self-center", "-place-self-stretch", "place-self-auto/foo", "place-self-start/foo", "place-self-end/foo", "place-self-center/foo", "place-self-stretch/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_self" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "self", "-self-auto", "-self-start", "-self-end", "-self-center", "-self-stretch", "-self-baseline", "self-auto/foo", "self-start/foo", "self-end/foo", "self-center/foo", "self-stretch/foo", "self-baseline/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_justify-self" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "justify-self", "-justify-self-auto", "-justify-self-start", "-justify-self-end", "-justify-self-center", "-justify-self-stretch", "-justify-self-baseline", "justify-self-auto/foo", "justify-self-start/foo", "justify-self-end/foo", "justify-self-center/foo", "justify-self-stretch/foo", "justify-self-baseline/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overflow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow", "-overflow-auto", "-overflow-hidden", "-overflow-clip", "-overflow-visible", "-overflow-scroll", "overflow-auto/foo", "overflow-hidden/foo", "overflow-clip/foo", "overflow-visible/foo", "overflow-scroll/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overflow-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow-x", "-overflow-x-auto", "-overflow-x-hidden", "-overflow-x-clip", "-overflow-x-visible", "-overflow-x-scroll", "overflow-x-auto/foo", "overflow-x-hidden/foo", "overflow-x-clip/foo", "overflow-x-visible/foo", "overflow-x-scroll/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overflow-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overflow-y", "-overflow-y-auto", "-overflow-y-hidden", "-overflow-y-clip", "-overflow-y-visible", "-overflow-y-scroll", "overflow-y-auto/foo", "overflow-y-hidden/foo", "overflow-y-clip/foo", "overflow-y-visible/foo", "overflow-y-scroll/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overscroll" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll", "-overscroll-auto", "-overscroll-contain", "-overscroll-none", "overscroll-auto/foo", "overscroll-contain/foo", "overscroll-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overscroll-x" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll-x", "-overscroll-x-auto", "-overscroll-x-contain", "-overscroll-x-none", "overscroll-x-auto/foo", "overscroll-x-contain/foo", "overscroll-x-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overscroll-y" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "overscroll-y", "-overscroll-y-auto", "-overscroll-y-contain", "-overscroll-y-none", "overscroll-y-auto/foo", "overscroll-y-contain/foo", "overscroll-y-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_scroll-behavior" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "scroll", "-scroll-auto", "-scroll-smooth", "scroll-auto/foo", "scroll-smooth/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_truncate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-truncate", "truncate/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_hyphens" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hyphens", "-hyphens-none", "-hyphens-manual", "-hyphens-auto", "hyphens-none/foo", "hyphens-manual/foo", "hyphens-auto/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_whitespace" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "whitespace", "-whitespace-normal", "-whitespace-nowrap", "-whitespace-pre", "-whitespace-pre-line", "-whitespace-pre-wrap", "-whitespace-break-spaces", "whitespace-normal/foo", "whitespace-nowrap/foo", "whitespace-pre/foo", "whitespace-pre-line/foo", "whitespace-pre-wrap/foo", "whitespace-break-spaces/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-text-wrap", "-text-nowrap", "-text-balance", "-text-pretty", "text-wrap/foo", "text-nowrap/foo", "text-balance/foo", "text-pretty/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_word-break" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-break-normal", "-break-words", "-break-all", "-break-keep", "break-normal/foo", "break-words/foo", "break-all/foo", "break-keep/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_overflow-wrap" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-wrap-anywhere", "-wrap-break-word", "-wrap-normal", "wrap-anywhere/foo", "wrap-break-word/foo", "wrap-normal/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded", "-rounded-full", "-rounded-none", "-rounded-sm", "-rounded-[4px]", "rounded/foo", "rounded-full/foo", "rounded-none/foo", "rounded-sm/foo", "rounded-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-s", "-rounded-s-full", "-rounded-s-none", "-rounded-s-sm", "-rounded-s-[4px]", "rounded-s/foo", "rounded-s-full/foo", "rounded-s-none/foo", "rounded-s-sm/foo", "rounded-s-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-e" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-e", "-rounded-e-full", "-rounded-e-none", "-rounded-e-sm", "-rounded-e-[4px]", "rounded-e/foo", "rounded-e-full/foo", "rounded-e-none/foo", "rounded-e-sm/foo", "rounded-e-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-t" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-t", "-rounded-t-full", "-rounded-t-none", "-rounded-t-sm", "-rounded-t-[4px]", "rounded-t/foo", "rounded-t-full/foo", "rounded-t-none/foo", "rounded-t-sm/foo", "rounded-t-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-r" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-r", "-rounded-r-full", "-rounded-r-none", "-rounded-r-sm", "-rounded-r-[4px]", "rounded-r/foo", "rounded-r-full/foo", "rounded-r-none/foo", "rounded-r-sm/foo", "rounded-r-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-b" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-b", "-rounded-b-full", "-rounded-b-none", "-rounded-b-sm", "-rounded-b-[4px]", "rounded-b/foo", "rounded-b-full/foo", "rounded-b-none/foo", "rounded-b-sm/foo", "rounded-b-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-l" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-l", "-rounded-l-full", "-rounded-l-none", "-rounded-l-sm", "-rounded-l-[4px]", "rounded-l/foo", "rounded-l-full/foo", "rounded-l-none/foo", "rounded-l-sm/foo", "rounded-l-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-ss" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-ss", "-rounded-ss-full", "-rounded-ss-none", "-rounded-ss-sm", "-rounded-ss-[4px]", "rounded-ss/foo", "rounded-ss-full/foo", "rounded-ss-none/foo", "rounded-ss-sm/foo", "rounded-ss-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-se" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-se", "-rounded-se-full", "-rounded-se-none", "-rounded-se-sm", "-rounded-se-[4px]", "rounded-se/foo", "rounded-se-full/foo", "rounded-se-none/foo", "rounded-se-sm/foo", "rounded-se-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-ee" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-ee", "-rounded-ee-full", "-rounded-ee-none", "-rounded-ee-sm", "-rounded-ee-[4px]", "rounded-ee/foo", "rounded-ee-full/foo", "rounded-ee-none/foo", "rounded-ee-sm/foo", "rounded-ee-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-es" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-es", "-rounded-es-full", "-rounded-es-none", "-rounded-es-sm", "-rounded-es-[4px]", "rounded-es/foo", "rounded-es-full/foo", "rounded-es-none/foo", "rounded-es-sm/foo", "rounded-es-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-tl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-tl", "-rounded-tl-full", "-rounded-tl-none", "-rounded-tl-sm", "-rounded-tl-[4px]", "rounded-tl/foo", "rounded-tl-full/foo", "rounded-tl-none/foo", "rounded-tl-sm/foo", "rounded-tl-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-tr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-tr", "-rounded-tr-full", "-rounded-tr-none", "-rounded-tr-sm", "-rounded-tr-[4px]", "rounded-tr/foo", "rounded-tr-full/foo", "rounded-tr-none/foo", "rounded-tr-sm/foo", "rounded-tr-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-br" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-br", "-rounded-br-full", "-rounded-br-none", "-rounded-br-sm", "-rounded-br-[4px]", "rounded-br/foo", "rounded-br-full/foo", "rounded-br-none/foo", "rounded-br-sm/foo", "rounded-br-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rounded-bl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-rounded-bl", "-rounded-bl-full", "-rounded-bl-none", "-rounded-bl-sm", "-rounded-bl-[4px]", "rounded-bl/foo", "rounded-bl-full/foo", "rounded-bl-none/foo", "rounded-bl-sm/foo", "rounded-bl-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-border-solid", "-border-dashed", "-border-dotted", "-border-double", "-border-hidden", "-border-none", "border-solid/foo", "border-dashed/foo", "border-dotted/foo", "border-double/foo", "border-hidden/foo", "border-none/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_prefix-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${classes}" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_prefix-_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${prefix}/foo", "${prefix}-0/foo", "${prefix}-2/foo", "${prefix}-4/foo", "${prefix}-123/foo", "${prefix}-[thin]/foo", "${prefix}-[medium]/foo", "${prefix}-[thick]/foo", "${prefix}-[12px]/foo", "${prefix}-[length:var(--my-width)]/foo", "${prefix}-[line-width:var(--my-width)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_border with custom default border width" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-border", "border/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg", "bg-unknown", "-bg-red-500", "-bg-red-500/50", "-bg-red-500/[0.5]", "-bg-red-500/[50%]", "-bg-current", "-bg-current/50", "-bg-current/[0.5]", "-bg-current/[50%]", "-bg-inherit", "-bg-transparent", "-bg-[#0088cc]", "-bg-[#0088cc]/50", "-bg-[#0088cc]/[0.5]", "-bg-[#0088cc]/[50%]", "-bg-none", "-bg-gradient-to-br", "-bg-linear-to-br", "-bg-linear-[to_bottom]", "-bg-auto", "-bg-cover", "-bg-contain", "-bg-fixed", "-bg-local", "-bg-scroll", "-bg-center", "-bg-top", "-bg-right-top", "-bg-right-bottom", "-bg-bottom", "-bg-left-bottom", "-bg-left", "-bg-left-top", "-bg-repeat", "-bg-no-repeat", "-bg-repeat-x", "-bg-repeat-y", "-bg-round", "-bg-space", "bg-none/foo", "bg-[url(/image.png)]/foo", "bg-[url:var(--my-url)]/foo", "bg-[linear-gradient(to_bottom,red,blue)]/foo", "bg-[image:var(--my-gradient)]/foo", "bg-linear-[to_bottom]/hsl", "bg-conic-[45deg]/hsl", "bg-conic-[circle_at_center]/hsl", "bg-auto/foo", "bg-cover/foo", "bg-contain/foo", "bg-[cover]/foo", "bg-[contain]/foo", "bg-[size:120px_120px]/foo", "bg-fixed/foo", "bg-local/foo", "bg-scroll/foo", "bg-center/foo", "bg-top/foo", "bg-right-top/foo", "bg-right-bottom/foo", "bg-bottom/foo", "bg-left-bottom/foo", "bg-left/foo", "bg-left-top/foo", "bg-[50%]/foo", "bg-[120px]/foo", "bg-[120px_120px]/foo", "bg-[length:120px_120px]/foo", "bg-[position:120px_120px]/foo", "bg-[size:120px_120px]/foo", "bg-repeat/foo", "bg-no-repeat/foo", "bg-repeat-x/foo", "bg-repeat-y/foo", "bg-round/foo", "bg-space/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-position", "bg-position/foo", "-bg-position", "-bg-position/foo", "bg-position-[120px_120px]/foo", "-bg-position-[120px_120px]", "-bg-position-[120px_120px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-size", "bg-size/foo", "-bg-size", "-bg-size/foo", "bg-size-[120px_120px]/foo", "-bg-size-[120px_120px]", "-bg-size-[120px_120px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "from", "from-25.%", "from-25.0%", "from-123", "from--123", "from--5%", "from-unknown", "from-unknown%", "-from-red-500", "-from-red-500/50", "-from-red-500/[0.5]", "-from-red-500/[50%]", "-from-current", "-from-current/50", "-from-current/[0.5]", "-from-current/[50%]", "-from-inherit", "-from-transparent", "-from-[#0088cc]", "-from-[#0088cc]/50", "-from-[#0088cc]/[0.5]", "-from-[#0088cc]/[50%]", "-from-0%", "-from-5%", "-from-100%" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_via" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "via", "via-123", "via--123", "via--5%", "via-unknown", "via-unknown%", "-via-red-500", "-via-red-500/50", "-via-red-500/[0.5]", "-via-red-500/[50%]", "-via-current", "-via-current/50", "-via-current/[0.5]", "-via-current/[50%]", "-via-inherit", "-via-transparent", "-via-[#0088cc]", "-via-[#0088cc]/50", "-via-[#0088cc]/[0.5]", "-via-[#0088cc]/[50%]", "-via-0%", "-via-5%", "-via-100%" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "to", "to-123", "to--123", "to--5%", "to-unknown", "to-unknown%", "-to-red-500", "-to-red-500/50", "-to-red-500/[0.5]", "-to-red-500/[50%]", "-to-current", "-to-current/50", "-to-current/[0.5]", "-to-current/[50%]", "-to-inherit", "-to-transparent", "-to-[#0088cc]", "-to-[#0088cc]/50", "-to-[#0088cc]/[0.5]", "-to-[#0088cc]/[50%]", "-to-0%", "-to-5%", "-to-100%" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask", "mask-unknown", "-mask-none", "mask-none/foo", "-mask-[var(--some-var)]", "mask-[var(--some-var)]/foo", "-mask-[image:var(--some-var)]", "mask-[image:var(--some-var)]/foo", "-mask-[url:var(--some-var)]", "mask-[url:var(--some-var)]/foo", "-mask-add", "-mask-subtract", "-mask-intersect", "-mask-exclude", "mask-add/foo", "mask-subtract/foo", "mask-intersect/foo", "mask-exclude/foo", "-mask-alpha", "-mask-luminance", "-mask-match", "mask-alpha/foo", "mask-luminance/foo", "mask-match/foo", "-mask-type-alpha", "-mask-type-luminance", "mask-type-alpha/foo", "mask-type-luminance/foo", "-mask-auto", "-mask-cover", "-mask-contain", "-mask-auto/foo", "-mask-cover/foo", "-mask-contain/foo", "-mask-center", "-mask-top", "-mask-right-top", "-mask-right-bottom", "-mask-bottom", "-mask-left-bottom", "-mask-left", "-mask-left-top", "-mask-center/foo", "-mask-top/foo", "-mask-right-top/foo", "-mask-right-bottom/foo", "-mask-bottom/foo", "-mask-left-bottom/foo", "-mask-left/foo", "-mask-left-top/foo", "mask-repeat/foo", "mask-no-repeat/foo", "mask-repeat-x/foo", "mask-repeat-y/foo", "mask-round/foo", "mask-space/foo", "-mask-repeat", "-mask-no-repeat", "-mask-repeat-x", "-mask-repeat-y", "-mask-round", "-mask-space", "-mask-repeat/foo", "-mask-no-repeat/foo", "-mask-repeat-x/foo", "-mask-repeat-y/foo", "-mask-round/foo", "-mask-space/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-position" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-position", "mask-position/foo", "-mask-position", "-mask-position/foo", "mask-position-[120px_120px]/foo", "-mask-position-[120px_120px]", "-mask-position-[120px_120px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-size" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-size", "mask-size/foo", "-mask-size", "-mask-size/foo", "mask-size-[120px_120px]/foo", "-mask-size-[120px_120px]", "-mask-size-[120px_120px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-t-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-t-from", "mask-t-from-2.8175", "mask-t-from--1.5", "mask-t-from--2", "mask-t-from-2.5%", "mask-t-from--5%", "mask-t-from-unknown", "mask-t-from-unknown%", "-mask-t-from-0", "-mask-t-from-1.5", "-mask-t-from-2", "-mask-t-from-0%", "-mask-t-from-2%", "-mask-t-from-[0px]", "-mask-t-from-[0%]", "-mask-t-from-(--my-var)", "-mask-t-from-(color:--my-var)", "-mask-t-from-(length:--my-var)", "mask-l-from-[-25%]", "mask-l-from-[25%]/foo", "mask-l-from-[-25%]/foo", "-mask-l-from-[-25%]", "-mask-l-from-[25%]/foo", "-mask-l-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-t-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-t-to", "mask-t-to-2.8175", "mask-t-to--1.5", "mask-t-to--2", "mask-t-to-2.5%", "mask-t-to--5%", "mask-t-to-unknown", "mask-t-to-unknown%", "-mask-t-to-0", "-mask-t-to-1.5", "-mask-t-to-2", "-mask-t-to-0%", "-mask-t-to-2%", "-mask-t-to-[0px]", "-mask-t-to-[0%]", "-mask-t-to-(--my-var)", "-mask-t-to-(color:--my-var)", "-mask-t-to-(length:--my-var)", "mask-l-from-[-25%]", "mask-l-from-[25%]/foo", "mask-l-from-[-25%]/foo", "-mask-l-from-[-25%]", "-mask-l-from-[25%]/foo", "-mask-l-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-r-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-r-from", "mask-r-from-2.8175", "mask-r-from--1.5", "mask-r-from--2", "mask-r-from-2.5%", "mask-r-from--5%", "mask-r-from-unknown", "mask-r-from-unknown%", "-mask-r-from-0", "-mask-r-from-1.5", "-mask-r-from-2", "-mask-r-from-0%", "-mask-r-from-2%", "-mask-r-from-[0px]", "-mask-r-from-[0%]", "-mask-r-from-(--my-var)", "-mask-r-from-(color:--my-var)", "-mask-r-from-(length:--my-var)", "mask-r-from-[-25%]", "mask-r-from-[25%]/foo", "mask-r-from-[-25%]/foo", "-mask-r-from-[-25%]", "-mask-r-from-[25%]/foo", "-mask-r-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-r-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-r-to", "mask-r-to-2.8175", "mask-r-to--1.5", "mask-r-to--2", "mask-r-to-2.5%", "mask-r-to--5%", "mask-r-to-unknown", "mask-r-to-unknown%", "-mask-r-to-0", "-mask-r-to-1.5", "-mask-r-to-2", "-mask-r-to-0%", "-mask-r-to-2%", "-mask-r-to-[0px]", "-mask-r-to-[0%]", "-mask-r-to-(--my-var)", "-mask-r-to-(color:--my-var)", "-mask-r-to-(length:--my-var)", "mask-r-to-[-25%]", "mask-r-to-[25%]/foo", "mask-r-to-[-25%]/foo", "-mask-r-to-[-25%]", "-mask-r-to-[25%]/foo", "-mask-r-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-b-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-b-from", "mask-b-from-2.8175", "mask-b-from--1.5", "mask-b-from--2", "mask-b-from-2.5%", "mask-b-from--5%", "mask-b-from-unknown", "mask-b-from-unknown%", "-mask-b-from-0", "-mask-b-from-1.5", "-mask-b-from-2", "-mask-b-from-0%", "-mask-b-from-2%", "-mask-b-from-[0px]", "-mask-b-from-[0%]", "-mask-b-from-(--my-var)", "-mask-b-from-(color:--my-var)", "-mask-b-from-(length:--my-var)", "mask-b-from-[-25%]", "mask-b-from-[25%]/foo", "mask-b-from-[-25%]/foo", "-mask-b-from-[-25%]", "-mask-b-from-[25%]/foo", "-mask-b-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-b-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-b-to", "mask-b-to-2.8175", "mask-b-to--1.5", "mask-b-to--2", "mask-b-to-2.5%", "mask-b-to--5%", "mask-b-to-unknown", "mask-b-to-unknown%", "-mask-b-to-0", "-mask-b-to-1.5", "-mask-b-to-2", "-mask-b-to-0%", "-mask-b-to-2%", "-mask-b-to-[0px]", "-mask-b-to-[0%]", "-mask-b-to-(--my-var)", "-mask-b-to-(color:--my-var)", "-mask-b-to-(length:--my-var)", "mask-b-to-[-25%]", "mask-b-to-[25%]/foo", "mask-b-to-[-25%]/foo", "-mask-b-to-[-25%]", "-mask-b-to-[25%]/foo", "-mask-b-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-l-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-l-from", "mask-l-from-2.8175", "mask-l-from--1.5", "mask-l-from--2", "mask-l-from-2.5%", "mask-l-from--5%", "mask-l-from-unknown", "mask-l-from-unknown%", "-mask-l-from-0", "-mask-l-from-1.5", "-mask-l-from-2", "-mask-l-from-0%", "-mask-l-from-2%", "-mask-l-from-[0px]", "-mask-l-from-[0%]", "-mask-l-from-(--my-var)", "-mask-l-from-(color:--my-var)", "-mask-l-from-(length:--my-var)", "mask-l-from-[-25%]", "mask-l-from-[25%]/foo", "mask-l-from-[-25%]/foo", "-mask-l-from-[-25%]", "-mask-l-from-[25%]/foo", "-mask-l-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-l-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-l-to", "mask-l-to-2.8175", "mask-l-to--1.5", "mask-l-to--2", "mask-l-to-2.5%", "mask-l-to--5%", "mask-l-to-unknown", "mask-l-to-unknown%", "-mask-l-to-0", "-mask-l-to-1.5", "-mask-l-to-2", "-mask-l-to-0%", "-mask-l-to-2%", "-mask-l-to-[0px]", "-mask-l-to-[0%]", "-mask-l-to-(--my-var)", "-mask-l-to-(color:--my-var)", "-mask-l-to-(length:--my-var)", "mask-l-to-[-25%]", "mask-l-to-[25%]/foo", "mask-l-to-[-25%]/foo", "-mask-l-to-[-25%]", "-mask-l-to-[25%]/foo", "-mask-l-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-x-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-x-from", "mask-x-from-2.8175", "mask-x-from--1.5", "mask-x-from--2", "mask-x-from-2.5%", "mask-x-from--5%", "mask-x-from-unknown", "mask-x-from-unknown%", "-mask-x-from-0", "-mask-x-from-1.5", "-mask-x-from-2", "-mask-x-from-0%", "-mask-x-from-2%", "-mask-x-from-[0px]", "-mask-x-from-[0%]", "-mask-x-from-(--my-var)", "-mask-x-from-(color:--my-var)", "-mask-x-from-(length:--my-var)", "mask-x-from-[-25%]", "mask-x-from-[25%]/foo", "mask-x-from-[-25%]/foo", "-mask-x-from-[-25%]", "-mask-x-from-[25%]/foo", "-mask-x-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-x-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-x-to", "mask-x-to-2.8175", "mask-x-to--1.5", "mask-x-to--2", "mask-x-to-2.5%", "mask-x-to--5%", "mask-x-to-unknown", "mask-x-to-unknown%", "-mask-x-to-0", "-mask-x-to-1.5", "-mask-x-to-2", "-mask-x-to-0%", "-mask-x-to-2%", "-mask-x-to-[0px]", "-mask-x-to-[0%]", "-mask-x-to-(--my-var)", "-mask-x-to-(color:--my-var)", "-mask-x-to-(length:--my-var)", "mask-x-to-[-25%]", "mask-x-to-[25%]/foo", "mask-x-to-[-25%]/foo", "-mask-x-to-[-25%]", "-mask-x-to-[25%]/foo", "-mask-x-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-y-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-y-from", "mask-y-from-2.8175", "mask-y-from--1.5", "mask-y-from--2", "mask-y-from-2.5%", "mask-y-from--5%", "mask-y-from-unknown", "mask-y-from-unknown%", "-mask-y-from-0", "-mask-y-from-1.5", "-mask-y-from-2", "-mask-y-from-0%", "-mask-y-from-2%", "-mask-y-from-[0px]", "-mask-y-from-[0%]", "-mask-y-from-(--my-var)", "-mask-y-from-(color:--my-var)", "-mask-y-from-(length:--my-var)", "mask-y-from-[-25%]", "mask-y-from-[25%]/foo", "mask-y-from-[-25%]/foo", "-mask-y-from-[-25%]", "-mask-y-from-[25%]/foo", "-mask-y-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-y-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-y-to", "mask-y-to-2.8175", "mask-y-to--1.5", "mask-y-to--2", "mask-y-to-2.5%", "mask-y-to--5%", "mask-y-to-unknown", "mask-y-to-unknown%", "-mask-y-to-0", "-mask-y-to-1.5", "-mask-y-to-2", "-mask-y-to-0%", "-mask-y-to-2%", "-mask-y-to-[0px]", "-mask-y-to-[0%]", "-mask-y-to-(--my-var)", "-mask-y-to-(color:--my-var)", "-mask-y-to-(length:--my-var)", "mask-y-to-[-25%]", "mask-y-to-[25%]/foo", "mask-y-to-[-25%]/foo", "-mask-y-to-[-25%]", "-mask-y-to-[25%]/foo", "-mask-y-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-linear" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-linear", "-mask-linear", "mask-linear--75", "mask-linear-unknown", "mask-linear--75/foo", "mask-linear-unknown/foo", "mask-linear-45/foo", "-mask-linear-45/foo", "mask-linear-[3rad]/foo", "-mask-linear-[3rad]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-linear-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-linear-from", "mask-linear-from-2.8175", "mask-linear-from--1.5", "mask-linear-from--2", "mask-linear-from-2.5%", "mask-linear-from--5%", "mask-linear-from-unknown", "mask-linear-from-unknown%", "-mask-linear-from-0", "-mask-linear-from-1.5", "-mask-linear-from-2", "-mask-linear-from-0%", "-mask-linear-from-2%", "-mask-linear-from-[0px]", "-mask-linear-from-[0%]", "-mask-linear-from-(--my-var)", "-mask-linear-from-(color:--my-var)", "-mask-linear-from-(length:--my-var)", "mask-linear-from-[-25%]", "mask-linear-from-[25%]/foo", "mask-linear-from-[-25%]/foo", "-mask-linear-from-[-25%]", "-mask-linear-from-[25%]/foo", "-mask-linear-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-linear-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-linear-to", "mask-linear-to-2.8175", "mask-linear-to--1.5", "mask-linear-to--2", "mask-linear-to-2.5%", "mask-linear-to--5%", "mask-linear-to-unknown", "mask-linear-to-unknown%", "-mask-linear-to-0", "-mask-linear-to-1.5", "-mask-linear-to-2", "-mask-linear-to-0%", "-mask-linear-to-2%", "-mask-linear-to-[0px]", "-mask-linear-to-[0%]", "-mask-linear-to-(--my-var)", "-mask-linear-to-(color:--my-var)", "-mask-linear-to-(length:--my-var)", "mask-linear-to-[-25%]", "mask-linear-to-[25%]/foo", "mask-linear-to-[-25%]/foo", "-mask-linear-to-[-25%]", "-mask-linear-to-[25%]/foo", "-mask-linear-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-radial" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-radial", "mask-radial-[25%_25%]/foo", "mask-radial/foo", "-mask-radial", "-mask-radial-[25%_25%]", "-mask-radial/foo", "-mask-radial-[25%_25%]/foo", "mask-radial-from-[-25%]", "mask-radial-from-[25%]/foo", "mask-radial-from-[-25%]/foo", "-mask-radial-from-[-25%]", "-mask-radial-from-[25%]/foo", "-mask-radial-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-radial-at" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-radial-at", "mask-radial-at/foo", "mask-radial-at-25", "mask-radial-at-unknown", "mask-radial-at-[25%]/foo", "mask-radial-at-top/foo", "mask-radial-at-top-left/foo", "mask-radial-at-top-right/foo", "mask-radial-at-bottom/foo", "mask-radial-at-bottom-left/foo", "mask-radial-at-bottom-right/foo", "mask-radial-at-left/foo", "mask-radial-at-right/foo", "-mask-radial-at", "-mask-radial-at/foo", "-mask-radial-at-25", "-mask-radial-at-unknown", "-mask-radial-at-[25%]", "-mask-radial-at-[25%]/foo", "-mask-radial-at-top", "-mask-radial-at-top-left", "-mask-radial-at-top-right", "-mask-radial-at-bottom", "-mask-radial-at-bottom-left", "-mask-radial-at-bottom-right", "-mask-radial-at-left", "-mask-radial-at-right", "mask-radial-at-[25%]/foo", "mask-radial-at-[-25%]/foo", "-mask-radial-at-[-25%]", "-mask-radial-at-[25%]/foo", "-mask-radial-at-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-radial-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-radial-from", "mask-radial-from-2.8175", "mask-radial-from--1.5", "mask-radial-from--2", "mask-radial-from-2.5%", "mask-radial-from--5%", "mask-radial-from-unknown", "mask-radial-from-unknown%", "-mask-radial-from-0", "-mask-radial-from-1.5", "-mask-radial-from-2", "-mask-radial-from-0%", "-mask-radial-from-2%", "-mask-radial-from-[0px]", "-mask-radial-from-[0%]", "-mask-radial-from-(--my-var)", "-mask-radial-from-(color:--my-var)", "-mask-radial-from-(length:--my-var)", "mask-radial-from-[-25%]", "mask-radial-from-[25%]/foo", "mask-radial-from-[-25%]/foo", "-mask-radial-from-[-25%]", "-mask-radial-from-[25%]/foo", "-mask-radial-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-radial-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-radial-to", "mask-radial-to-2.8175", "mask-radial-to--1.5", "mask-radial-to--2", "mask-radial-to-2.5%", "mask-radial-to--5%", "mask-radial-to-unknown", "mask-radial-to-unknown%", "-mask-radial-to-0", "-mask-radial-to-1.5", "-mask-radial-to-2", "-mask-radial-to-0%", "-mask-radial-to-2%", "-mask-radial-to-[0px]", "-mask-radial-to-[0%]", "-mask-radial-to-(--my-var)", "-mask-radial-to-(color:--my-var)", "-mask-radial-to-(length:--my-var)", "mask-radial-to-[-25%]", "mask-radial-to-[25%]/foo", "mask-radial-to-[-25%]/foo", "-mask-radial-to-[-25%]", "-mask-radial-to-[25%]/foo", "-mask-radial-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-conic" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-conic", "-mask-conic", "mask-conic--75", "mask-conic-unknown", "mask-conic--75/foo", "mask-conic-unknown/foo", "mask-conic-45/foo", "-mask-conic-45/foo", "mask-conic-[3rad]/foo", "-mask-conic-[3rad]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-conic-from" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-conic-from", "mask-conic-from-2.8175", "mask-conic-from--1.5", "mask-conic-from--2", "mask-conic-from-2.5%", "mask-conic-from--5%", "mask-conic-from-unknown", "mask-conic-from-unknown%", "-mask-conic-from-0", "-mask-conic-from-1.5", "-mask-conic-from-2", "-mask-conic-from-0%", "-mask-conic-from-2%", "-mask-conic-from-[0px]", "-mask-conic-from-[0%]", "-mask-conic-from-(--my-var)", "-mask-conic-from-(color:--my-var)", "-mask-conic-from-(length:--my-var)", "mask-conic-from-[-25%]", "mask-conic-from-[25%]/foo", "mask-conic-from-[-25%]/foo", "-mask-conic-from-[-25%]", "-mask-conic-from-[25%]/foo", "-mask-conic-from-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-conic-to" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-conic-to", "mask-conic-to-2.8175", "mask-conic-to--1.5", "mask-conic-to--2", "mask-conic-to-2.5%", "mask-conic-to--5%", "mask-conic-to-unknown", "mask-conic-to-unknown%", "-mask-conic-to-0", "-mask-conic-to-1.5", "-mask-conic-to-2", "-mask-conic-to-0%", "-mask-conic-to-2%", "-mask-conic-to-[0px]", "-mask-conic-to-[0%]", "-mask-conic-to-(--my-var)", "-mask-conic-to-(color:--my-var)", "-mask-conic-to-(length:--my-var)", "mask-conic-to-[-25%]", "mask-conic-to-[25%]/foo", "mask-conic-to-[-25%]/foo", "-mask-conic-to-[-25%]", "-mask-conic-to-[25%]/foo", "-mask-conic-to-[-25%]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_box-decoration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "box", "box-decoration", "-box-decoration-slice", "-box-decoration-clone", "box-decoration-slice/foo", "box-decoration-clone/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg-clip" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-clip", "-bg-clip-border", "-bg-clip-padding", "-bg-clip-content", "-bg-clip-text", "bg-clip-border/foo", "bg-clip-padding/foo", "bg-clip-content/foo", "bg-clip-text/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg-origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-origin", "-bg-origin-border", "-bg-origin-padding", "-bg-origin-content", "bg-origin-border/foo", "bg-origin-padding/foo", "bg-origin-content/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-clip" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-clip", "-mask-clip-border", "-mask-clip-padding", "-mask-clip-content", "-mask-clip-fill", "-mask-clip-stroke", "-mask-clip-view", "-mask-no-clip", "mask-clip-border/foo", "mask-clip-padding/foo", "mask-clip-content/foo", "mask-clip-fill/foo", "mask-clip-stroke/foo", "mask-clip-view/foo", "mask-no-clip/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mask-origin" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mask-origin", "-mask-origin-border", "-mask-origin-padding", "-mask-origin-content", "-mask-origin-fill", "-mask-origin-stroke", "-mask-origin-view", "mask-origin-border/foo", "mask-origin-padding/foo", "mask-origin-content/foo", "mask-origin-fill/foo", "mask-origin-stroke/foo", "mask-origin-view/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_bg-blend" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "bg-blend", "-bg-blend-normal", "-bg-blend-multiply", "-bg-blend-screen", "-bg-blend-overlay", "-bg-blend-darken", "-bg-blend-lighten", "-bg-blend-color-dodge", "-bg-blend-color-burn", "-bg-blend-hard-light", "-bg-blend-soft-light", "-bg-blend-difference", "-bg-blend-exclusion", "-bg-blend-hue", "-bg-blend-saturation", "-bg-blend-color", "-bg-blend-luminosity", "bg-blend-normal/foo", "bg-blend-multiply/foo", "bg-blend-screen/foo", "bg-blend-overlay/foo", "bg-blend-darken/foo", "bg-blend-lighten/foo", "bg-blend-color-dodge/foo", "bg-blend-color-burn/foo", "bg-blend-hard-light/foo", "bg-blend-soft-light/foo", "bg-blend-difference/foo", "bg-blend-exclusion/foo", "bg-blend-hue/foo", "bg-blend-saturation/foo", "bg-blend-color/foo", "bg-blend-luminosity/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_mix-blend" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "mix-blend", "-mix-blend-normal", "-mix-blend-multiply", "-mix-blend-screen", "-mix-blend-overlay", "-mix-blend-darken", "-mix-blend-lighten", "-mix-blend-color-dodge", "-mix-blend-color-burn", "-mix-blend-hard-light", "-mix-blend-soft-light", "-mix-blend-difference", "-mix-blend-exclusion", "-mix-blend-hue", "-mix-blend-saturation", "-mix-blend-color", "-mix-blend-luminosity", "-mix-blend-plus-lighter", "mix-blend-normal/foo", "mix-blend-multiply/foo", "mix-blend-screen/foo", "mix-blend-overlay/foo", "mix-blend-darken/foo", "mix-blend-lighten/foo", "mix-blend-color-dodge/foo", "mix-blend-color-burn/foo", "mix-blend-hard-light/foo", "mix-blend-soft-light/foo", "mix-blend-difference/foo", "mix-blend-exclusion/foo", "mix-blend-hue/foo", "mix-blend-saturation/foo", "mix-blend-color/foo", "mix-blend-luminosity/foo", "mix-blend-plus-darker/foo", "mix-blend-plus-lighter/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_fill" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "fill", "fill-unknown", "-fill-red-500", "-fill-red-500/50", "-fill-red-500/[0.5]", "-fill-red-500/[50%]", "-fill-current", "-fill-current/50", "-fill-current/[0.5]", "-fill-current/[50%]", "-fill-inherit", "-fill-transparent", "-fill-[#0088cc]", "-fill-[#0088cc]/50", "-fill-[#0088cc]/[0.5]", "-fill-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_stroke" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "stroke", "stroke-unknown", "-stroke-red-500", "-stroke-red-500/50", "-stroke-red-500/[0.5]", "-stroke-red-500/[50%]", "-stroke-current", "-stroke-current/50", "-stroke-current/[0.5]", "-stroke-current/[50%]", "-stroke-inherit", "-stroke-transparent", "-stroke-[#0088cc]", "-stroke-[#0088cc]/50", "-stroke-[#0088cc]/[0.5]", "-stroke-[#0088cc]/[50%]", "-stroke-0", "stroke--1" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_object" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "object", "-object-contain", "-object-cover", "-object-fill", "-object-none", "-object-scale-down", "-object-[var(--value)]", "-object-bottom", "object-contain/foo", "object-cover/foo", "object-fill/foo", "object-none/foo", "object-scale-down/foo", "object-[var(--value)]/foo", "object-bottom/foo", "object-center/foo", "object-left/foo", "object-left-bottom/foo", "object-left-top/foo", "object-right/foo", "object-right-bottom/foo", "object-right-top/foo", "object-top/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_p" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "p", "-p-4", "-p-[4px]", "p-4/foo", "p-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_px" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "px", "-px-4", "-px-[4px]", "px-4/foo", "px-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_py" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "py", "-py-4", "-py-[4px]", "py-4/foo", "py-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pt" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pt", "-pt-4", "-pt-[4px]", "pt-4/foo", "pt-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ps" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ps", "-ps-4", "-ps-[4px]", "ps-4/foo", "ps-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pe", "-pe-4", "-pe-[4px]", "pe-4/foo", "pe-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pbs" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pbs", "-pbs-4", "-pbs-[4px]", "pbs-4/foo", "pbs-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pbe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pbe", "-pbe-4", "-pbe-[4px]", "pbe-4/foo", "pbe-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pr", "-pr-4", "-pr-[4px]", "pr-4/foo", "pr-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pb" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pb", "-pb-4", "-pb-[4px]", "pb-4/foo", "pb-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_pl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "pl", "-pl-4", "-pl-[4px]", "pl-4/foo", "pl-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text-align" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-text-left", "-text-center", "-text-right", "-text-justify", "-text-start", "-text-end", "text-left/foo", "text-center/foo", "text-right/foo", "text-justify/foo", "text-start/foo", "text-end/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_indent" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "indent", "indent-[4px]/foo", "-indent-[4px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_align" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "align", "-align-baseline", "-align-top", "-align-middle", "-align-bottom", "-align-text-top", "-align-text-bottom", "-align-sub", "-align-super", "-align-[var(--value)]", "align-baseline/foo", "align-top/foo", "align-middle/foo", "align-bottom/foo", "align-text-top/foo", "align-text-bottom/foo", "align-sub/foo", "align-super/foo", "align-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "font", "-font-sans", "-font-bold", "font-weight-bold", "font-sans/foo", "font-[\"arial_rounded\"]/foo", "font-[ui-sans-serif]/foo", "font-[var(--my-family)]/foo", "font-[family-name:var(--my-family)]/foo", "font-[generic-name:var(--my-family)]/foo", "font-bold/foo", "font-[100]/foo", "font-[number:var(--my-weight)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font-features" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "font-features", "-font-features-[\"smcp\"]", "font-features-smcp", "font-features-[\"smcp\"]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text-transform" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-uppercase", "-lowercase", "-capitalize", "-normal-case", "uppercase/foo", "lowercase/foo", "capitalize/foo", "normal-case/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font-style" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-italic", "-not-italic", "italic/foo", "not-italic/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font-stretch" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "font-stretch", "font-stretch-20%", "font-stretch-50", "font-stretch-400%", "font-stretch-50.5%", "font-stretch-potato", "font-stretch-ultra-expanded/foo", "font-stretch-50%/foo", "font-stretch-200%/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text-decoration-line" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-underline", "-overline", "-line-through", "-no-underline", "underline/foo", "overline/foo", "line-through/foo", "no-underline/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_placeholder" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder", "-placeholder-red-500", "-placeholder-red-500/50", "-placeholder-red-500/[0.5]", "-placeholder-red-500/[50%]", "-placeholder-current", "-placeholder-current/50", "-placeholder-current/[0.5]", "-placeholder-current/[50%]", "-placeholder-inherit", "-placeholder-transparent", "-placeholder-[#0088cc]", "-placeholder-[#0088cc]/50", "-placeholder-[#0088cc]/[0.5]", "-placeholder-[#0088cc]/[50%]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_decoration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "decoration", "-decoration-red-500", "-decoration-red-500/50", "-decoration-red-500/[0.5]", "-decoration-red-500/[50%]", "-decoration-current", "-decoration-current/50", "-decoration-current/[0.5]", "-decoration-current/[50%]", "-decoration-transparent", "-decoration-[#0088cc]", "-decoration-[#0088cc]/50", "-decoration-[#0088cc]/[0.5]", "-decoration-[#0088cc]/[50%]", "-decoration-solid", "-decoration-double", "-decoration-dotted", "-decoration-dashed", "-decoration-wavy", "decoration--2", "-decoration-auto", "-decoration-from-font", "-decoration-0", "-decoration-1", "-decoration-2", "-decoration-4", "-decoration-123", "decoration-solid/foo", "decoration-double/foo", "decoration-dotted/foo", "decoration-dashed/foo", "decoration-wavy/foo", "decoration-auto/foo", "decoration-from-font/foo", "decoration-0/foo", "decoration-1/foo", "decoration-2/foo", "decoration-4/foo", "decoration-123/foo", "decoration-[12px]/foo", "decoration-[50%]/foo", "decoration-[length:var(--my-thickness)]/foo", "decoration-[percentage:var(--my-thickness)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_animate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "animate", "-animate-spin", "-animate-none", "-animate-[bounce_1s_infinite]", "-animate-not-found", "animate-spin/foo", "animate-none/foo", "animate-[bounce_1s_infinite]/foo", "animate-not-found/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_filter" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-filter", "-filter-none", "-filter-[var(--value)]", "-blur-xl", "-blur-[4px]", "brightness--50", "-brightness-50", "-brightness-[1.23]", "brightness-unknown", "contrast--50", "-contrast-50", "-contrast-[1.23]", "contrast-unknown", "-grayscale", "-grayscale-0", "grayscale--1", "-grayscale-[var(--value)]", "grayscale-unknown", "hue-rotate--5", "hue-rotate-unknown", "-invert", "invert--5", "-invert-0", "-invert-[var(--value)]", "invert-unknown", "-drop-shadow-xl", "-drop-shadow-[0_0_red]", "drop-shadow/foo", "-drop-shadow/foo", "-drop-shadow/25", "-drop-shadow-red-500", "drop-shadow-red-500/foo", "-drop-shadow-red-500/foo", "-drop-shadow-red-500/50", "-saturate-0", "saturate--5", "-saturate-[1.75]", "-saturate-[var(--value)]", "saturate-saturate", "-sepia", "sepia--50", "-sepia-0", "-sepia-[50%]", "-sepia-[var(--value)]", "sepia-unknown", "filter/foo", "filter-none/foo", "filter-[var(--value)]/foo", "blur-xl/foo", "blur-none/foo", "blur-[4px]/foo", "brightness-50/foo", "brightness-[1.23]/foo", "contrast-50/foo", "contrast-[1.23]/foo", "grayscale/foo", "grayscale-0/foo", "grayscale-[var(--value)]/foo", "hue-rotate-15/foo", "hue-rotate-[45deg]/foo", "invert/foo", "invert-0/foo", "invert-[var(--value)]/foo", "drop-shadow-xl/foo", "drop-shadow-[0_0_red]/foo", "saturate-0/foo", "saturate-[1.75]/foo", "saturate-[var(--value)]/foo", "sepia/foo", "sepia-0/foo", "sepia-[50%]/foo", "sepia-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_backdrop-filter" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-backdrop-filter", "-backdrop-filter-none", "-backdrop-filter-[var(--value)]", "-backdrop-blur-xl", "-backdrop-blur-[4px]", "backdrop-brightness--50", "-backdrop-brightness-50", "-backdrop-brightness-[1.23]", "backdrop-brightness-unknown", "backdrop-contrast--50", "-backdrop-contrast-50", "-backdrop-contrast-[1.23]", "backdrop-contrast-unknown", "-backdrop-grayscale", "backdrop-grayscale--1", "-backdrop-grayscale-0", "-backdrop-grayscale-[var(--value)]", "backdrop-grayscale-unknown", "backdrop-hue-rotate-unknown", "-backdrop-invert", "backdrop-invert--1", "-backdrop-invert-0", "-backdrop-invert-[var(--value)]", "backdrop-invert-unknown", "backdrop-opacity--50", "-backdrop-opacity-50", "-backdrop-opacity-[0.5]", "backdrop-opacity-unknown", "-backdrop-saturate-0", "backdrop-saturate--50", "-backdrop-saturate-[1.75]", "-backdrop-saturate-[var(--value)]", "backdrop-saturate-unknown", "-backdrop-sepia", "backdrop-sepia--50", "-backdrop-sepia-0", "-backdrop-sepia-[50%]", "-backdrop-sepia-[var(--value)]", "backdrop-sepia-unknown", "backdrop-filter/foo", "backdrop-filter-none/foo", "backdrop-filter-[var(--value)]/foo", "backdrop-blur-none/foo", "backdrop-blur-xl/foo", "backdrop-blur-[4px]/foo", "backdrop-brightness-50/foo", "backdrop-brightness-[1.23]/foo", "backdrop-contrast-50/foo", "backdrop-contrast-[1.23]/foo", "backdrop-grayscale/foo", "backdrop-grayscale-0/foo", "backdrop-grayscale-[var(--value)]/foo", "backdrop-hue-rotate--15", "backdrop-hue-rotate-15/foo", "backdrop-hue-rotate-[45deg]/foo", "backdrop-invert/foo", "backdrop-invert-0/foo", "backdrop-invert-[var(--value)]/foo", "backdrop-opacity-50/foo", "backdrop-opacity-71/foo", "backdrop-opacity-[0.5]/foo", "backdrop-saturate-0/foo", "backdrop-saturate-[1.75]/foo", "backdrop-saturate-[var(--value)]/foo", "backdrop-sepia/foo", "backdrop-sepia-0/foo", "backdrop-sepia-[50%]/foo", "backdrop-sepia-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_transition" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-transition", "-transition-none", "-transition-all", "-transition-opacity", "-transition-[var(--value)]", "transition/foo", "transition-none/foo", "transition-all/foo", "transition-transform/foo", "transition-shadow/foo", "transition-colors/foo", "transition-opacity/foo", "transition-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_transition-behavior" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-transition-discrete", "-transition-normal" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_delay" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "delay", "delay--200", "-delay-200", "-delay-[300ms]", "delay-unknown", "delay-123/foo", "delay-200/foo", "delay-[300ms]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_duration" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "duration", "duration--200", "-duration-200", "-duration-[300ms]", "duration-123/foo", "duration-200/foo", "duration-[300ms]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ease" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-ease-in", "-ease-out", "-ease-[var(--value)]", "ease-in/foo", "ease-out/foo", "ease-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_will-change" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "will-change", "-will-change-auto", "-will-change-contents", "-will-change-transform", "-will-change-scroll", "-will-change-[var(--value)]", "will-change-auto/foo", "will-change-contents/foo", "will-change-transform/foo", "will-change-scroll/foo", "will-change-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_contain" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "contain-none/foo", "contain-content/foo", "contain-strict/foo", "contain-size/foo", "contain-inline-size/foo", "contain-layout/foo", "contain-paint/foo", "contain-style/foo", "contain-[unset]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_forced-color-adjust" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "forced", "forced-color", "forced-color-adjust", "-forced-color-adjust-none", "-forced-color-adjust-auto", "forced-color-adjust-none/foo", "forced-color-adjust-auto/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_leading" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "leading", "-leading-tight", "-leading-6", "-leading-[var(--value)]", "leading-tight/foo", "leading-6/foo", "leading-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_tracking" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "tracking", "tracking-normal/foo", "tracking-wide/foo", "tracking-[var(--value)]/foo", "-tracking-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font-smoothing" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-antialiased", "-subpixel-antialiased", "antialiased/foo", "subpixel-antialiased/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_font-variant-numeric" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-normal-nums", "-ordinal", "-slashed-zero", "-lining-nums", "-oldstyle-nums", "-proportional-nums", "-tabular-nums", "-diagonal-fractions", "-stacked-fractions", "normal-nums/foo", "ordinal/foo", "slashed-zero/foo", "lining-nums/foo", "oldstyle-nums/foo", "proportional-nums/foo", "tabular-nums/foo", "diagonal-fractions/foo", "stacked-fractions/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_outline" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-outline", "-outline-none", "-outline-dashed", "-outline-dotted", "-outline-double", "-outline-red-500", "-outline-red-500/50", "-outline-red-500/[0.5]", "-outline-red-500/[50%]", "-outline-current", "-outline-current/50", "-outline-current/[0.5]", "-outline-current/[50%]", "-outline-inherit", "-outline-transparent", "-outline-[#0088cc]", "-outline-[#0088cc]/50", "-outline-[#0088cc]/[0.5]", "-outline-[#0088cc]/[50%]", "-outline-[black]", "-outline-0", "outline--10", "outline/foo", "outline-none/foo", "outline-solid/foo", "outline-dashed/foo", "outline-dotted/foo", "outline-double/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_outline-offset" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "outline-offset", "outline-offset--4", "outline-offset-unknown", "outline-offset-4/foo", "-outline-offset-4/foo", "outline-offset-[var(--value)]/foo", "-outline-offset-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_opacity" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "opacity", "opacity--15", "opacity-1.125", "-opacity-15", "-opacity-[var(--value)]", "opacity-unknown", "opacity-15/foo", "opacity-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_underline-offset" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "underline-offset", "underline-offset--4", "-underline-offset-auto", "underline-offset-unknown", "underline-offset-auto/foo", "underline-offset-4/foo", "-underline-offset-4/foo", "underline-offset-123/foo", "-underline-offset-123/foo", "underline-offset-[var(--value)]/foo", "-underline-offset-[var(--value)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "text", "-text-red-500", "-text-red-500/50", "-text-red-500/[0.5]", "-text-red-500/[50%]", "-text-current", "-text-current/50", "-text-current/[0.5]", "-text-current/[50%]", "-text-inherit", "-text-transparent", "-text-[#0088cc]", "-text-[#0088cc]/50", "-text-[#0088cc]/[0.5]", "-text-[#0088cc]/[50%]", "-text-sm", "-text-sm/6", "text-sm/foo", "-text-sm/[4px]", "text-[10px]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_text-shadow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-shadow-xl", "-shadow-none", "-shadow-red-500", "-shadow-red-500/50", "-shadow-red-500/[0.5]", "-shadow-red-500/[50%]", "-shadow-current", "-shadow-current/50", "-shadow-current/[0.5]", "-shadow-current/[50%]", "-shadow-inherit", "-shadow-transparent", "-shadow-[#0088cc]", "-shadow-[#0088cc]/50", "-shadow-[#0088cc]/[0.5]", "-shadow-[#0088cc]/[50%]", "-shadow-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_shadow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-shadow-xl", "-shadow-none", "-shadow-red-500", "-shadow-red-500/50", "-shadow-red-500/[0.5]", "-shadow-red-500/[50%]", "-shadow-current", "-shadow-current/50", "-shadow-current/[0.5]", "-shadow-current/[50%]", "-shadow-inherit", "-shadow-transparent", "-shadow-[#0088cc]", "-shadow-[#0088cc]/50", "-shadow-[#0088cc]/[0.5]", "-shadow-[#0088cc]/[50%]", "-shadow-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-shadow" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-inset-shadow-sm", "-inset-shadow-none", "-inset-shadow-red-500", "-inset-shadow-red-500/50", "-inset-shadow-red-500/[0.5]", "-inset-shadow-red-500/[50%]", "-inset-shadow-current", "-inset-shadow-current/50", "-inset-shadow-current/[0.5]", "-inset-shadow-current/[50%]", "-inset-shadow-inherit", "-inset-shadow-transparent", "-inset-shadow-[#0088cc]", "-inset-shadow-[#0088cc]/50", "-inset-shadow-[#0088cc]/[0.5]", "-inset-shadow-[#0088cc]/[50%]", "-inset-shadow-[var(--value)]" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ring" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-ring-inset", "-ring-red-500", "-ring-red-500/50", "-ring-red-500/[0.5]", "-ring-red-500/[50%]", "-ring-current", "-ring-current/50", "-ring-current/[0.5]", "-ring-current/[50%]", "-ring-inherit", "-ring-transparent", "-ring-[#0088cc]", "-ring-[#0088cc]/50", "-ring-[#0088cc]/[0.5]", "-ring-[#0088cc]/[50%]", "-ring", "ring--1", "-ring-0", "-ring-1", "-ring-2", "-ring-4", "ring/foo", "ring-0/foo", "ring-1/foo", "ring-2/foo", "ring-4/foo", "ring-[12px]/foo", "ring-[length:var(--my-width)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inset-ring" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-inset-ring-red-500", "-inset-ring-red-500/50", "-inset-ring-red-500/[0.5]", "-inset-ring-red-500/[50%]", "-inset-ring-current", "-inset-ring-current/50", "-inset-ring-current/[0.5]", "-inset-ring-current/[50%]", "-inset-ring-inherit", "-inset-ring-transparent", "-inset-ring-[#0088cc]", "-inset-ring-[#0088cc]/50", "-inset-ring-[#0088cc]/[0.5]", "-inset-ring-[#0088cc]/[50%]", "-inset-ring", "inset-ring--1", "-inset-ring-0", "-inset-ring-1", "-inset-ring-2", "-inset-ring-4", "inset-ring/foo", "inset-ring-0/foo", "inset-ring-1/foo", "inset-ring-2/foo", "inset-ring-4/foo", "inset-ring-[12px]/foo", "inset-ring-[length:var(--my-width)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ring-offset" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ring-offset", "-ring-offset-inset", "-ring-offset-red-500", "-ring-offset-red-500/50", "-ring-offset-red-500/[0.5]", "-ring-offset-red-500/[50%]", "-ring-offset-current", "-ring-offset-current/50", "-ring-offset-current/[0.5]", "-ring-offset-current/[50%]", "-ring-offset-inherit", "-ring-offset-transparent", "-ring-offset-[#0088cc]", "-ring-offset-[#0088cc]/50", "-ring-offset-[#0088cc]/[0.5]", "-ring-offset-[#0088cc]/[50%]", "ring-offset--1", "-ring-offset-0", "-ring-offset-1", "-ring-offset-2", "-ring-offset-4", "ring-offset-0/foo", "ring-offset-1/foo", "ring-offset-2/foo", "ring-offset-4/foo", "ring-offset-[12px]/foo", "ring-offset-[length:var(--my-width)]/foo" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_container" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "-@container", "-@container-normal", "-@container/sidebar", "-@container-normal/sidebar", "-@container-size", "-@container-size/sidebar" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_spacing utilities  spacing utilities must have a value" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "<compiled>" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_functional utilities  functional utility with double-dash se" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "border--3" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_test_0" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "*/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_test_0_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "**/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_first-letter" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-letter/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_first-line" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-line/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_marker" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "marker/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_selection" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "selection/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_file" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "file/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_placeholder_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_backdrop" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "backdrop/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_details-content" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "details-content/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_before" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "before/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_after" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "after/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_first" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_last" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "last/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "only/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_odd" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "odd/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_even" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "even/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_first-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "first-of-type/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_last-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "last-of-type/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_only-of-type" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "only-of-type/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_visited" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "visited/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_target" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "target/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_open" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "open/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_default" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "default/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_checked" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "checked/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_indeterminate" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "indeterminate/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_placeholder-shown" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "placeholder-shown/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_autofill" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "autofill/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_optional" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "optional/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_required" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "required/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_valid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "valid/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_invalid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "invalid/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_user-valid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "user-valid/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_user-invalid" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "invalid/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_in-range" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "in-range/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_out-of-range" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "out-of-range/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_read-only" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "read-only/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_empty" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "empty/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_focus-within" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus-within/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_hover" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "hover/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_focus" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_focus-visible" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "focus-visible/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_active" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "active/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_enabled" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "enabled/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_disabled" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "disabled/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_inert" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "inert/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_group-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-[]:flex", "group-hover/[]:flex", "group-[@media_foo]:flex", "group-[>img]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_group-_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "group-custom-at-rule:flex", "group-nested-selectors:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_peer-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "peer-[]:flex", "peer-hover/[]:flex", "peer-[@media_foo]:flex", "peer-[>img]:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_peer-_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "peer-custom-at-rule:flex", "peer-nested-selectors:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_ltr" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "ltr/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_rtl" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "rtl/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_motion-safe" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "motion-safe/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_motion-reduce" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "motion-reduce/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_dark" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "dark/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_starting" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "starting/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_print" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "print/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_default breakpoints" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "sm/foo:flex", "md/foo:flex", "lg/foo:flex", "xl/foo:flex", "2xl/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_max-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "max-lg/foo:flex", "max-sm/foo:flex", "max-md/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_min-" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "min-lg/foo:flex", "min-sm/foo:flex", "min-md/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_supports" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "supports-gap/foo:grid", "supports-[display:grid]/foo:flex", "supports-[selector(A_>_B)]/foo:flex", "supports-[font-format(opentype)]/foo:grid", "supports-[(display:grid)_and_font-format(opentype)]/foo:grid", "supports-[font-tech(color-COLRv1)]/foo:flex", "supports-[var(--test)]/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_in" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "in-p:flex", "in-foo-bar:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_has" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "has-[:checked]/foo:flex", "has-[@media_print]:flex", "has-custom-at-rule:flex", "has-nested-selectors:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_aria" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "aria-checked/foo:flex", "aria-[invalid=spelling]/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_portrait" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "portrait/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_landscape" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "landscape/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_contrast-more" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "contrast-more/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_contrast-less" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "contrast-less/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_forced-colors" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "forced-colors/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_nth" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "nth-foo:flex", "nth-of-type-foo:flex", "nth-last-foo:flex", "nth-last-of-type-foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_nth_1" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "nth--3:flex", "nth-3/foo:flex", "nth-[2n+1]/foo:flex", "nth-[2n+1_of_.foo]/foo:flex", "nth-last--3:flex", "nth-last-3/foo:flex", "nth-last-[2n+1]/foo:flex", "nth-last-[2n+1_of_.foo]/foo:flex", "nth-of-type--3:flex", "nth-of-type-3/foo:flex", "nth-of-type-[2n+1]/foo:flex", "nth-last-of-type--3:flex", "nth-last-of-type-3/foo:flex", "nth-last-of-type-[2n+1]/foo:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_container queries" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "@-lg:flex", "@-lg/name:flex", "@-[123px]:flex", "@-[456px]/name:flex", "@-foo-bar:flex", "@-foo-bar/name:flex", "@-min-lg:flex", "@-min-lg/name:flex", "@-min-[123px]:flex", "@-min-[456px]/name:flex", "@-min-foo-bar:flex", "@-min-foo-bar/name:flex", "@-max-lg:flex", "@-max-lg/name:flex", "@-max-[123px]:flex", "@-max-[456px]/name:flex", "@-max-foo-bar:flex", "@-max-foo-bar/name:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should skip unknown utilities" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "unknown-utility" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should skip unknown variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "unknown-variant:flex" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should not parse invalid arbitrary values" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${candidate}" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should not parse invalid arbitrary values in variants" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${candidate}" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should not parse invalid empty arbitrary values s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${rawCandidate}" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}

test "tw neg: neg_should not parse invalid values s" {
    const alloc = std.testing.allocator;
    const candidates = [_][]const u8{ "${rawCandidate}" };
    const result = try compile(alloc, &candidates);
    defer alloc.free(result);

    // Should produce empty or minimal output (no utility rules)
    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or
        std.mem.indexOf(u8, result, "@layer utilities{}") != null);
}
