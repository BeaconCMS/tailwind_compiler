const std = @import("std");
const Allocator = std.mem.Allocator;
const emitter_mod = @import("emitter.zig");
const Declaration = emitter_mod.Declaration;
const AtProperty = emitter_mod.AtProperty;
const Keyframes = emitter_mod.Keyframes;
const Theme = @import("theme.zig").Theme;
const candidate_mod = @import("candidate.zig");
const Value = candidate_mod.Value;
const Modifier = candidate_mod.Modifier;

// ─── Static Utilities ──────────────────────────────────────────────────────

/// Lookup a static utility by name. Returns CSS declarations if found.
pub fn lookupStatic(name: []const u8) ?[]const Declaration {
    return static_utilities.get(name);
}

/// Check if a name is a registered static utility.
pub fn isStaticUtility(name: []const u8) bool {
    return static_utilities.has(name);
}

/// Check if a name is a registered functional utility.
pub fn isFunctionalUtility(name: []const u8) bool {
    return functional_utility_set.has(name);
}

const StaticEntry = struct { []const u8, []const Declaration };

pub const static_utilities = std.StaticStringMap([]const Declaration).initComptime(.{
    // ─── Display ───
    .{ "block", &[_]Declaration{.{ .property = "display", .value = "block" }} },
    .{ "inline-block", &[_]Declaration{.{ .property = "display", .value = "inline-block" }} },
    .{ "inline", &[_]Declaration{.{ .property = "display", .value = "inline" }} },
    .{ "flex", &[_]Declaration{.{ .property = "display", .value = "flex" }} },
    .{ "inline-flex", &[_]Declaration{.{ .property = "display", .value = "inline-flex" }} },
    .{ "grid", &[_]Declaration{.{ .property = "display", .value = "grid" }} },
    .{ "inline-grid", &[_]Declaration{.{ .property = "display", .value = "inline-grid" }} },
    .{ "contents", &[_]Declaration{.{ .property = "display", .value = "contents" }} },
    .{ "flow-root", &[_]Declaration{.{ .property = "display", .value = "flow-root" }} },
    .{ "list-item", &[_]Declaration{.{ .property = "display", .value = "list-item" }} },
    .{ "hidden", &[_]Declaration{.{ .property = "display", .value = "none" }} },
    .{ "table", &[_]Declaration{.{ .property = "display", .value = "table" }} },
    .{ "table-caption", &[_]Declaration{.{ .property = "display", .value = "table-caption" }} },
    .{ "table-cell", &[_]Declaration{.{ .property = "display", .value = "table-cell" }} },
    .{ "table-column", &[_]Declaration{.{ .property = "display", .value = "table-column" }} },
    .{ "table-column-group", &[_]Declaration{.{ .property = "display", .value = "table-column-group" }} },
    .{ "table-footer-group", &[_]Declaration{.{ .property = "display", .value = "table-footer-group" }} },
    .{ "table-header-group", &[_]Declaration{.{ .property = "display", .value = "table-header-group" }} },
    .{ "table-row-group", &[_]Declaration{.{ .property = "display", .value = "table-row-group" }} },
    .{ "table-row", &[_]Declaration{.{ .property = "display", .value = "table-row" }} },
    .{ "ruby", &[_]Declaration{.{ .property = "display", .value = "ruby" }} },
    .{ "ruby-text", &[_]Declaration{.{ .property = "display", .value = "ruby-text" }} },

    // ─── Position ───
    .{ "static", &[_]Declaration{.{ .property = "position", .value = "static" }} },
    .{ "fixed", &[_]Declaration{.{ .property = "position", .value = "fixed" }} },
    .{ "absolute", &[_]Declaration{.{ .property = "position", .value = "absolute" }} },
    .{ "relative", &[_]Declaration{.{ .property = "position", .value = "relative" }} },
    .{ "sticky", &[_]Declaration{.{ .property = "position", .value = "sticky" }} },

    // ─── Visibility ───
    .{ "visible", &[_]Declaration{.{ .property = "visibility", .value = "visible" }} },
    .{ "invisible", &[_]Declaration{.{ .property = "visibility", .value = "hidden" }} },
    .{ "collapse", &[_]Declaration{.{ .property = "visibility", .value = "collapse" }} },

    // ─── Isolation ───
    .{ "isolate", &[_]Declaration{.{ .property = "isolation", .value = "isolate" }} },
    .{ "isolation-auto", &[_]Declaration{.{ .property = "isolation", .value = "auto" }} },

    // ─── Box Sizing ───
    .{ "box-border", &[_]Declaration{.{ .property = "box-sizing", .value = "border-box" }} },
    .{ "box-content", &[_]Declaration{.{ .property = "box-sizing", .value = "content-box" }} },

    // ─── Float ───
    .{ "float-right", &[_]Declaration{.{ .property = "float", .value = "right" }} },
    .{ "float-left", &[_]Declaration{.{ .property = "float", .value = "left" }} },
    .{ "float-start", &[_]Declaration{.{ .property = "float", .value = "inline-start" }} },
    .{ "float-end", &[_]Declaration{.{ .property = "float", .value = "inline-end" }} },
    .{ "float-none", &[_]Declaration{.{ .property = "float", .value = "none" }} },

    // ─── Clear ───
    .{ "clear-right", &[_]Declaration{.{ .property = "clear", .value = "right" }} },
    .{ "clear-left", &[_]Declaration{.{ .property = "clear", .value = "left" }} },
    .{ "clear-both", &[_]Declaration{.{ .property = "clear", .value = "both" }} },
    .{ "clear-start", &[_]Declaration{.{ .property = "clear", .value = "inline-start" }} },
    .{ "clear-end", &[_]Declaration{.{ .property = "clear", .value = "inline-end" }} },
    .{ "clear-none", &[_]Declaration{.{ .property = "clear", .value = "none" }} },

    // ─── Overflow ───
    .{ "overflow-auto", &[_]Declaration{.{ .property = "overflow", .value = "auto" }} },
    .{ "overflow-hidden", &[_]Declaration{.{ .property = "overflow", .value = "hidden" }} },
    .{ "overflow-clip", &[_]Declaration{.{ .property = "overflow", .value = "clip" }} },
    .{ "overflow-visible", &[_]Declaration{.{ .property = "overflow", .value = "visible" }} },
    .{ "overflow-scroll", &[_]Declaration{.{ .property = "overflow", .value = "scroll" }} },
    .{ "overflow-x-auto", &[_]Declaration{.{ .property = "overflow-x", .value = "auto" }} },
    .{ "overflow-x-hidden", &[_]Declaration{.{ .property = "overflow-x", .value = "hidden" }} },
    .{ "overflow-x-clip", &[_]Declaration{.{ .property = "overflow-x", .value = "clip" }} },
    .{ "overflow-x-visible", &[_]Declaration{.{ .property = "overflow-x", .value = "visible" }} },
    .{ "overflow-x-scroll", &[_]Declaration{.{ .property = "overflow-x", .value = "scroll" }} },
    .{ "overflow-y-auto", &[_]Declaration{.{ .property = "overflow-y", .value = "auto" }} },
    .{ "overflow-y-hidden", &[_]Declaration{.{ .property = "overflow-y", .value = "hidden" }} },
    .{ "overflow-y-clip", &[_]Declaration{.{ .property = "overflow-y", .value = "clip" }} },
    .{ "overflow-y-visible", &[_]Declaration{.{ .property = "overflow-y", .value = "visible" }} },
    .{ "overflow-y-scroll", &[_]Declaration{.{ .property = "overflow-y", .value = "scroll" }} },

    // ─── Overscroll ───
    .{ "overscroll-auto", &[_]Declaration{.{ .property = "overscroll-behavior", .value = "auto" }} },
    .{ "overscroll-contain", &[_]Declaration{.{ .property = "overscroll-behavior", .value = "contain" }} },
    .{ "overscroll-none", &[_]Declaration{.{ .property = "overscroll-behavior", .value = "none" }} },
    .{ "overscroll-x-auto", &[_]Declaration{.{ .property = "overscroll-behavior-x", .value = "auto" }} },
    .{ "overscroll-x-contain", &[_]Declaration{.{ .property = "overscroll-behavior-x", .value = "contain" }} },
    .{ "overscroll-x-none", &[_]Declaration{.{ .property = "overscroll-behavior-x", .value = "none" }} },
    .{ "overscroll-y-auto", &[_]Declaration{.{ .property = "overscroll-behavior-y", .value = "auto" }} },
    .{ "overscroll-y-contain", &[_]Declaration{.{ .property = "overscroll-behavior-y", .value = "contain" }} },
    .{ "overscroll-y-none", &[_]Declaration{.{ .property = "overscroll-behavior-y", .value = "none" }} },

    // ─── Object Fit ───
    .{ "object-contain", &[_]Declaration{.{ .property = "object-fit", .value = "contain" }} },
    .{ "object-cover", &[_]Declaration{.{ .property = "object-fit", .value = "cover" }} },
    .{ "object-fill", &[_]Declaration{.{ .property = "object-fit", .value = "fill" }} },
    .{ "object-none", &[_]Declaration{.{ .property = "object-fit", .value = "none" }} },
    .{ "object-scale-down", &[_]Declaration{.{ .property = "object-fit", .value = "scale-down" }} },

    // ─── Pointer Events ───
    .{ "pointer-events-none", &[_]Declaration{.{ .property = "pointer-events", .value = "none" }} },
    .{ "pointer-events-auto", &[_]Declaration{.{ .property = "pointer-events", .value = "auto" }} },

    // ─── Resize ───
    .{ "resize-none", &[_]Declaration{.{ .property = "resize", .value = "none" }} },
    .{ "resize-x", &[_]Declaration{.{ .property = "resize", .value = "horizontal" }} },
    .{ "resize-y", &[_]Declaration{.{ .property = "resize", .value = "vertical" }} },
    .{ "resize", &[_]Declaration{.{ .property = "resize", .value = "both" }} },

    // ─── User Select ───
    .{ "select-none", &[_]Declaration{ .{ .property = "-webkit-user-select", .value = "none" }, .{ .property = "user-select", .value = "none" } } },
    .{ "select-text", &[_]Declaration{ .{ .property = "-webkit-user-select", .value = "text" }, .{ .property = "user-select", .value = "text" } } },
    .{ "select-all", &[_]Declaration{ .{ .property = "-webkit-user-select", .value = "all" }, .{ .property = "user-select", .value = "all" } } },
    .{ "select-auto", &[_]Declaration{ .{ .property = "-webkit-user-select", .value = "auto" }, .{ .property = "user-select", .value = "auto" } } },

    // ─── Touch Action ───
    .{ "touch-auto", &[_]Declaration{.{ .property = "touch-action", .value = "auto" }} },
    .{ "touch-none", &[_]Declaration{.{ .property = "touch-action", .value = "none" }} },
    .{ "touch-pan-x", &[_]Declaration{.{ .property = "touch-action", .value = "pan-x" }} },
    .{ "touch-pan-left", &[_]Declaration{.{ .property = "touch-action", .value = "pan-left" }} },
    .{ "touch-pan-right", &[_]Declaration{.{ .property = "touch-action", .value = "pan-right" }} },
    .{ "touch-pan-y", &[_]Declaration{.{ .property = "touch-action", .value = "pan-y" }} },
    .{ "touch-pan-up", &[_]Declaration{.{ .property = "touch-action", .value = "pan-up" }} },
    .{ "touch-pan-down", &[_]Declaration{.{ .property = "touch-action", .value = "pan-down" }} },
    .{ "touch-pinch-zoom", &[_]Declaration{.{ .property = "touch-action", .value = "pinch-zoom" }} },
    .{ "touch-manipulation", &[_]Declaration{.{ .property = "touch-action", .value = "manipulation" }} },

    // ─── Cursor ───
    .{ "cursor-auto", &[_]Declaration{.{ .property = "cursor", .value = "auto" }} },
    .{ "cursor-default", &[_]Declaration{.{ .property = "cursor", .value = "default" }} },
    .{ "cursor-pointer", &[_]Declaration{.{ .property = "cursor", .value = "pointer" }} },
    .{ "cursor-wait", &[_]Declaration{.{ .property = "cursor", .value = "wait" }} },
    .{ "cursor-text", &[_]Declaration{.{ .property = "cursor", .value = "text" }} },
    .{ "cursor-move", &[_]Declaration{.{ .property = "cursor", .value = "move" }} },
    .{ "cursor-help", &[_]Declaration{.{ .property = "cursor", .value = "help" }} },
    .{ "cursor-not-allowed", &[_]Declaration{.{ .property = "cursor", .value = "not-allowed" }} },
    .{ "cursor-none", &[_]Declaration{.{ .property = "cursor", .value = "none" }} },
    .{ "cursor-context-menu", &[_]Declaration{.{ .property = "cursor", .value = "context-menu" }} },
    .{ "cursor-progress", &[_]Declaration{.{ .property = "cursor", .value = "progress" }} },
    .{ "cursor-cell", &[_]Declaration{.{ .property = "cursor", .value = "cell" }} },
    .{ "cursor-crosshair", &[_]Declaration{.{ .property = "cursor", .value = "crosshair" }} },
    .{ "cursor-vertical-text", &[_]Declaration{.{ .property = "cursor", .value = "vertical-text" }} },
    .{ "cursor-alias", &[_]Declaration{.{ .property = "cursor", .value = "alias" }} },
    .{ "cursor-copy", &[_]Declaration{.{ .property = "cursor", .value = "copy" }} },
    .{ "cursor-no-drop", &[_]Declaration{.{ .property = "cursor", .value = "no-drop" }} },
    .{ "cursor-grab", &[_]Declaration{.{ .property = "cursor", .value = "grab" }} },
    .{ "cursor-grabbing", &[_]Declaration{.{ .property = "cursor", .value = "grabbing" }} },
    .{ "cursor-all-scroll", &[_]Declaration{.{ .property = "cursor", .value = "all-scroll" }} },
    .{ "cursor-col-resize", &[_]Declaration{.{ .property = "cursor", .value = "col-resize" }} },
    .{ "cursor-row-resize", &[_]Declaration{.{ .property = "cursor", .value = "row-resize" }} },
    .{ "cursor-n-resize", &[_]Declaration{.{ .property = "cursor", .value = "n-resize" }} },
    .{ "cursor-e-resize", &[_]Declaration{.{ .property = "cursor", .value = "e-resize" }} },
    .{ "cursor-s-resize", &[_]Declaration{.{ .property = "cursor", .value = "s-resize" }} },
    .{ "cursor-w-resize", &[_]Declaration{.{ .property = "cursor", .value = "w-resize" }} },
    .{ "cursor-ne-resize", &[_]Declaration{.{ .property = "cursor", .value = "ne-resize" }} },
    .{ "cursor-nw-resize", &[_]Declaration{.{ .property = "cursor", .value = "nw-resize" }} },
    .{ "cursor-se-resize", &[_]Declaration{.{ .property = "cursor", .value = "se-resize" }} },
    .{ "cursor-sw-resize", &[_]Declaration{.{ .property = "cursor", .value = "sw-resize" }} },
    .{ "cursor-ew-resize", &[_]Declaration{.{ .property = "cursor", .value = "ew-resize" }} },
    .{ "cursor-ns-resize", &[_]Declaration{.{ .property = "cursor", .value = "ns-resize" }} },
    .{ "cursor-nesw-resize", &[_]Declaration{.{ .property = "cursor", .value = "nesw-resize" }} },
    .{ "cursor-nwse-resize", &[_]Declaration{.{ .property = "cursor", .value = "nwse-resize" }} },
    .{ "cursor-zoom-in", &[_]Declaration{.{ .property = "cursor", .value = "zoom-in" }} },
    .{ "cursor-zoom-out", &[_]Declaration{.{ .property = "cursor", .value = "zoom-out" }} },

    // ─── Appearance ───
    .{ "appearance-none", &[_]Declaration{.{ .property = "appearance", .value = "none" }} },
    .{ "appearance-auto", &[_]Declaration{.{ .property = "appearance", .value = "auto" }} },

    // ─── Flex Direction ───
    .{ "flex-row", &[_]Declaration{.{ .property = "flex-direction", .value = "row" }} },
    .{ "flex-row-reverse", &[_]Declaration{.{ .property = "flex-direction", .value = "row-reverse" }} },
    .{ "flex-col", &[_]Declaration{.{ .property = "flex-direction", .value = "column" }} },
    .{ "flex-col-reverse", &[_]Declaration{.{ .property = "flex-direction", .value = "column-reverse" }} },

    // ─── Flex Wrap ───
    .{ "flex-wrap", &[_]Declaration{.{ .property = "flex-wrap", .value = "wrap" }} },
    .{ "flex-wrap-reverse", &[_]Declaration{.{ .property = "flex-wrap", .value = "wrap-reverse" }} },
    .{ "flex-nowrap", &[_]Declaration{.{ .property = "flex-wrap", .value = "nowrap" }} },

    // ─── Flex Shrink/Grow ───
    .{ "grow", &[_]Declaration{.{ .property = "flex-grow", .value = "1" }} },
    .{ "grow-0", &[_]Declaration{.{ .property = "flex-grow", .value = "0" }} },
    .{ "shrink", &[_]Declaration{.{ .property = "flex-shrink", .value = "1" }} },
    .{ "shrink-0", &[_]Declaration{.{ .property = "flex-shrink", .value = "0" }} },
    .{ "flex-1", &[_]Declaration{.{ .property = "flex", .value = "1 1 0%" }} },
    .{ "flex-auto", &[_]Declaration{.{ .property = "flex", .value = "1 1 auto" }} },
    .{ "flex-initial", &[_]Declaration{.{ .property = "flex", .value = "0 1 auto" }} },
    .{ "flex-none", &[_]Declaration{.{ .property = "flex", .value = "none" }} },

    // ─── Grid Auto Flow ───
    .{ "grid-flow-row", &[_]Declaration{.{ .property = "grid-auto-flow", .value = "row" }} },
    .{ "grid-flow-col", &[_]Declaration{.{ .property = "grid-auto-flow", .value = "column" }} },
    .{ "grid-flow-dense", &[_]Declaration{.{ .property = "grid-auto-flow", .value = "dense" }} },
    .{ "grid-flow-row-dense", &[_]Declaration{.{ .property = "grid-auto-flow", .value = "row dense" }} },
    .{ "grid-flow-col-dense", &[_]Declaration{.{ .property = "grid-auto-flow", .value = "column dense" }} },

    // ─── Justify Content ───
    .{ "justify-normal", &[_]Declaration{.{ .property = "justify-content", .value = "normal" }} },
    .{ "justify-start", &[_]Declaration{.{ .property = "justify-content", .value = "flex-start" }} },
    .{ "justify-end", &[_]Declaration{.{ .property = "justify-content", .value = "flex-end" }} },
    .{ "justify-center", &[_]Declaration{.{ .property = "justify-content", .value = "center" }} },
    .{ "justify-between", &[_]Declaration{.{ .property = "justify-content", .value = "space-between" }} },
    .{ "justify-around", &[_]Declaration{.{ .property = "justify-content", .value = "space-around" }} },
    .{ "justify-evenly", &[_]Declaration{.{ .property = "justify-content", .value = "space-evenly" }} },
    .{ "justify-stretch", &[_]Declaration{.{ .property = "justify-content", .value = "stretch" }} },
    .{ "justify-start-safe", &[_]Declaration{.{ .property = "justify-content", .value = "safe flex-start" }} },
    .{ "justify-end-safe", &[_]Declaration{.{ .property = "justify-content", .value = "safe flex-end" }} },
    .{ "justify-center-safe", &[_]Declaration{.{ .property = "justify-content", .value = "safe center" }} },

    // ─── Justify Items ───
    .{ "justify-items-start", &[_]Declaration{.{ .property = "justify-items", .value = "start" }} },
    .{ "justify-items-end", &[_]Declaration{.{ .property = "justify-items", .value = "end" }} },
    .{ "justify-items-center", &[_]Declaration{.{ .property = "justify-items", .value = "center" }} },
    .{ "justify-items-stretch", &[_]Declaration{.{ .property = "justify-items", .value = "stretch" }} },
    .{ "justify-items-normal", &[_]Declaration{.{ .property = "justify-items", .value = "normal" }} },

    // ─── Justify Self ───
    .{ "justify-self-auto", &[_]Declaration{.{ .property = "justify-self", .value = "auto" }} },
    .{ "justify-self-start", &[_]Declaration{.{ .property = "justify-self", .value = "flex-start" }} },
    .{ "justify-self-end", &[_]Declaration{.{ .property = "justify-self", .value = "flex-end" }} },
    .{ "justify-self-center", &[_]Declaration{.{ .property = "justify-self", .value = "center" }} },
    .{ "justify-self-stretch", &[_]Declaration{.{ .property = "justify-self", .value = "stretch" }} },
    .{ "justify-self-end-safe", &[_]Declaration{.{ .property = "justify-self", .value = "safe flex-end" }} },
    .{ "justify-self-center-safe", &[_]Declaration{.{ .property = "justify-self", .value = "safe center" }} },

    // ─── Align Content ───
    .{ "content-normal", &[_]Declaration{.{ .property = "align-content", .value = "normal" }} },
    .{ "content-start", &[_]Declaration{.{ .property = "align-content", .value = "flex-start" }} },
    .{ "content-end", &[_]Declaration{.{ .property = "align-content", .value = "flex-end" }} },
    .{ "content-center", &[_]Declaration{.{ .property = "align-content", .value = "center" }} },
    .{ "content-between", &[_]Declaration{.{ .property = "align-content", .value = "space-between" }} },
    .{ "content-around", &[_]Declaration{.{ .property = "align-content", .value = "space-around" }} },
    .{ "content-evenly", &[_]Declaration{.{ .property = "align-content", .value = "space-evenly" }} },
    .{ "content-baseline", &[_]Declaration{.{ .property = "align-content", .value = "baseline" }} },
    .{ "content-stretch", &[_]Declaration{.{ .property = "align-content", .value = "stretch" }} },

    // ─── Align Items ───
    .{ "items-start", &[_]Declaration{.{ .property = "align-items", .value = "flex-start" }} },
    .{ "items-end", &[_]Declaration{.{ .property = "align-items", .value = "flex-end" }} },
    .{ "items-center", &[_]Declaration{.{ .property = "align-items", .value = "center" }} },
    .{ "items-baseline", &[_]Declaration{.{ .property = "align-items", .value = "baseline" }} },
    .{ "items-stretch", &[_]Declaration{.{ .property = "align-items", .value = "stretch" }} },
    .{ "items-start-safe", &[_]Declaration{.{ .property = "align-items", .value = "safe flex-start" }} },
    .{ "items-end-safe", &[_]Declaration{.{ .property = "align-items", .value = "safe flex-end" }} },
    .{ "items-center-safe", &[_]Declaration{.{ .property = "align-items", .value = "safe center" }} },

    // ─── Align Self ───
    .{ "self-auto", &[_]Declaration{.{ .property = "align-self", .value = "auto" }} },
    .{ "self-start", &[_]Declaration{.{ .property = "align-self", .value = "flex-start" }} },
    .{ "self-end", &[_]Declaration{.{ .property = "align-self", .value = "flex-end" }} },
    .{ "self-center", &[_]Declaration{.{ .property = "align-self", .value = "center" }} },
    .{ "self-stretch", &[_]Declaration{.{ .property = "align-self", .value = "stretch" }} },
    .{ "self-baseline", &[_]Declaration{.{ .property = "align-self", .value = "baseline" }} },
    .{ "self-start-safe", &[_]Declaration{.{ .property = "align-self", .value = "safe flex-start" }} },
    .{ "self-end-safe", &[_]Declaration{.{ .property = "align-self", .value = "safe flex-end" }} },
    .{ "self-center-safe", &[_]Declaration{.{ .property = "align-self", .value = "safe center" }} },
    .{ "self-baseline-last", &[_]Declaration{.{ .property = "align-self", .value = "last baseline" }} },

    // ─── Place Content ───
    .{ "place-content-start", &[_]Declaration{.{ .property = "place-content", .value = "start" }} },
    .{ "place-content-end", &[_]Declaration{.{ .property = "place-content", .value = "end" }} },
    .{ "place-content-center", &[_]Declaration{.{ .property = "place-content", .value = "center" }} },
    .{ "place-content-between", &[_]Declaration{.{ .property = "place-content", .value = "space-between" }} },
    .{ "place-content-around", &[_]Declaration{.{ .property = "place-content", .value = "space-around" }} },
    .{ "place-content-evenly", &[_]Declaration{.{ .property = "place-content", .value = "space-evenly" }} },
    .{ "place-content-baseline", &[_]Declaration{.{ .property = "place-content", .value = "baseline" }} },
    .{ "place-content-stretch", &[_]Declaration{.{ .property = "place-content", .value = "stretch" }} },

    // ─── Place Items ───
    .{ "place-items-start", &[_]Declaration{.{ .property = "place-items", .value = "start" }} },
    .{ "place-items-end", &[_]Declaration{.{ .property = "place-items", .value = "end" }} },
    .{ "place-items-center", &[_]Declaration{.{ .property = "place-items", .value = "center" }} },
    .{ "place-items-baseline", &[_]Declaration{.{ .property = "place-items", .value = "baseline" }} },
    .{ "place-items-stretch", &[_]Declaration{.{ .property = "place-items", .value = "stretch" }} },

    // ─── Place Self ───
    .{ "place-self-auto", &[_]Declaration{.{ .property = "place-self", .value = "auto" }} },
    .{ "place-self-start", &[_]Declaration{.{ .property = "place-self", .value = "start" }} },
    .{ "place-self-end", &[_]Declaration{.{ .property = "place-self", .value = "end" }} },
    .{ "place-self-center", &[_]Declaration{.{ .property = "place-self", .value = "center" }} },
    .{ "place-self-stretch", &[_]Declaration{.{ .property = "place-self", .value = "stretch" }} },
    .{ "place-self-end-safe", &[_]Declaration{.{ .property = "place-self", .value = "safe end" }} },
    .{ "place-self-center-safe", &[_]Declaration{.{ .property = "place-self", .value = "safe center" }} },

    // ─── Text Alignment ───
    .{ "text-left", &[_]Declaration{.{ .property = "text-align", .value = "left" }} },
    .{ "text-center", &[_]Declaration{.{ .property = "text-align", .value = "center" }} },
    .{ "text-right", &[_]Declaration{.{ .property = "text-align", .value = "right" }} },
    .{ "text-justify", &[_]Declaration{.{ .property = "text-align", .value = "justify" }} },
    .{ "text-start", &[_]Declaration{.{ .property = "text-align", .value = "start" }} },
    .{ "text-end", &[_]Declaration{.{ .property = "text-align", .value = "end" }} },

    // ─── Text Decoration ───
    .{ "underline", &[_]Declaration{.{ .property = "text-decoration-line", .value = "underline" }} },
    .{ "overline", &[_]Declaration{.{ .property = "text-decoration-line", .value = "overline" }} },
    .{ "line-through", &[_]Declaration{.{ .property = "text-decoration-line", .value = "line-through" }} },
    .{ "no-underline", &[_]Declaration{.{ .property = "text-decoration-line", .value = "none" }} },

    // ─── Text Decoration Style ───
    .{ "decoration-solid", &[_]Declaration{.{ .property = "text-decoration-style", .value = "solid" }} },
    .{ "decoration-double", &[_]Declaration{.{ .property = "text-decoration-style", .value = "double" }} },
    .{ "decoration-dotted", &[_]Declaration{.{ .property = "text-decoration-style", .value = "dotted" }} },
    .{ "decoration-dashed", &[_]Declaration{.{ .property = "text-decoration-style", .value = "dashed" }} },
    .{ "decoration-wavy", &[_]Declaration{.{ .property = "text-decoration-style", .value = "wavy" }} },

    // ─── Text Transform ───
    .{ "uppercase", &[_]Declaration{.{ .property = "text-transform", .value = "uppercase" }} },
    .{ "lowercase", &[_]Declaration{.{ .property = "text-transform", .value = "lowercase" }} },
    .{ "capitalize", &[_]Declaration{.{ .property = "text-transform", .value = "capitalize" }} },
    .{ "normal-case", &[_]Declaration{.{ .property = "text-transform", .value = "none" }} },

    // ─── Text Overflow ───
    .{ "text-ellipsis", &[_]Declaration{.{ .property = "text-overflow", .value = "ellipsis" }} },
    .{ "text-clip", &[_]Declaration{.{ .property = "text-overflow", .value = "clip" }} },
    .{ "truncate", &[_]Declaration{
        .{ .property = "overflow", .value = "hidden" },
        .{ .property = "text-overflow", .value = "ellipsis" },
        .{ .property = "white-space", .value = "nowrap" },
    } },

    // ─── Text Wrap ───
    .{ "text-wrap", &[_]Declaration{.{ .property = "text-wrap", .value = "wrap" }} },
    .{ "text-nowrap", &[_]Declaration{.{ .property = "text-wrap", .value = "nowrap" }} },
    .{ "text-balance", &[_]Declaration{.{ .property = "text-wrap", .value = "balance" }} },
    .{ "text-pretty", &[_]Declaration{.{ .property = "text-wrap", .value = "pretty" }} },

    // ─── Whitespace ───
    .{ "whitespace-normal", &[_]Declaration{.{ .property = "white-space", .value = "normal" }} },
    .{ "whitespace-nowrap", &[_]Declaration{.{ .property = "white-space", .value = "nowrap" }} },
    .{ "whitespace-pre", &[_]Declaration{.{ .property = "white-space", .value = "pre" }} },
    .{ "whitespace-pre-line", &[_]Declaration{.{ .property = "white-space", .value = "pre-line" }} },
    .{ "whitespace-pre-wrap", &[_]Declaration{.{ .property = "white-space", .value = "pre-wrap" }} },
    .{ "whitespace-break-spaces", &[_]Declaration{.{ .property = "white-space", .value = "break-spaces" }} },

    // ─── Word Break / Overflow Wrap ───
    .{ "break-normal", &[_]Declaration{ .{ .property = "overflow-wrap", .value = "normal" }, .{ .property = "word-break", .value = "normal" } } },
    .{ "break-all", &[_]Declaration{.{ .property = "word-break", .value = "break-all" }} },
    .{ "break-keep", &[_]Declaration{.{ .property = "word-break", .value = "keep-all" }} },
    .{ "break-words", &[_]Declaration{.{ .property = "overflow-wrap", .value = "break-word" }} },
    .{ "wrap-break-word", &[_]Declaration{.{ .property = "overflow-wrap", .value = "break-word" }} },
    .{ "wrap-anywhere", &[_]Declaration{.{ .property = "overflow-wrap", .value = "anywhere" }} },
    .{ "wrap-normal", &[_]Declaration{.{ .property = "overflow-wrap", .value = "normal" }} },

    // ─── Hyphens ───
    .{ "hyphens-none", &[_]Declaration{.{ .property = "hyphens", .value = "none" }} },
    .{ "hyphens-manual", &[_]Declaration{.{ .property = "hyphens", .value = "manual" }} },
    .{ "hyphens-auto", &[_]Declaration{.{ .property = "hyphens", .value = "auto" }} },

    // ─── Font Style ───
    .{ "italic", &[_]Declaration{.{ .property = "font-style", .value = "italic" }} },
    .{ "not-italic", &[_]Declaration{.{ .property = "font-style", .value = "normal" }} },

    // ─── Font Variant Numeric ───
    .{ "normal-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "normal" }} },
    .{ "ordinal", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "ordinal" }} },
    .{ "slashed-zero", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "slashed-zero" }} },
    .{ "lining-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "lining-nums" }} },
    .{ "oldstyle-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "oldstyle-nums" }} },
    .{ "proportional-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "proportional-nums" }} },
    .{ "tabular-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "tabular-nums" }} },
    .{ "diagonal-fractions", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "diagonal-fractions" }} },
    .{ "stacked-fractions", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "stacked-fractions" }} },

    // ─── Font Smoothing ───
    .{ "antialiased", &[_]Declaration{ .{ .property = "-webkit-font-smoothing", .value = "antialiased" }, .{ .property = "-moz-osx-font-smoothing", .value = "grayscale" } } },
    .{ "subpixel-antialiased", &[_]Declaration{ .{ .property = "-webkit-font-smoothing", .value = "auto" }, .{ .property = "-moz-osx-font-smoothing", .value = "auto" } } },

    // ─── List Style Position ───
    .{ "list-inside", &[_]Declaration{.{ .property = "list-style-position", .value = "inside" }} },
    .{ "list-outside", &[_]Declaration{.{ .property = "list-style-position", .value = "outside" }} },

    // ─── Vertical Align ───
    .{ "align-baseline", &[_]Declaration{.{ .property = "vertical-align", .value = "baseline" }} },
    .{ "align-top", &[_]Declaration{.{ .property = "vertical-align", .value = "top" }} },
    .{ "align-middle", &[_]Declaration{.{ .property = "vertical-align", .value = "middle" }} },
    .{ "align-bottom", &[_]Declaration{.{ .property = "vertical-align", .value = "bottom" }} },
    .{ "align-text-top", &[_]Declaration{.{ .property = "vertical-align", .value = "text-top" }} },
    .{ "align-text-bottom", &[_]Declaration{.{ .property = "vertical-align", .value = "text-bottom" }} },
    .{ "align-sub", &[_]Declaration{.{ .property = "vertical-align", .value = "sub" }} },
    .{ "align-super", &[_]Declaration{.{ .property = "vertical-align", .value = "super" }} },

    // ─── Background Attachment ───
    .{ "bg-fixed", &[_]Declaration{.{ .property = "background-attachment", .value = "fixed" }} },
    .{ "bg-local", &[_]Declaration{.{ .property = "background-attachment", .value = "local" }} },
    .{ "bg-scroll", &[_]Declaration{.{ .property = "background-attachment", .value = "scroll" }} },

    // ─── Background Clip ───
    .{ "bg-clip-border", &[_]Declaration{.{ .property = "background-clip", .value = "border-box" }} },
    .{ "bg-clip-padding", &[_]Declaration{.{ .property = "background-clip", .value = "padding-box" }} },
    .{ "bg-clip-content", &[_]Declaration{.{ .property = "background-clip", .value = "content-box" }} },
    .{ "bg-clip-text", &[_]Declaration{.{ .property = "background-clip", .value = "text" }} },

    // ─── Background Origin ───
    .{ "bg-origin-border", &[_]Declaration{.{ .property = "background-origin", .value = "border-box" }} },
    .{ "bg-origin-padding", &[_]Declaration{.{ .property = "background-origin", .value = "padding-box" }} },
    .{ "bg-origin-content", &[_]Declaration{.{ .property = "background-origin", .value = "content-box" }} },

    // ─── Background Repeat ───
    .{ "bg-repeat", &[_]Declaration{.{ .property = "background-repeat", .value = "repeat" }} },
    .{ "bg-no-repeat", &[_]Declaration{.{ .property = "background-repeat", .value = "no-repeat" }} },
    .{ "bg-repeat-x", &[_]Declaration{.{ .property = "background-repeat", .value = "repeat-x" }} },
    .{ "bg-repeat-y", &[_]Declaration{.{ .property = "background-repeat", .value = "repeat-y" }} },
    .{ "bg-repeat-round", &[_]Declaration{.{ .property = "background-repeat", .value = "round" }} },
    .{ "bg-repeat-space", &[_]Declaration{.{ .property = "background-repeat", .value = "space" }} },

    // ─── Background Size ───
    .{ "bg-auto", &[_]Declaration{.{ .property = "background-size", .value = "auto" }} },
    .{ "bg-cover", &[_]Declaration{.{ .property = "background-size", .value = "cover" }} },
    .{ "bg-contain", &[_]Declaration{.{ .property = "background-size", .value = "contain" }} },

    // ─── Background Position ───
    .{ "bg-center", &[_]Declaration{.{ .property = "background-position", .value = "center" }} },
    .{ "bg-top", &[_]Declaration{.{ .property = "background-position", .value = "top" }} },
    .{ "bg-right-top", &[_]Declaration{.{ .property = "background-position", .value = "right top" }} },
    .{ "bg-right", &[_]Declaration{.{ .property = "background-position", .value = "right" }} },
    .{ "bg-right-bottom", &[_]Declaration{.{ .property = "background-position", .value = "right bottom" }} },
    .{ "bg-bottom", &[_]Declaration{.{ .property = "background-position", .value = "bottom" }} },
    .{ "bg-left-bottom", &[_]Declaration{.{ .property = "background-position", .value = "left bottom" }} },
    .{ "bg-left", &[_]Declaration{.{ .property = "background-position", .value = "left" }} },
    .{ "bg-left-top", &[_]Declaration{.{ .property = "background-position", .value = "left top" }} },

    // ─── Border Style ───
    .{ "border-solid", &[_]Declaration{.{ .property = "border-style", .value = "solid" }} },
    .{ "border-dashed", &[_]Declaration{.{ .property = "border-style", .value = "dashed" }} },
    .{ "border-dotted", &[_]Declaration{.{ .property = "border-style", .value = "dotted" }} },
    .{ "border-double", &[_]Declaration{.{ .property = "border-style", .value = "double" }} },
    .{ "border-hidden", &[_]Declaration{.{ .property = "border-style", .value = "hidden" }} },
    .{ "border-none", &[_]Declaration{.{ .property = "border-style", .value = "none" }} },

    // ─── Outline Style ───
    .{ "outline-none", &[_]Declaration{ .{ .property = "outline", .value = "2px solid transparent" }, .{ .property = "outline-offset", .value = "2px" } } },
    .{ "outline", &[_]Declaration{.{ .property = "outline-style", .value = "solid" }} },
    .{ "outline-dashed", &[_]Declaration{.{ .property = "outline-style", .value = "dashed" }} },
    .{ "outline-dotted", &[_]Declaration{.{ .property = "outline-style", .value = "dotted" }} },
    .{ "outline-double", &[_]Declaration{.{ .property = "outline-style", .value = "double" }} },

    // ─── Mix Blend Mode ───
    .{ "mix-blend-normal", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "normal" }} },
    .{ "mix-blend-multiply", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "multiply" }} },
    .{ "mix-blend-screen", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "screen" }} },
    .{ "mix-blend-overlay", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "overlay" }} },
    .{ "mix-blend-darken", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "darken" }} },
    .{ "mix-blend-lighten", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "lighten" }} },
    .{ "mix-blend-color-dodge", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "color-dodge" }} },
    .{ "mix-blend-color-burn", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "color-burn" }} },
    .{ "mix-blend-hard-light", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "hard-light" }} },
    .{ "mix-blend-soft-light", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "soft-light" }} },
    .{ "mix-blend-difference", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "difference" }} },
    .{ "mix-blend-exclusion", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "exclusion" }} },
    .{ "mix-blend-hue", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "hue" }} },
    .{ "mix-blend-saturation", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "saturation" }} },
    .{ "mix-blend-color", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "color" }} },
    .{ "mix-blend-luminosity", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "luminosity" }} },
    .{ "mix-blend-plus-darker", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "plus-darker" }} },
    .{ "mix-blend-plus-lighter", &[_]Declaration{.{ .property = "mix-blend-mode", .value = "plus-lighter" }} },

    // ─── Background Blend Mode ───
    .{ "bg-blend-normal", &[_]Declaration{.{ .property = "background-blend-mode", .value = "normal" }} },
    .{ "bg-blend-multiply", &[_]Declaration{.{ .property = "background-blend-mode", .value = "multiply" }} },
    .{ "bg-blend-screen", &[_]Declaration{.{ .property = "background-blend-mode", .value = "screen" }} },
    .{ "bg-blend-overlay", &[_]Declaration{.{ .property = "background-blend-mode", .value = "overlay" }} },
    .{ "bg-blend-darken", &[_]Declaration{.{ .property = "background-blend-mode", .value = "darken" }} },
    .{ "bg-blend-lighten", &[_]Declaration{.{ .property = "background-blend-mode", .value = "lighten" }} },
    .{ "bg-blend-color-dodge", &[_]Declaration{.{ .property = "background-blend-mode", .value = "color-dodge" }} },
    .{ "bg-blend-color-burn", &[_]Declaration{.{ .property = "background-blend-mode", .value = "color-burn" }} },
    .{ "bg-blend-hard-light", &[_]Declaration{.{ .property = "background-blend-mode", .value = "hard-light" }} },
    .{ "bg-blend-soft-light", &[_]Declaration{.{ .property = "background-blend-mode", .value = "soft-light" }} },
    .{ "bg-blend-difference", &[_]Declaration{.{ .property = "background-blend-mode", .value = "difference" }} },
    .{ "bg-blend-exclusion", &[_]Declaration{.{ .property = "background-blend-mode", .value = "exclusion" }} },
    .{ "bg-blend-hue", &[_]Declaration{.{ .property = "background-blend-mode", .value = "hue" }} },
    .{ "bg-blend-saturation", &[_]Declaration{.{ .property = "background-blend-mode", .value = "saturation" }} },
    .{ "bg-blend-color", &[_]Declaration{.{ .property = "background-blend-mode", .value = "color" }} },
    .{ "bg-blend-luminosity", &[_]Declaration{.{ .property = "background-blend-mode", .value = "luminosity" }} },

    // ─── Table Layout ───
    .{ "table-auto", &[_]Declaration{.{ .property = "table-layout", .value = "auto" }} },
    .{ "table-fixed", &[_]Declaration{.{ .property = "table-layout", .value = "fixed" }} },

    // ─── Caption Side ───
    .{ "caption-top", &[_]Declaration{.{ .property = "caption-side", .value = "top" }} },
    .{ "caption-bottom", &[_]Declaration{.{ .property = "caption-side", .value = "bottom" }} },

    // ─── Border Collapse ───
    .{ "border-collapse", &[_]Declaration{.{ .property = "border-collapse", .value = "collapse" }} },
    .{ "border-separate", &[_]Declaration{.{ .property = "border-collapse", .value = "separate" }} },

    // ─── Transition ───
    .{ "transition-none", &[_]Declaration{.{ .property = "transition-property", .value = "none" }} },
    .{ "transition-all", &[_]Declaration{
        .{ .property = "transition-property", .value = "all" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition", &[_]Declaration{
        .{ .property = "transition-property", .value = "color, background-color, border-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to, opacity, box-shadow, transform, translate, scale, rotate, filter, -webkit-backdrop-filter, backdrop-filter" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition-colors", &[_]Declaration{
        .{ .property = "transition-property", .value = "color, background-color, border-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition-opacity", &[_]Declaration{
        .{ .property = "transition-property", .value = "opacity" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition-shadow", &[_]Declaration{
        .{ .property = "transition-property", .value = "box-shadow" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition-transform", &[_]Declaration{
        .{ .property = "transition-property", .value = "transform, translate, scale, rotate" },
        .{ .property = "transition-timing-function", .value = "var(--default-transition-timing-function)" },
        .{ .property = "transition-duration", .value = "var(--default-transition-duration)" },
    } },
    .{ "transition-discrete", &[_]Declaration{.{ .property = "transition-behavior", .value = "allow-discrete" }} },
    .{ "transition-normal", &[_]Declaration{.{ .property = "transition-behavior", .value = "normal" }} },

    // ─── Will Change ───
    .{ "will-change-auto", &[_]Declaration{.{ .property = "will-change", .value = "auto" }} },
    .{ "will-change-scroll", &[_]Declaration{.{ .property = "will-change", .value = "scroll-position" }} },
    .{ "will-change-contents", &[_]Declaration{.{ .property = "will-change", .value = "contents" }} },
    .{ "will-change-transform", &[_]Declaration{.{ .property = "will-change", .value = "transform" }} },

    // ─── Contain ───
    .{ "contain-none", &[_]Declaration{.{ .property = "contain", .value = "none" }} },
    .{ "contain-content", &[_]Declaration{.{ .property = "contain", .value = "content" }} },
    .{ "contain-strict", &[_]Declaration{.{ .property = "contain", .value = "strict" }} },

    // ─── Forced Color Adjust ───
    .{ "forced-color-adjust-auto", &[_]Declaration{.{ .property = "forced-color-adjust", .value = "auto" }} },
    .{ "forced-color-adjust-none", &[_]Declaration{.{ .property = "forced-color-adjust", .value = "none" }} },

    // ─── SR Only ───
    .{ "sr-only", &[_]Declaration{
        .{ .property = "position", .value = "absolute" },
        .{ .property = "width", .value = "1px" },
        .{ .property = "height", .value = "1px" },
        .{ .property = "padding", .value = "0" },
        .{ .property = "margin", .value = "-1px" },
        .{ .property = "overflow", .value = "hidden" },
        .{ .property = "clip", .value = "rect(0,0,0,0)" },
        .{ .property = "white-space", .value = "nowrap" },
        .{ .property = "border-width", .value = "0" },
    } },
    .{ "not-sr-only", &[_]Declaration{
        .{ .property = "position", .value = "static" },
        .{ .property = "width", .value = "auto" },
        .{ .property = "height", .value = "auto" },
        .{ .property = "padding", .value = "0" },
        .{ .property = "margin", .value = "0" },
        .{ .property = "overflow", .value = "visible" },
        .{ .property = "clip", .value = "auto" },
        .{ .property = "white-space", .value = "normal" },
    } },

    // ─── Field Sizing ───
    .{ "field-sizing-content", &[_]Declaration{.{ .property = "field-sizing", .value = "content" }} },
    .{ "field-sizing-fixed", &[_]Declaration{.{ .property = "field-sizing", .value = "fixed" }} },

    // ─── Scroll Behavior ───
    .{ "scroll-auto", &[_]Declaration{.{ .property = "scroll-behavior", .value = "auto" }} },
    .{ "scroll-smooth", &[_]Declaration{.{ .property = "scroll-behavior", .value = "smooth" }} },

    // ─── Scroll Snap Type ───
    .{ "snap-none", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "none" }} },
    .{ "snap-x", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "x var(--tw-scroll-snap-strictness, proximity)" }} },
    .{ "snap-y", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "y var(--tw-scroll-snap-strictness, proximity)" }} },
    .{ "snap-both", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "both var(--tw-scroll-snap-strictness, proximity)" }} },
    .{ "snap-mandatory", &[_]Declaration{.{ .property = "--tw-scroll-snap-strictness", .value = "mandatory" }} },
    .{ "snap-proximity", &[_]Declaration{.{ .property = "--tw-scroll-snap-strictness", .value = "proximity" }} },

    // ─── Scroll Snap Align ───
    .{ "snap-start", &[_]Declaration{.{ .property = "scroll-snap-align", .value = "start" }} },
    .{ "snap-end", &[_]Declaration{.{ .property = "scroll-snap-align", .value = "end" }} },
    .{ "snap-center", &[_]Declaration{.{ .property = "scroll-snap-align", .value = "center" }} },
    .{ "snap-align-none", &[_]Declaration{.{ .property = "scroll-snap-align", .value = "none" }} },

    // ─── Scroll Snap Stop ───
    .{ "snap-normal", &[_]Declaration{.{ .property = "scroll-snap-stop", .value = "normal" }} },
    .{ "snap-always", &[_]Declaration{.{ .property = "scroll-snap-stop", .value = "always" }} },

    // ─── Max Width/Height Keywords ───
    .{ "max-w-prose", &[_]Declaration{.{ .property = "max-width", .value = "65ch" }} },
    .{ "max-w-none", &[_]Declaration{.{ .property = "max-width", .value = "none" }} },
    .{ "max-h-none", &[_]Declaration{.{ .property = "max-height", .value = "none" }} },

    // ─── Columns ───
    .{ "columns-auto", &[_]Declaration{.{ .property = "columns", .value = "auto" }} },

    // ─── Break ───
    .{ "break-after-auto", &[_]Declaration{.{ .property = "break-after", .value = "auto" }} },
    .{ "break-after-avoid", &[_]Declaration{.{ .property = "break-after", .value = "avoid" }} },
    .{ "break-after-all", &[_]Declaration{.{ .property = "break-after", .value = "all" }} },
    .{ "break-after-avoid-page", &[_]Declaration{.{ .property = "break-after", .value = "avoid-page" }} },
    .{ "break-after-page", &[_]Declaration{.{ .property = "break-after", .value = "page" }} },
    .{ "break-after-left", &[_]Declaration{.{ .property = "break-after", .value = "left" }} },
    .{ "break-after-right", &[_]Declaration{.{ .property = "break-after", .value = "right" }} },
    .{ "break-after-column", &[_]Declaration{.{ .property = "break-after", .value = "column" }} },
    .{ "break-before-auto", &[_]Declaration{.{ .property = "break-before", .value = "auto" }} },
    .{ "break-before-avoid", &[_]Declaration{.{ .property = "break-before", .value = "avoid" }} },
    .{ "break-before-all", &[_]Declaration{.{ .property = "break-before", .value = "all" }} },
    .{ "break-before-avoid-page", &[_]Declaration{.{ .property = "break-before", .value = "avoid-page" }} },
    .{ "break-before-page", &[_]Declaration{.{ .property = "break-before", .value = "page" }} },
    .{ "break-before-left", &[_]Declaration{.{ .property = "break-before", .value = "left" }} },
    .{ "break-before-right", &[_]Declaration{.{ .property = "break-before", .value = "right" }} },
    .{ "break-before-column", &[_]Declaration{.{ .property = "break-before", .value = "column" }} },
    .{ "break-inside-auto", &[_]Declaration{.{ .property = "break-inside", .value = "auto" }} },
    .{ "break-inside-avoid", &[_]Declaration{.{ .property = "break-inside", .value = "avoid" }} },
    .{ "break-inside-avoid-page", &[_]Declaration{.{ .property = "break-inside", .value = "avoid-page" }} },
    .{ "break-inside-avoid-column", &[_]Declaration{.{ .property = "break-inside", .value = "avoid-column" }} },

    // ─── Box Decoration Break ───
    .{ "box-decoration-clone", &[_]Declaration{.{ .property = "box-decoration-break", .value = "clone" }} },
    .{ "box-decoration-slice", &[_]Declaration{.{ .property = "box-decoration-break", .value = "slice" }} },

    // ─── Content Visibility ───
    .{ "content-visibility-auto", &[_]Declaration{.{ .property = "content-visibility", .value = "auto" }} },
    .{ "content-visibility-hidden", &[_]Declaration{.{ .property = "content-visibility", .value = "hidden" }} },
    .{ "content-visibility-visible", &[_]Declaration{.{ .property = "content-visibility", .value = "visible" }} },

    // ─── Color Scheme ───
    .{ "scheme-normal", &[_]Declaration{.{ .property = "color-scheme", .value = "normal" }} },
    .{ "scheme-dark", &[_]Declaration{.{ .property = "color-scheme", .value = "dark" }} },
    .{ "scheme-light", &[_]Declaration{.{ .property = "color-scheme", .value = "light" }} },
    .{ "scheme-light-dark", &[_]Declaration{.{ .property = "color-scheme", .value = "light dark" }} },
    .{ "scheme-dark-light", &[_]Declaration{.{ .property = "color-scheme", .value = "dark light" }} },

    // ─── Container ───
    .{ "container", &[_]Declaration{ .{ .property = "width", .value = "100%" }, .{ .property = "max-width", .value = "100%" } } },

    // ─── Inset Auto ───
    .{ "inset-auto", &[_]Declaration{.{ .property = "inset", .value = "auto" }} },
    .{ "inset-x-auto", &[_]Declaration{.{ .property = "inset-inline", .value = "auto" }} },
    .{ "inset-y-auto", &[_]Declaration{.{ .property = "inset-block", .value = "auto" }} },
    .{ "inset-s-auto", &[_]Declaration{.{ .property = "inset-inline-start", .value = "auto" }} },
    .{ "inset-e-auto", &[_]Declaration{.{ .property = "inset-inline-end", .value = "auto" }} },
    .{ "top-auto", &[_]Declaration{.{ .property = "top", .value = "auto" }} },
    .{ "right-auto", &[_]Declaration{.{ .property = "right", .value = "auto" }} },
    .{ "bottom-auto", &[_]Declaration{.{ .property = "bottom", .value = "auto" }} },
    .{ "left-auto", &[_]Declaration{.{ .property = "left", .value = "auto" }} },

    // ─── Transform ───
    .{ "scale-none", &[_]Declaration{.{ .property = "scale", .value = "none" }} },
    .{ "rotate-none", &[_]Declaration{.{ .property = "rotate", .value = "none" }} },
    .{ "transform-none", &[_]Declaration{.{ .property = "transform", .value = "none" }} },
    .{ "transform-cpu", &[_]Declaration{.{ .property = "will-change", .value = "auto" }} },
    .{ "transform-gpu", &[_]Declaration{.{ .property = "will-change", .value = "transform" }} },
    .{ "transform-flat", &[_]Declaration{.{ .property = "transform-style", .value = "flat" }} },
    .{ "transform-3d", &[_]Declaration{.{ .property = "transform-style", .value = "preserve-3d" }} },
    .{ "backface-hidden", &[_]Declaration{.{ .property = "backface-visibility", .value = "hidden" }} },
    .{ "backface-visible", &[_]Declaration{.{ .property = "backface-visibility", .value = "visible" }} },

    // ─── Background Image ───
    .{ "bg-none", &[_]Declaration{.{ .property = "background-image", .value = "none" }} },

    // ─── Accent / Decoration ───
    .{ "accent-auto", &[_]Declaration{.{ .property = "accent-color", .value = "auto" }} },
    .{ "decoration-auto", &[_]Declaration{.{ .property = "text-decoration-thickness", .value = "auto" }} },
    .{ "decoration-from-font", &[_]Declaration{.{ .property = "text-decoration-thickness", .value = "from-font" }} },

    // ─── Shadow ───
    .{ "shadow-initial", &[_]Declaration{.{ .property = "box-shadow", .value = "var(--tw-shadow)" }} },
    .{ "shadow-inner", &[_]Declaration{.{ .property = "box-shadow", .value = "inset 0 2px 4px 0 rgb(0 0 0 / 0.05)" }} },
    .{ "inset-shadow-none", &[_]Declaration{.{ .property = "box-shadow", .value = "0 0 #0000" }} },
    .{ "inset-shadow-initial", &[_]Declaration{.{ .property = "box-shadow", .value = "var(--tw-inset-shadow)" }} },
    .{ "text-shadow-none", &[_]Declaration{.{ .property = "text-shadow", .value = "none" }} },
    .{ "text-shadow-initial", &[_]Declaration{.{ .property = "text-shadow", .value = "var(--tw-text-shadow)" }} },
    .{ "ring-inset", &[_]Declaration{.{ .property = "--tw-ring-inset", .value = "inset" }} },

    // ─── Outline ───
    .{ "outline-hidden", &[_]Declaration{.{ .property = "outline-color", .value = "transparent" }} },

    // ─── Divide Style ───
    .{ "divide-solid", &[_]Declaration{.{ .property = "border-style", .value = "solid" }} },
    .{ "divide-dashed", &[_]Declaration{.{ .property = "border-style", .value = "dashed" }} },
    .{ "divide-dotted", &[_]Declaration{.{ .property = "border-style", .value = "dotted" }} },
    .{ "divide-double", &[_]Declaration{.{ .property = "border-style", .value = "double" }} },
    .{ "divide-none", &[_]Declaration{.{ .property = "border-style", .value = "none" }} },

    // ─── Display (additional) ───
    .{ "inline-table", &[_]Declaration{.{ .property = "display", .value = "inline-table" }} },

    // ─── Font Stretch ───
    .{ "font-stretch-normal", &[_]Declaration{.{ .property = "font-stretch", .value = "normal" }} },
    .{ "font-stretch-ultra-condensed", &[_]Declaration{.{ .property = "font-stretch", .value = "ultra-condensed" }} },
    .{ "font-stretch-extra-condensed", &[_]Declaration{.{ .property = "font-stretch", .value = "extra-condensed" }} },
    .{ "font-stretch-condensed", &[_]Declaration{.{ .property = "font-stretch", .value = "condensed" }} },
    .{ "font-stretch-semi-condensed", &[_]Declaration{.{ .property = "font-stretch", .value = "semi-condensed" }} },
    .{ "font-stretch-semi-expanded", &[_]Declaration{.{ .property = "font-stretch", .value = "semi-expanded" }} },
    .{ "font-stretch-expanded", &[_]Declaration{.{ .property = "font-stretch", .value = "expanded" }} },
    .{ "font-stretch-extra-expanded", &[_]Declaration{.{ .property = "font-stretch", .value = "extra-expanded" }} },
    .{ "font-stretch-ultra-expanded", &[_]Declaration{.{ .property = "font-stretch", .value = "ultra-expanded" }} },

    // ─── Space Between Reverse ───
    .{ "space-x-reverse", &[_]Declaration{.{ .property = "--tw-space-x-reverse", .value = "1" }} },
    .{ "space-y-reverse", &[_]Declaration{.{ .property = "--tw-space-y-reverse", .value = "1" }} },

    // ─── Divide Reverse ───
    .{ "divide-x-reverse", &[_]Declaration{.{ .property = "--tw-divide-x-reverse", .value = "1" }} },
    .{ "divide-y-reverse", &[_]Declaration{.{ .property = "--tw-divide-y-reverse", .value = "1" }} },

    // ─── Object Position ───
    .{ "object-bottom", &[_]Declaration{.{ .property = "object-position", .value = "bottom" }} },
    .{ "object-center", &[_]Declaration{.{ .property = "object-position", .value = "center" }} },
    .{ "object-left", &[_]Declaration{.{ .property = "object-position", .value = "left" }} },
    .{ "object-left-bottom", &[_]Declaration{.{ .property = "object-position", .value = "left bottom" }} },
    .{ "object-left-top", &[_]Declaration{.{ .property = "object-position", .value = "left top" }} },
    .{ "object-right", &[_]Declaration{.{ .property = "object-position", .value = "right" }} },
    .{ "object-right-bottom", &[_]Declaration{.{ .property = "object-position", .value = "right bottom" }} },
    .{ "object-right-top", &[_]Declaration{.{ .property = "object-position", .value = "right top" }} },
    .{ "object-top", &[_]Declaration{.{ .property = "object-position", .value = "top" }} },
});

// ─── Functional Utility Set ────────────────────────────────────────────────

pub const functional_utility_set = std.StaticStringMap(void).initComptime(.{
    // Spacing
    .{ "p", {} },
    .{ "px", {} },
    .{ "py", {} },
    .{ "ps", {} },
    .{ "pe", {} },
    .{ "pt", {} },
    .{ "pr", {} },
    .{ "pb", {} },
    .{ "pl", {} },
    .{ "m", {} },
    .{ "mx", {} },
    .{ "my", {} },
    .{ "ms", {} },
    .{ "me", {} },
    .{ "mt", {} },
    .{ "mr", {} },
    .{ "mb", {} },
    .{ "ml", {} },
    .{ "-m", {} },
    .{ "-mx", {} },
    .{ "-my", {} },
    .{ "-ms", {} },
    .{ "-me", {} },
    .{ "-mt", {} },
    .{ "-mr", {} },
    .{ "-mb", {} },
    .{ "-ml", {} },
    // Sizing
    .{ "w", {} },
    .{ "h", {} },
    .{ "min-w", {} },
    .{ "min-h", {} },
    .{ "max-w", {} },
    .{ "max-h", {} },
    .{ "size", {} },
    // Inset
    .{ "inset", {} },
    .{ "inset-x", {} },
    .{ "inset-y", {} },
    .{ "inset-s", {} },
    .{ "inset-e", {} },
    .{ "top", {} },
    .{ "right", {} },
    .{ "bottom", {} },
    .{ "left", {} },
    .{ "-inset", {} },
    .{ "-inset-x", {} },
    .{ "-inset-y", {} },
    .{ "-inset-s", {} },
    .{ "-inset-e", {} },
    .{ "-top", {} },
    .{ "-right", {} },
    .{ "-bottom", {} },
    .{ "-left", {} },
    // Gap
    .{ "gap", {} },
    .{ "gap-x", {} },
    .{ "gap-y", {} },
    // Colors
    .{ "bg", {} },
    .{ "text", {} },
    .{ "border", {} },
    .{ "accent", {} },
    .{ "caret", {} },
    .{ "fill", {} },
    .{ "stroke", {} },
    .{ "outline-color", {} },
    .{ "decoration", {} },
    .{ "shadow-color", {} },
    .{ "divide", {} },
    .{ "ring", {} },
    .{ "placeholder", {} },
    // Typography
    .{ "font", {} },
    .{ "text-size", {} },
    .{ "leading", {} },
    .{ "tracking", {} },
    .{ "font-weight", {} },
    // Border
    .{ "rounded", {} },
    .{ "rounded-t", {} },
    .{ "rounded-r", {} },
    .{ "rounded-b", {} },
    .{ "rounded-l", {} },
    .{ "rounded-tl", {} },
    .{ "rounded-tr", {} },
    .{ "rounded-br", {} },
    .{ "rounded-bl", {} },
    .{ "rounded-s", {} },
    .{ "rounded-e", {} },
    .{ "rounded-ss", {} },
    .{ "rounded-se", {} },
    .{ "rounded-es", {} },
    .{ "rounded-ee", {} },
    .{ "border-x", {} },
    .{ "border-y", {} },
    .{ "border-s", {} },
    .{ "border-e", {} },
    .{ "border-t", {} },
    .{ "border-r", {} },
    .{ "border-b", {} },
    .{ "border-l", {} },
    // Effects
    .{ "opacity", {} },
    .{ "shadow", {} },
    .{ "inset-shadow", {} },
    .{ "drop-shadow", {} },
    .{ "blur", {} },
    .{ "brightness", {} },
    .{ "contrast", {} },
    .{ "grayscale", {} },
    .{ "hue-rotate", {} },
    .{ "invert", {} },
    .{ "saturate", {} },
    .{ "sepia", {} },
    .{ "backdrop-blur", {} },
    .{ "backdrop-brightness", {} },
    .{ "backdrop-contrast", {} },
    .{ "backdrop-grayscale", {} },
    .{ "backdrop-hue-rotate", {} },
    .{ "backdrop-invert", {} },
    .{ "backdrop-opacity", {} },
    .{ "backdrop-saturate", {} },
    .{ "backdrop-sepia", {} },
    // Transform
    .{ "rotate", {} },
    .{ "-rotate", {} },
    .{ "scale", {} },
    .{ "scale-x", {} },
    .{ "scale-y", {} },
    .{ "translate-x", {} },
    .{ "translate-y", {} },
    .{ "-translate-x", {} },
    .{ "-translate-y", {} },
    .{ "skew-x", {} },
    .{ "skew-y", {} },
    .{ "-skew-x", {} },
    .{ "-skew-y", {} },
    // Transition
    .{ "duration", {} },
    .{ "delay", {} },
    .{ "ease", {} },
    // Grid
    .{ "cols", {} },
    .{ "rows", {} },
    .{ "grid-cols", {} },
    .{ "grid-rows", {} },
    .{ "col", {} },
    .{ "col-start", {} },
    .{ "col-end", {} },
    .{ "row", {} },
    .{ "row-start", {} },
    .{ "row-end", {} },
    .{ "auto-cols", {} },
    .{ "auto-rows", {} },
    // Z-Index
    .{ "z", {} },
    .{ "-z", {} },
    // Order
    .{ "order", {} },
    .{ "-order", {} },
    // Aspect Ratio
    .{ "aspect", {} },
    // Flex Basis
    .{ "basis", {} },
    // Columns
    .{ "columns", {} },
    // Object Position
    .{ "object", {} },
    // Origin
    .{ "origin", {} },
    // Animation
    .{ "animate", {} },
    // Perspective
    .{ "perspective", {} },
    // Ring
    .{ "ring-offset", {} },
    // Content
    .{ "content", {} },
    // List Style Type
    .{ "list", {} },
    // Outline
    .{ "outline", {} },
    .{ "outline-offset", {} },
    // Scroll
    .{ "scroll-m", {} },
    .{ "scroll-mx", {} },
    .{ "scroll-my", {} },
    .{ "scroll-ms", {} },
    .{ "scroll-me", {} },
    .{ "scroll-mt", {} },
    .{ "scroll-mr", {} },
    .{ "scroll-mb", {} },
    .{ "scroll-ml", {} },
    .{ "scroll-p", {} },
    .{ "scroll-px", {} },
    .{ "scroll-py", {} },
    .{ "scroll-ps", {} },
    .{ "scroll-pe", {} },
    .{ "scroll-pt", {} },
    .{ "scroll-pr", {} },
    .{ "scroll-pb", {} },
    .{ "scroll-pl", {} },
    // Space between
    .{ "space-x", {} },
    .{ "space-y", {} },
    // Divide
    .{ "divide-x", {} },
    .{ "divide-y", {} },
    // Grow/Shrink with values
    .{ "grow", {} },
    .{ "shrink", {} },
    // Line clamp
    .{ "line-clamp", {} },
    // Gradient color stops
    .{ "from", {} },
    .{ "via", {} },
    .{ "to", {} },
    .{ "bg-linear", {} },
    .{ "bg-radial", {} },
    .{ "bg-conic", {} },
    .{ "bg-gradient", {} },
    // Grid span
    .{ "col-span", {} },
    .{ "row-span", {} },
    // Underline offset
    .{ "underline-offset", {} },
    // Container query @ prefix
    .{ "@", {} },
    // Inset ring
    .{ "inset-ring", {} },
    // Text shadow
    .{ "text-shadow", {} },
    // Negative gradient direction
    .{ "-bg-linear", {} },
    .{ "-bg-conic", {} },
    // Mask utilities
    .{ "mask-image", {} },
    .{ "mask-position", {} },
    .{ "mask-size", {} },
    .{ "mask-repeat", {} },
    .{ "mask-type", {} },
    // List image
    .{ "list-image", {} },
    // Background size/position (functional)
    .{ "bg-size", {} },
    .{ "bg-position", {} },
    // Font stretch (functional)
    .{ "font-stretch", {} },
    // Border spacing
    .{ "border-spacing", {} },
    .{ "border-spacing-x", {} },
    .{ "border-spacing-y", {} },
    // Text indent
    .{ "indent", {} },
    .{ "-indent", {} },
});

// ─── @property Registration ────────────────────────────────────────────────

/// Return any @property declarations needed for a given utility root.
pub fn getRequiredProperties(root: []const u8) []const AtProperty {
    // shadow utilities
    if (std.mem.eql(u8, root, "shadow")) {
        return &[_]AtProperty{
            .{ .name = "--tw-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
            .{ .name = "--tw-shadow-color", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-shadow-alpha", .syntax = "<percentage>", .inherits = false, .initial_value = "100%" },
        };
    }
    // ring utilities
    if (std.mem.eql(u8, root, "ring")) {
        return &[_]AtProperty{
            .{ .name = "--tw-ring-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
            .{ .name = "--tw-ring-color", .syntax = "*", .inherits = false, .initial_value = "currentColor" },
        };
    }
    // translate
    if (std.mem.eql(u8, root, "translate-x") or std.mem.eql(u8, root, "translate-y") or
        std.mem.eql(u8, root, "-translate-x") or std.mem.eql(u8, root, "-translate-y"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-translate-x", .syntax = "*", .inherits = false, .initial_value = "0" },
            .{ .name = "--tw-translate-y", .syntax = "*", .inherits = false, .initial_value = "0" },
        };
    }
    // scale
    if (std.mem.eql(u8, root, "scale") or std.mem.eql(u8, root, "scale-x") or std.mem.eql(u8, root, "scale-y")) {
        return &[_]AtProperty{
            .{ .name = "--tw-scale-x", .syntax = "*", .inherits = false, .initial_value = "1" },
            .{ .name = "--tw-scale-y", .syntax = "*", .inherits = false, .initial_value = "1" },
        };
    }
    // before/after content
    if (std.mem.eql(u8, root, "content")) {
        return &[_]AtProperty{
            .{ .name = "--tw-content", .syntax = "*", .inherits = false, .initial_value = "\"\"" },
        };
    }
    // inset-shadow
    if (std.mem.eql(u8, root, "inset-shadow")) {
        return &[_]AtProperty{
            .{ .name = "--tw-inset-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
        };
    }
    // inset-ring
    if (std.mem.eql(u8, root, "inset-ring")) {
        return &[_]AtProperty{
            .{ .name = "--tw-inset-ring-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
            .{ .name = "--tw-inset-ring-color", .syntax = "*", .inherits = false, .initial_value = "currentColor" },
        };
    }
    // ring-offset
    if (std.mem.eql(u8, root, "ring-offset")) {
        return &[_]AtProperty{
            .{ .name = "--tw-ring-offset-width", .syntax = "*", .inherits = false, .initial_value = "0px" },
            .{ .name = "--tw-ring-offset-color", .syntax = "*", .inherits = false, .initial_value = "#fff" },
        };
    }
    // text-shadow
    if (std.mem.eql(u8, root, "text-shadow")) {
        return &[_]AtProperty{
            .{ .name = "--tw-text-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
        };
    }
    // drop-shadow
    if (std.mem.eql(u8, root, "drop-shadow")) {
        return &[_]AtProperty{
            .{ .name = "--tw-drop-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
        };
    }
    // gradient
    if (std.mem.eql(u8, root, "from") or std.mem.eql(u8, root, "via") or std.mem.eql(u8, root, "to") or
        std.mem.eql(u8, root, "bg-linear") or std.mem.eql(u8, root, "bg-radial") or std.mem.eql(u8, root, "bg-conic") or
        std.mem.eql(u8, root, "bg-gradient"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-gradient-from", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-via", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-to", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-stops", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    return &[_]AtProperty{};
}

// ─── @keyframes Registration ────────────────────────────────────────────────

/// Return any @keyframes declarations needed for a given utility root.
pub fn getRequiredKeyframes(root: []const u8) []const Keyframes {
    // All animate-* utilities need their corresponding keyframes
    if (std.mem.eql(u8, root, "animate")) {
        return &[_]Keyframes{
            .{ .name = "spin", .body = "to{transform:rotate(360deg)}" },
            .{ .name = "ping", .body = "75%,100%{transform:scale(2);opacity:0}" },
            .{ .name = "pulse", .body = "50%{opacity:.5}" },
            .{ .name = "bounce", .body = "0%,100%{transform:translateY(-25%);animation-timing-function:cubic-bezier(.8,0,1,1)}50%{transform:none;animation-timing-function:cubic-bezier(0,0,.2,1)}" },
        };
    }
    return &[_]Keyframes{};
}

// ─── Functional Utility Handlers ───────────────────────────────────────────

/// Resolve a functional utility to CSS declarations.
pub fn resolveFunctional(
    alloc: Allocator,
    root: []const u8,
    value: ?Value,
    modifier: ?Modifier,
    theme: *Theme,
    negative: bool,
) !?[]const Declaration {
    // Spacing utilities
    if (isSpacingUtility(root)) {
        return resolveSpacing(alloc, root, value, theme, negative);
    }

    // Decoration: dual behavior (thickness when numeric, color otherwise)
    if (std.mem.eql(u8, root, "decoration")) {
        if (value) |val| {
            if (val.kind == .named and isPositiveInteger(val.value)) {
                return resolveDecorationThickness(alloc, value);
            }
            if (val.kind == .named and (std.mem.eql(u8, val.value, "auto") or std.mem.eql(u8, val.value, "from-font"))) {
                return resolveDecorationThickness(alloc, value);
            }
        }
        // Fall through to color handling
    }

    // Color utilities (pure color roots)
    if (isColorUtility(root)) {
        return resolveColor(alloc, root, value, modifier, theme);
    }

    // Text: dual behavior (color + font-size)
    if (std.mem.eql(u8, root, "text")) {
        return resolveText(alloc, value, modifier, theme);
    }

    // Border: dual behavior (color + width)
    if (std.mem.eql(u8, root, "border") or
        std.mem.eql(u8, root, "border-x") or
        std.mem.eql(u8, root, "border-y") or
        std.mem.eql(u8, root, "border-s") or
        std.mem.eql(u8, root, "border-e") or
        std.mem.eql(u8, root, "border-t") or
        std.mem.eql(u8, root, "border-r") or
        std.mem.eql(u8, root, "border-b") or
        std.mem.eql(u8, root, "border-l"))
    {
        return resolveBorder(alloc, root, value, modifier, theme);
    }

    // Ring
    if (std.mem.eql(u8, root, "ring")) {
        return resolveRing(alloc, value, modifier, theme);
    }

    // Font (family + weight)
    if (std.mem.eql(u8, root, "font")) {
        return resolveFont(alloc, value, theme);
    }

    // Leading (line-height)
    if (std.mem.eql(u8, root, "leading")) {
        return resolveLeading(alloc, value, theme);
    }

    // Tracking (letter-spacing)
    if (std.mem.eql(u8, root, "tracking")) {
        return resolveTracking(alloc, value, theme);
    }

    // Z-index
    if (std.mem.eql(u8, root, "z") or std.mem.eql(u8, root, "-z")) {
        return resolveZIndex(alloc, value, negative or std.mem.eql(u8, root, "-z"));
    }

    // Opacity
    if (std.mem.eql(u8, root, "opacity")) {
        return resolveOpacity(alloc, value);
    }

    // Order
    if (std.mem.eql(u8, root, "order") or std.mem.eql(u8, root, "-order")) {
        return resolveOrder(alloc, value, negative or std.mem.eql(u8, root, "-order"));
    }

    // Border radius
    if (std.mem.startsWith(u8, root, "rounded")) {
        return resolveRounded(alloc, root, value, theme);
    }

    // Duration
    if (std.mem.eql(u8, root, "duration")) {
        return resolveDuration(alloc, value);
    }

    // Delay
    if (std.mem.eql(u8, root, "delay")) {
        return resolveDelay(alloc, value);
    }

    // Aspect ratio
    if (std.mem.eql(u8, root, "aspect")) {
        return resolveAspect(alloc, value, theme);
    }

    // Grid template columns/rows
    if (std.mem.eql(u8, root, "cols") or std.mem.eql(u8, root, "grid-cols")) {
        return resolveGridTemplate(alloc, value, "grid-template-columns");
    }
    if (std.mem.eql(u8, root, "rows") or std.mem.eql(u8, root, "grid-rows")) {
        return resolveGridTemplate(alloc, value, "grid-template-rows");
    }

    // Grid column/row placement
    if (std.mem.eql(u8, root, "col")) {
        return resolveGridPlacement(alloc, value, "grid-column");
    }
    if (std.mem.eql(u8, root, "col-span")) {
        return resolveGridSpan(alloc, value, "grid-column");
    }
    if (std.mem.eql(u8, root, "col-start")) {
        return resolveGridStartEnd(alloc, value, "grid-column-start");
    }
    if (std.mem.eql(u8, root, "col-end")) {
        return resolveGridStartEnd(alloc, value, "grid-column-end");
    }
    if (std.mem.eql(u8, root, "row")) {
        return resolveGridPlacement(alloc, value, "grid-row");
    }
    if (std.mem.eql(u8, root, "row-span")) {
        return resolveGridSpan(alloc, value, "grid-row");
    }
    if (std.mem.eql(u8, root, "row-start")) {
        return resolveGridStartEnd(alloc, value, "grid-row-start");
    }
    if (std.mem.eql(u8, root, "row-end")) {
        return resolveGridStartEnd(alloc, value, "grid-row-end");
    }

    // Grid auto columns/rows
    if (std.mem.eql(u8, root, "auto-cols")) {
        return resolveGridAuto(alloc, value, "grid-auto-columns");
    }
    if (std.mem.eql(u8, root, "auto-rows")) {
        return resolveGridAuto(alloc, value, "grid-auto-rows");
    }

    // Transform: rotate
    if (std.mem.eql(u8, root, "rotate") or std.mem.eql(u8, root, "-rotate")) {
        return resolveRotate(alloc, value, negative or std.mem.eql(u8, root, "-rotate"));
    }

    // Transform: scale
    if (std.mem.eql(u8, root, "scale") or std.mem.eql(u8, root, "scale-x") or std.mem.eql(u8, root, "scale-y")) {
        return resolveScale(alloc, value);
    }

    // Transform: translate
    if (std.mem.eql(u8, root, "translate-x") or std.mem.eql(u8, root, "-translate-x")) {
        return resolveTranslate(alloc, value, "X", negative or std.mem.eql(u8, root, "-translate-x"), theme);
    }
    if (std.mem.eql(u8, root, "translate-y") or std.mem.eql(u8, root, "-translate-y")) {
        return resolveTranslate(alloc, value, "Y", negative or std.mem.eql(u8, root, "-translate-y"), theme);
    }

    // Transform: skew
    if (std.mem.eql(u8, root, "skew-x") or std.mem.eql(u8, root, "-skew-x")) {
        return resolveSkew(alloc, value, "X", negative or std.mem.eql(u8, root, "-skew-x"));
    }
    if (std.mem.eql(u8, root, "skew-y") or std.mem.eql(u8, root, "-skew-y")) {
        return resolveSkew(alloc, value, "Y", negative or std.mem.eql(u8, root, "-skew-y"));
    }

    // Shadow (size or color)
    if (std.mem.eql(u8, root, "shadow")) {
        // Try as shadow size first, then as shadow color
        if (value) |val| {
            if (val.kind == .named) {
                // Check if it's a color
                if (std.mem.eql(u8, val.value, "inherit") or
                    std.mem.eql(u8, val.value, "transparent") or
                    std.mem.eql(u8, val.value, "current") or
                    theme.resolve(val.value, "--color") != null)
                {
                    return resolveShadowColor(alloc, value, modifier, theme);
                }
            }
        }
        return resolveShadow(alloc, value, theme);
    }

    // Filter utilities
    if (std.mem.eql(u8, root, "blur")) {
        return resolveFilter(alloc, value, "filter", "blur", "--blur", theme);
    }
    if (std.mem.eql(u8, root, "brightness")) {
        return resolveFilterPercent(alloc, value, "filter", "brightness");
    }
    if (std.mem.eql(u8, root, "contrast")) {
        return resolveFilterPercent(alloc, value, "filter", "contrast");
    }
    if (std.mem.eql(u8, root, "grayscale")) {
        return resolveFilterToggle(alloc, value, "filter", "grayscale");
    }
    if (std.mem.eql(u8, root, "invert")) {
        return resolveFilterToggle(alloc, value, "filter", "invert");
    }
    if (std.mem.eql(u8, root, "sepia")) {
        return resolveFilterToggle(alloc, value, "filter", "sepia");
    }
    if (std.mem.eql(u8, root, "saturate")) {
        return resolveFilterPercent(alloc, value, "filter", "saturate");
    }
    if (std.mem.eql(u8, root, "hue-rotate")) {
        return resolveFilterDeg(alloc, value, "filter", "hue-rotate");
    }

    // Backdrop filter utilities
    if (std.mem.eql(u8, root, "backdrop-blur")) {
        return resolveFilter(alloc, value, "backdrop-filter", "blur", "--blur", theme);
    }
    if (std.mem.eql(u8, root, "backdrop-brightness")) {
        return resolveFilterPercent(alloc, value, "backdrop-filter", "brightness");
    }
    if (std.mem.eql(u8, root, "backdrop-contrast")) {
        return resolveFilterPercent(alloc, value, "backdrop-filter", "contrast");
    }
    if (std.mem.eql(u8, root, "backdrop-grayscale")) {
        return resolveFilterToggle(alloc, value, "backdrop-filter", "grayscale");
    }
    if (std.mem.eql(u8, root, "backdrop-invert")) {
        return resolveFilterToggle(alloc, value, "backdrop-filter", "invert");
    }
    if (std.mem.eql(u8, root, "backdrop-sepia")) {
        return resolveFilterToggle(alloc, value, "backdrop-filter", "sepia");
    }
    if (std.mem.eql(u8, root, "backdrop-saturate")) {
        return resolveFilterPercent(alloc, value, "backdrop-filter", "saturate");
    }
    if (std.mem.eql(u8, root, "backdrop-hue-rotate")) {
        return resolveFilterDeg(alloc, value, "backdrop-filter", "hue-rotate");
    }
    if (std.mem.eql(u8, root, "backdrop-opacity")) {
        return resolveFilterPercent(alloc, value, "backdrop-filter", "opacity");
    }

    // Ease (transition-timing-function)
    if (std.mem.eql(u8, root, "ease")) {
        return resolveEase(alloc, value, theme);
    }

    // Animate
    if (std.mem.eql(u8, root, "animate")) {
        return resolveAnimate(alloc, value, theme);
    }

    // Line clamp
    if (std.mem.eql(u8, root, "line-clamp")) {
        return resolveLineClamp(alloc, value);
    }

    // Content
    if (std.mem.eql(u8, root, "content")) {
        return resolveContent(alloc, value);
    }

    // List style type
    if (std.mem.eql(u8, root, "list")) {
        return resolveListStyleType(alloc, value);
    }

    // Space between (gap-based approach)
    if (std.mem.eql(u8, root, "space-x")) {
        return resolveSpaceBetween(alloc, value, "column-gap", theme);
    }
    if (std.mem.eql(u8, root, "space-y")) {
        return resolveSpaceBetween(alloc, value, "row-gap", theme);
    }

    // Divide width
    if (std.mem.eql(u8, root, "divide-x")) {
        return resolveDivide(alloc, value, "border-inline-width");
    }
    if (std.mem.eql(u8, root, "divide-y")) {
        return resolveDivide(alloc, value, "border-block-width");
    }

    // Underline offset
    if (std.mem.eql(u8, root, "underline-offset")) {
        return resolveUnderlineOffset(alloc, value);
    }

    // Gradient direction utilities
    if (std.mem.eql(u8, root, "bg-linear") or
        std.mem.eql(u8, root, "bg-radial") or
        std.mem.eql(u8, root, "bg-conic"))
    {
        return resolveGradient(alloc, root, value);
    }

    // bg-gradient-to-* (v3 compat alias for bg-linear-to-*)
    if (std.mem.eql(u8, root, "bg-gradient")) {
        return resolveGradient(alloc, "bg-linear", value);
    }

    // Gradient color stop utilities
    if (std.mem.eql(u8, root, "from") or
        std.mem.eql(u8, root, "via") or
        std.mem.eql(u8, root, "to"))
    {
        return resolveGradientStop(alloc, root, value, modifier, theme);
    }

    // Perspective
    if (std.mem.eql(u8, root, "perspective")) {
        return resolvePerspective(alloc, value, theme);
    }

    // Transform origin
    if (std.mem.eql(u8, root, "origin")) {
        return resolveOrigin(alloc, value);
    }

    // Columns
    if (std.mem.eql(u8, root, "columns")) {
        return resolveColumns(alloc, value, theme);
    }

    // Outline offset
    if (std.mem.eql(u8, root, "outline-offset")) {
        return resolveOutlineOffset(alloc, value);
    }

    // Outline (functional: width or color)
    if (std.mem.eql(u8, root, "outline")) {
        return resolveOutline(alloc, value, modifier, theme);
    }

    // Grow / Shrink with values
    if (std.mem.eql(u8, root, "grow")) {
        return resolveGrowShrink(alloc, value, "flex-grow");
    }
    if (std.mem.eql(u8, root, "shrink")) {
        return resolveGrowShrink(alloc, value, "flex-shrink");
    }

    // Inset shadow
    if (std.mem.eql(u8, root, "inset-shadow")) {
        return resolveInsetShadow(alloc, value, theme);
    }

    // Ring offset
    if (std.mem.eql(u8, root, "ring-offset")) {
        return resolveRingOffset(alloc, value, modifier, theme);
    }

    // Inset ring
    if (std.mem.eql(u8, root, "inset-ring")) {
        return resolveInsetRing(alloc, value, modifier, theme);
    }

    // Text shadow
    if (std.mem.eql(u8, root, "text-shadow")) {
        return resolveTextShadow(alloc, value, theme);
    }

    // Font weight (standalone)
    if (std.mem.eql(u8, root, "font-weight")) {
        return resolveFontWeight(alloc, value, theme);
    }

    // Mask image
    if (std.mem.eql(u8, root, "mask-image")) {
        const val = value orelse return null;
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "-webkit-mask-image", .value = val.value };
        decls[1] = Declaration{ .property = "mask-image", .value = val.value };
        return decls;
    }

    // List image
    if (std.mem.eql(u8, root, "list-image")) {
        const val = value orelse return null;
        switch (val.kind) {
            .arbitrary => {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "list-style-image", .value = val.value };
                return decls;
            },
            .named => {
                if (std.mem.eql(u8, val.value, "none")) {
                    const decls = try alloc.alloc(Declaration, 1);
                    decls[0] = Declaration{ .property = "list-style-image", .value = "none" };
                    return decls;
                }
                return null;
            },
        }
    }

    // Negative gradient direction utilities
    if (std.mem.eql(u8, root, "-bg-linear") or std.mem.eql(u8, root, "-bg-conic")) {
        return resolveGradient(alloc, root, value);
    }

    // Mask utilities (simple single-property)
    if (std.mem.eql(u8, root, "mask-position")) {
        return resolveSingleProp(alloc, value, "mask-position");
    }
    if (std.mem.eql(u8, root, "mask-size")) {
        return resolveSingleProp(alloc, value, "mask-size");
    }
    if (std.mem.eql(u8, root, "mask-repeat")) {
        return resolveSingleProp(alloc, value, "mask-repeat");
    }
    if (std.mem.eql(u8, root, "mask-type")) {
        return resolveSingleProp(alloc, value, "mask-type");
    }
    if (std.mem.eql(u8, root, "bg-size")) {
        return resolveSingleProp(alloc, value, "background-size");
    }
    if (std.mem.eql(u8, root, "bg-position")) {
        return resolveSingleProp(alloc, value, "background-position");
    }
    if (std.mem.eql(u8, root, "font-stretch")) {
        return resolveSingleProp(alloc, value, "font-stretch");
    }

    // Drop shadow
    if (std.mem.eql(u8, root, "drop-shadow")) {
        return resolveDropShadow(alloc, value, theme);
    }

    // Border spacing
    if (std.mem.eql(u8, root, "border-spacing") or
        std.mem.eql(u8, root, "border-spacing-x") or
        std.mem.eql(u8, root, "border-spacing-y"))
    {
        return resolveBorderSpacing(alloc, root, value, theme);
    }

    // Text indent
    if (std.mem.eql(u8, root, "indent") or std.mem.eql(u8, root, "-indent")) {
        return resolveIndent(alloc, value, theme);
    }

    // Shadow as color (shadow-color-*)
    if (std.mem.eql(u8, root, "shadow-color")) {
        return resolveShadowColor(alloc, value, modifier, theme);
    }

    return null;
}

fn isSpacingUtility(root: []const u8) bool {
    const spacing_roots = [_][]const u8{
        "p",    "px",   "py",   "ps",   "pe",   "pt",   "pr",   "pb",   "pl",
        "m",    "mx",   "my",   "ms",   "me",   "mt",   "mr",   "mb",   "ml",
        "-m",   "-mx",  "-my",  "-ms",  "-me",  "-mt",  "-mr",  "-mb",  "-ml",
        "w",    "h",    "min-w", "min-h", "max-w", "max-h", "size",
        "inset", "inset-x", "inset-y", "inset-s", "inset-e",
        "top",  "right", "bottom", "left",
        "-inset", "-inset-x", "-inset-y", "-inset-s", "-inset-e",
        "-top", "-right", "-bottom", "-left",
        "gap",  "gap-x", "gap-y",
        "scroll-m", "scroll-mx", "scroll-my", "scroll-ms", "scroll-me",
        "scroll-mt", "scroll-mr", "scroll-mb", "scroll-ml",
        "scroll-p", "scroll-px", "scroll-py", "scroll-ps", "scroll-pe",
        "scroll-pt", "scroll-pr", "scroll-pb", "scroll-pl",
        "basis",
    };
    for (spacing_roots) |r| {
        if (std.mem.eql(u8, root, r)) return true;
    }
    return false;
}

fn isColorUtility(root: []const u8) bool {
    const color_roots = [_][]const u8{
        "bg",    "accent",  "caret",
        "fill",  "stroke",  "outline-color", "decoration",
        "shadow-color", "divide", "placeholder",
    };
    for (color_roots) |r| {
        if (std.mem.eql(u8, root, r)) return true;
    }
    return false;
}

/// Map spacing utility roots to CSS properties.
fn spacingProperty(root: []const u8) []const []const u8 {
    const map = std.StaticStringMap([]const []const u8).initComptime(.{
        .{ "p", &[_][]const u8{"padding"} },
        .{ "px", &[_][]const u8{"padding-inline"} },
        .{ "py", &[_][]const u8{"padding-block"} },
        .{ "ps", &[_][]const u8{"padding-inline-start"} },
        .{ "pe", &[_][]const u8{"padding-inline-end"} },
        .{ "pt", &[_][]const u8{"padding-top"} },
        .{ "pr", &[_][]const u8{"padding-right"} },
        .{ "pb", &[_][]const u8{"padding-bottom"} },
        .{ "pl", &[_][]const u8{"padding-left"} },
        .{ "m", &[_][]const u8{"margin"} },
        .{ "mx", &[_][]const u8{"margin-inline"} },
        .{ "my", &[_][]const u8{"margin-block"} },
        .{ "ms", &[_][]const u8{"margin-inline-start"} },
        .{ "me", &[_][]const u8{"margin-inline-end"} },
        .{ "mt", &[_][]const u8{"margin-top"} },
        .{ "mr", &[_][]const u8{"margin-right"} },
        .{ "mb", &[_][]const u8{"margin-bottom"} },
        .{ "ml", &[_][]const u8{"margin-left"} },
        .{ "-m", &[_][]const u8{"margin"} },
        .{ "-mx", &[_][]const u8{"margin-inline"} },
        .{ "-my", &[_][]const u8{"margin-block"} },
        .{ "-ms", &[_][]const u8{"margin-inline-start"} },
        .{ "-me", &[_][]const u8{"margin-inline-end"} },
        .{ "-mt", &[_][]const u8{"margin-top"} },
        .{ "-mr", &[_][]const u8{"margin-right"} },
        .{ "-mb", &[_][]const u8{"margin-bottom"} },
        .{ "-ml", &[_][]const u8{"margin-left"} },
        .{ "w", &[_][]const u8{"width"} },
        .{ "h", &[_][]const u8{"height"} },
        .{ "min-w", &[_][]const u8{"min-width"} },
        .{ "min-h", &[_][]const u8{"min-height"} },
        .{ "max-w", &[_][]const u8{"max-width"} },
        .{ "max-h", &[_][]const u8{"max-height"} },
        .{ "size", &[_][]const u8{ "width", "height" } },
        .{ "inset", &[_][]const u8{"inset"} },
        .{ "inset-x", &[_][]const u8{"inset-inline"} },
        .{ "inset-y", &[_][]const u8{"inset-block"} },
        .{ "inset-s", &[_][]const u8{"inset-inline-start"} },
        .{ "inset-e", &[_][]const u8{"inset-inline-end"} },
        .{ "top", &[_][]const u8{"top"} },
        .{ "right", &[_][]const u8{"right"} },
        .{ "bottom", &[_][]const u8{"bottom"} },
        .{ "left", &[_][]const u8{"left"} },
        .{ "-inset", &[_][]const u8{"inset"} },
        .{ "-inset-x", &[_][]const u8{"inset-inline"} },
        .{ "-inset-y", &[_][]const u8{"inset-block"} },
        .{ "-inset-s", &[_][]const u8{"inset-inline-start"} },
        .{ "-inset-e", &[_][]const u8{"inset-inline-end"} },
        .{ "-top", &[_][]const u8{"top"} },
        .{ "-right", &[_][]const u8{"right"} },
        .{ "-bottom", &[_][]const u8{"bottom"} },
        .{ "-left", &[_][]const u8{"left"} },
        .{ "gap", &[_][]const u8{"gap"} },
        .{ "gap-x", &[_][]const u8{"column-gap"} },
        .{ "gap-y", &[_][]const u8{"row-gap"} },
        .{ "basis", &[_][]const u8{"flex-basis"} },
        .{ "scroll-m", &[_][]const u8{"scroll-margin"} },
        .{ "scroll-mx", &[_][]const u8{"scroll-margin-inline"} },
        .{ "scroll-my", &[_][]const u8{"scroll-margin-block"} },
        .{ "scroll-ms", &[_][]const u8{"scroll-margin-inline-start"} },
        .{ "scroll-me", &[_][]const u8{"scroll-margin-inline-end"} },
        .{ "scroll-mt", &[_][]const u8{"scroll-margin-top"} },
        .{ "scroll-mr", &[_][]const u8{"scroll-margin-right"} },
        .{ "scroll-mb", &[_][]const u8{"scroll-margin-bottom"} },
        .{ "scroll-ml", &[_][]const u8{"scroll-margin-left"} },
        .{ "scroll-p", &[_][]const u8{"scroll-padding"} },
        .{ "scroll-px", &[_][]const u8{"scroll-padding-inline"} },
        .{ "scroll-py", &[_][]const u8{"scroll-padding-block"} },
        .{ "scroll-ps", &[_][]const u8{"scroll-padding-inline-start"} },
        .{ "scroll-pe", &[_][]const u8{"scroll-padding-inline-end"} },
        .{ "scroll-pt", &[_][]const u8{"scroll-padding-top"} },
        .{ "scroll-pr", &[_][]const u8{"scroll-padding-right"} },
        .{ "scroll-pb", &[_][]const u8{"scroll-padding-bottom"} },
        .{ "scroll-pl", &[_][]const u8{"scroll-padding-left"} },
    });
    return map.get(root) orelse &[_][]const u8{root};
}

fn resolveSpacing(
    alloc: Allocator,
    root: []const u8,
    value: ?Value,
    theme: *Theme,
    negative: bool,
) !?[]const Declaration {
    const val = value orelse return null;
    const properties = spacingProperty(root);
    const is_neg = negative or (root.len > 0 and root[0] == '-');

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (is_neg) {
                if (std.mem.startsWith(u8, val.value, "var(")) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "-{s}", .{val.value});
                }
            } else {
                css_value = val.value;
            }
        },
        .named => {
            // Check for special keywords
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (std.mem.eql(u8, val.value, "full")) {
                css_value = if (is_neg) "-100%" else "100%";
            } else if (std.mem.eql(u8, val.value, "screen")) {
                // w-screen -> 100vw, h-screen -> 100vh
                if (std.mem.eql(u8, root, "w") or std.mem.eql(u8, root, "max-w") or std.mem.eql(u8, root, "min-w")) {
                    css_value = "100vw";
                } else {
                    css_value = "100vh";
                }
            } else if (std.mem.eql(u8, val.value, "min")) {
                css_value = "min-content";
            } else if (std.mem.eql(u8, val.value, "max")) {
                css_value = "max-content";
            } else if (std.mem.eql(u8, val.value, "fit")) {
                css_value = "fit-content";
            } else if (std.mem.eql(u8, val.value, "px")) {
                css_value = if (is_neg) "-1px" else "1px";
            } else if (val.fraction) |frac| {
                // Fraction: e.g. 1/2 -> 50%
                css_value = try resolveFraction(alloc, frac, is_neg);
            } else if (isValidSpacingMultiplier(val.value)) {
                // Bare number: multiply by spacing
                theme.markUsed("--spacing");
                if (is_neg) {
                    css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * -{s})", .{val.value});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
                }
            } else if (theme.resolve(val.value, "--spacing") != null) {
                // Named spacing value from theme
                const var_name = try std.fmt.allocPrint(alloc, "var(--spacing-{s})", .{val.value});
                if (is_neg) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{var_name});
                } else {
                    css_value = var_name;
                }
            } else if ((std.mem.eql(u8, root, "max-w") or std.mem.eql(u8, root, "max-h")) and !is_neg) {
                // Named max-width values (container sizes)
                const max_w_map = std.StaticStringMap([]const u8).initComptime(.{
                    .{ "xs", "20rem" },
                    .{ "sm", "24rem" },
                    .{ "md", "28rem" },
                    .{ "lg", "32rem" },
                    .{ "xl", "36rem" },
                    .{ "2xl", "42rem" },
                    .{ "3xl", "48rem" },
                    .{ "4xl", "56rem" },
                    .{ "5xl", "64rem" },
                    .{ "6xl", "72rem" },
                    .{ "7xl", "80rem" },
                    .{ "screen-sm", "40rem" },
                    .{ "screen-md", "48rem" },
                    .{ "screen-lg", "64rem" },
                    .{ "screen-xl", "80rem" },
                    .{ "screen-2xl", "96rem" },
                });
                if (max_w_map.get(val.value)) |mw_val| {
                    css_value = mw_val;
                } else {
                    return null;
                }
            } else {
                return null;
            }
        },
    }

    var decls = try alloc.alloc(Declaration, properties.len);
    for (properties, 0..) |prop, i| {
        decls[i] = Declaration{
            .property = prop,
            .value = css_value,
        };
    }
    return decls;
}

fn resolveColor(
    alloc: Allocator,
    root: []const u8,
    value: ?Value,
    modifier: ?Modifier,
    theme: *Theme,
) !?[]const Declaration {
    const val = value orelse return null;

    const property = colorProperty(root);
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            // Special keywords
            if (std.mem.eql(u8, val.value, "inherit")) {
                css_value = "inherit";
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                css_value = "transparent";
            } else if (std.mem.eql(u8, val.value, "current")) {
                css_value = "currentColor";
            } else if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    // Apply color opacity modifier if present
    if (modifier) |mod| {
        css_value = try applyColorOpacity(alloc, css_value, mod);
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{
        .property = property,
        .value = css_value,
    };
    return decls;
}

fn colorProperty(root: []const u8) []const u8 {
    const map = std.StaticStringMap([]const u8).initComptime(.{
        .{ "bg", "background-color" },
        .{ "text", "color" },
        .{ "border", "border-color" },
        .{ "accent", "accent-color" },
        .{ "caret", "caret-color" },
        .{ "fill", "fill" },
        .{ "stroke", "stroke" },
        .{ "outline-color", "outline-color" },
        .{ "decoration", "text-decoration-color" },
        .{ "divide", "border-color" },
        .{ "shadow-color", "--tw-shadow-color" },
        .{ "placeholder", "color" },
    });
    return map.get(root) orelse root;
}

fn resolveZIndex(alloc: Allocator, value: ?Value, negative: bool) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (negative) {
                css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (isPositiveInteger(val.value)) {
                if (negative) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
                } else {
                    css_value = val.value;
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "z-index", .value = css_value };
    return decls;
}

fn resolveOpacity(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                // Convert percentage to decimal: opacity-50 -> 0.5
                const num = std.fmt.parseInt(u32, val.value, 10) catch return null;
                if (num > 100) return null;
                css_value = try std.fmt.allocPrint(alloc, "{d}%", .{num});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "opacity", .value = css_value };
    return decls;
}

fn resolveOrder(alloc: Allocator, value: ?Value, negative: bool) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (negative) {
                css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (std.mem.eql(u8, val.value, "first")) {
                css_value = if (negative) "9999" else "-9999";
            } else if (std.mem.eql(u8, val.value, "last")) {
                css_value = if (negative) "-9999" else "9999";
            } else if (std.mem.eql(u8, val.value, "none")) {
                css_value = "0";
            } else if (isPositiveInteger(val.value)) {
                if (negative) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
                } else {
                    css_value = val.value;
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "order", .value = css_value };
    return decls;
}

fn resolveRounded(alloc: Allocator, root: []const u8, value: ?Value, theme: *Theme) !?[]const Declaration {
    _ = theme;
    const val = value orelse return null;

    const property_map = std.StaticStringMap([]const []const u8).initComptime(.{
        .{ "rounded", &[_][]const u8{"border-radius"} },
        .{ "rounded-t", &[_][]const u8{ "border-top-left-radius", "border-top-right-radius" } },
        .{ "rounded-r", &[_][]const u8{ "border-top-right-radius", "border-bottom-right-radius" } },
        .{ "rounded-b", &[_][]const u8{ "border-bottom-left-radius", "border-bottom-right-radius" } },
        .{ "rounded-l", &[_][]const u8{ "border-top-left-radius", "border-bottom-left-radius" } },
        .{ "rounded-tl", &[_][]const u8{"border-top-left-radius"} },
        .{ "rounded-tr", &[_][]const u8{"border-top-right-radius"} },
        .{ "rounded-br", &[_][]const u8{"border-bottom-right-radius"} },
        .{ "rounded-bl", &[_][]const u8{"border-bottom-left-radius"} },
        .{ "rounded-s", &[_][]const u8{ "border-start-start-radius", "border-end-start-radius" } },
        .{ "rounded-e", &[_][]const u8{ "border-start-end-radius", "border-end-end-radius" } },
        .{ "rounded-ss", &[_][]const u8{"border-start-start-radius"} },
        .{ "rounded-se", &[_][]const u8{"border-start-end-radius"} },
        .{ "rounded-es", &[_][]const u8{"border-end-start-radius"} },
        .{ "rounded-ee", &[_][]const u8{"border-end-end-radius"} },
    });

    const properties = property_map.get(root) orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "0";
            } else if (std.mem.eql(u8, val.value, "full")) {
                css_value = "9999px";
            } else {
                // Look up in theme --radius-{value}
                css_value = try std.fmt.allocPrint(alloc, "var(--radius-{s})", .{val.value});
            }
        },
    }

    var decls = try alloc.alloc(Declaration, properties.len);
    for (properties, 0..) |prop, i| {
        decls[i] = Declaration{ .property = prop, .value = css_value };
    }
    return decls;
}

fn resolveDuration(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                // Convert ms to seconds: duration-200 -> 0.2s
                const ms = std.fmt.parseInt(u32, val.value, 10) catch return null;
                if (ms == 0) {
                    css_value = "0s";
                } else if (ms % 1000 == 0) {
                    css_value = try std.fmt.allocPrint(alloc, "{d}s", .{ms / 1000});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, ".{d}s", .{ms});
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transition-duration", .value = css_value };
    return decls;
}

fn resolveDelay(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                const ms = std.fmt.parseInt(u32, val.value, 10) catch return null;
                if (ms == 0) {
                    css_value = "0s";
                } else if (ms % 1000 == 0) {
                    css_value = try std.fmt.allocPrint(alloc, "{d}s", .{ms / 1000});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, ".{d}s", .{ms});
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transition-delay", .value = css_value };
    return decls;
}

// ─── Color Opacity Helper ──────────────────────────────────────────────────

fn applyColorOpacity(alloc: Allocator, color: []const u8, mod: Modifier) ![]const u8 {
    var percent: []const u8 = undefined;
    switch (mod.kind) {
        .arbitrary => {
            // Arbitrary modifier like [.5] -> convert decimal to percentage
            const f = std.fmt.parseFloat(f64, mod.value) catch {
                // If not a float, use as-is (e.g., [50%])
                percent = mod.value;
                return std.fmt.allocPrint(alloc, "color-mix(in oklab,{s} {s},transparent)", .{ color, percent });
            };
            const pct = @as(u32, @intFromFloat(@round(f * 100.0)));
            percent = try std.fmt.allocPrint(alloc, "{d}%", .{pct});
        },
        .named => {
            // Named modifier like /50 -> 50%
            percent = try std.fmt.allocPrint(alloc, "{s}%", .{mod.value});
        },
    }
    return std.fmt.allocPrint(alloc, "color-mix(in oklab,{s} {s},transparent)", .{ color, percent });
}

// ─── Text (font-size + line-height / color) ────────────────────────────────

fn resolveText(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    switch (val.kind) {
        .arbitrary => {
            // Arbitrary value: font-size
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "font-size", .value = val.value };
            return decls;
        },
        .named => {
            // Try color first
            if (std.mem.eql(u8, val.value, "inherit") or
                std.mem.eql(u8, val.value, "transparent") or
                std.mem.eql(u8, val.value, "current") or
                theme.resolve(val.value, "--color") != null)
            {
                // It's a color value
                var css_value: []const u8 = undefined;
                if (std.mem.eql(u8, val.value, "inherit")) {
                    css_value = "inherit";
                } else if (std.mem.eql(u8, val.value, "transparent")) {
                    css_value = "transparent";
                } else if (std.mem.eql(u8, val.value, "current")) {
                    css_value = "currentColor";
                } else {
                    theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                    css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                }
                if (modifier) |mod| {
                    css_value = try applyColorOpacity(alloc, css_value, mod);
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "color", .value = css_value };
                return decls;
            }

            // Try font-size theme
            if (theme.resolve(val.value, "--text") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--text-{s}", .{val.value}));
                const font_size = try std.fmt.allocPrint(alloc, "var(--text-{s})", .{val.value});
                const line_height = try std.fmt.allocPrint(alloc, "var(--tw-leading,var(--text-{s}--line-height))", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "font-size", .value = font_size };
                decls[1] = Declaration{ .property = "line-height", .value = line_height };
                return decls;
            }

            return null;
        },
    }
}

// ─── Font (family + weight) ────────────────────────────────────────────────

fn resolveFont(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    switch (val.kind) {
        .arbitrary => {
            // Arbitrary: assume font-weight
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "font-weight", .value = val.value };
            return decls;
        },
        .named => {
            // Try font-family first (--font-{value})
            if (theme.resolve(val.value, "--font") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--font-{s}", .{val.value}));
                const css_value = try std.fmt.allocPrint(alloc, "var(--font-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "font-family", .value = css_value };
                return decls;
            }

            // Try font-weight (--font-weight-{value})
            if (theme.resolve(val.value, "--font-weight") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--font-weight-{s}", .{val.value}));
                const css_value = try std.fmt.allocPrint(alloc, "var(--font-weight-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "font-weight", .value = css_value };
                return decls;
            }

            return null;
        },
    }
}

// ─── Leading (line-height) ─────────────────────────────────────────────────

fn resolveLeading(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            // Try theme --leading-{value}
            if (theme.resolve(val.value, "--leading") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--leading-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--leading-{s})", .{val.value});
            } else if (std.mem.eql(u8, val.value, "none")) {
                css_value = "1";
            } else if (isValidSpacingMultiplier(val.value)) {
                // Bare number = spacing multiplier
                theme.markUsed("--spacing");
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "line-height", .value = css_value };
    return decls;
}

// ─── Tracking (letter-spacing) ─────────────────────────────────────────────

fn resolveTracking(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (theme.resolve(val.value, "--tracking") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--tracking-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--tracking-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "letter-spacing", .value = css_value };
    return decls;
}

// ─── Border (dual: color + width) ──────────────────────────────────────────

fn resolveBorder(alloc: Allocator, root: []const u8, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // bare `border`, `border-t`, `border-l`, etc. with no value -> width: 1px
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = borderWidthProperty(root), .value = "1px" };
        return decls;
    };

    const width_property = borderWidthProperty(root);

    switch (val.kind) {
        .arbitrary => {
            // Check if it looks like a width value (has px, number, etc.)
            if (looksLikeBorderWidth(val.value)) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = width_property, .value = val.value };
                return decls;
            }
            // Otherwise treat as color
            var css_value: []const u8 = val.value;
            if (modifier) |mod| {
                css_value = try applyColorOpacity(alloc, css_value, mod);
            }
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "border-color", .value = css_value };
            return decls;
        },
        .named => {
            // Check if it's a bare number (border width)
            if (isPositiveInteger(val.value)) {
                const css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = width_property, .value = css_value };
                return decls;
            }

            // Try as color
            if (std.mem.eql(u8, val.value, "inherit")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "border-color", .value = "inherit" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "border-color", .value = "transparent" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "current")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "border-color", .value = "currentColor" };
                return decls;
            } else if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var css_value: []const u8 = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                if (modifier) |mod| {
                    css_value = try applyColorOpacity(alloc, css_value, mod);
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "border-color", .value = css_value };
                return decls;
            }

            return null;
        },
    }
}

fn borderWidthProperty(root: []const u8) []const u8 {
    const map = std.StaticStringMap([]const u8).initComptime(.{
        .{ "border", "border-width" },
        .{ "border-x", "border-inline-width" },
        .{ "border-y", "border-block-width" },
        .{ "border-s", "border-inline-start-width" },
        .{ "border-e", "border-inline-end-width" },
        .{ "border-t", "border-top-width" },
        .{ "border-r", "border-right-width" },
        .{ "border-b", "border-bottom-width" },
        .{ "border-l", "border-left-width" },
    });
    return map.get(root) orelse "border-width";
}

fn looksLikeBorderWidth(s: []const u8) bool {
    // If it ends with px, em, rem, etc. or is a pure number, it's a width
    if (s.len == 0) return false;
    if (std.mem.endsWith(u8, s, "px") or
        std.mem.endsWith(u8, s, "em") or
        std.mem.endsWith(u8, s, "rem"))
    {
        return true;
    }
    // Pure number
    for (s) |c| {
        if (c != '.' and (c < '0' or c > '9')) return false;
    }
    return true;
}

// ─── Aspect Ratio ──────────────────────────────────────────────────────────

fn resolveAspect(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (std.mem.eql(u8, val.value, "square")) {
                css_value = "1/1";
            } else if (val.fraction != null) {
                // Fraction like 4/3
                css_value = val.fraction.?;
            } else if (theme.resolve(val.value, "--aspect") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--aspect-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--aspect-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "aspect-ratio", .value = css_value };
    return decls;
}

// ─── Grid Template Columns/Rows ────────────────────────────────────────────

fn resolveGridTemplate(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Replace underscores with spaces in arbitrary values
            css_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else if (std.mem.eql(u8, val.value, "subgrid")) {
                css_value = "subgrid";
            } else if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "repeat({s},minmax(0,1fr))", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveGridPlacement(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveGridSpan(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "full")) {
                css_value = "1/-1";
            } else if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "span {s}/span {s}", .{ val.value, val.value });
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveGridStartEnd(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (isPositiveInteger(val.value)) {
                css_value = val.value;
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveGridAuto(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (std.mem.eql(u8, val.value, "min")) {
                css_value = "min-content";
            } else if (std.mem.eql(u8, val.value, "max")) {
                css_value = "max-content";
            } else if (std.mem.eql(u8, val.value, "fr")) {
                css_value = "minmax(0,1fr)";
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Transform: rotate ─────────────────────────────────────────────────────

fn resolveRotate(alloc: Allocator, value: ?Value, negative: bool) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (negative) {
                css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (isValidSpacingMultiplier(val.value)) {
                if (negative) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s}deg * -1)", .{val.value});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "{s}deg", .{val.value});
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "rotate", .value = css_value };
    return decls;
}

// ─── Transform: scale ──────────────────────────────────────────────────────

fn resolveScale(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}%", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "scale", .value = css_value };
    return decls;
}

// ─── Transform: translate ──────────────────────────────────────────────────

fn resolveTranslate(alloc: Allocator, value: ?Value, comptime axis: []const u8, negative: bool, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var inner: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (negative) {
                if (std.mem.startsWith(u8, val.value, "var(")) {
                    inner = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
                } else {
                    inner = try std.fmt.allocPrint(alloc, "-{s}", .{val.value});
                }
            } else {
                inner = val.value;
            }
        },
        .named => {
            if (std.mem.eql(u8, val.value, "full")) {
                inner = if (negative) "-100%" else "100%";
            } else if (std.mem.eql(u8, val.value, "px")) {
                inner = if (negative) "-1px" else "1px";
            } else if (val.fraction) |frac| {
                inner = try resolveFraction(alloc, frac, negative);
            } else if (isValidSpacingMultiplier(val.value)) {
                theme.markUsed("--spacing");
                if (negative) {
                    inner = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * -{s})", .{val.value});
                } else {
                    inner = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
                }
            } else {
                return null;
            }
        },
    }

    const css_value = try std.fmt.allocPrint(alloc, "translate{s}({s})", .{ axis, inner });

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transform", .value = css_value };
    return decls;
}

// ─── Transform: skew ───────────────────────────────────────────────────────

fn resolveSkew(alloc: Allocator, value: ?Value, comptime axis: []const u8, negative: bool) !?[]const Declaration {
    const val = value orelse return null;

    var deg_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (negative) {
                deg_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{val.value});
            } else {
                deg_value = val.value;
            }
        },
        .named => {
            if (isValidSpacingMultiplier(val.value)) {
                if (negative) {
                    deg_value = try std.fmt.allocPrint(alloc, "-{s}deg", .{val.value});
                } else {
                    deg_value = try std.fmt.allocPrint(alloc, "{s}deg", .{val.value});
                }
            } else {
                return null;
            }
        },
    }

    const css_value = try std.fmt.allocPrint(alloc, "skew{s}({s})", .{ axis, deg_value });

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transform", .value = css_value };
    return decls;
}

// ─── Shadow ────────────────────────────────────────────────────────────────

fn resolveShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Replace underscores with spaces
            css_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "0 0 #0000";
            } else if (theme.resolve(val.value, "--shadow") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--shadow-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--shadow-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "box-shadow", .value = css_value };
    return decls;
}

// ─── Ring ──────────────────────────────────────────────────────────────────

fn resolveRing(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // ring with no value = 1px ring
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "box-shadow", .value = "0 0 0 1px currentColor" };
        return decls;
    };

    switch (val.kind) {
        .arbitrary => {
            // Could be color or width - check for numeric
            if (isPositiveInteger(val.value) or std.mem.endsWith(u8, val.value, "px") or std.mem.endsWith(u8, val.value, "rem")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "box-shadow", .value = try std.fmt.allocPrint(alloc, "0 0 0 {s} currentColor", .{val.value}) };
                return decls;
            }
            // Treat as color
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "--tw-ring-color", .value = val.value };
            return decls;
        },
        .named => {
            // Check for special color keywords
            if (std.mem.eql(u8, val.value, "inherit") or
                std.mem.eql(u8, val.value, "transparent") or
                std.mem.eql(u8, val.value, "current"))
            {
                const color_val = if (std.mem.eql(u8, val.value, "current")) "currentColor" else val.value;
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-ring-color", .value = color_val };
                return decls;
            }

            // Try as color from theme
            if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var color_css: []const u8 = undefined;
                if (modifier) |mod| {
                    color_css = try applyColorOpacity(alloc, try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value}), mod);
                } else {
                    color_css = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-ring-color", .value = color_css };
                return decls;
            }

            // Try as width
            if (isPositiveInteger(val.value)) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "box-shadow", .value = try std.fmt.allocPrint(alloc, "0 0 0 {s}px currentColor", .{val.value}) };
                return decls;
            }

            return null;
        },
    }
}

// ─── Filter utilities ──────────────────────────────────────────────────────

fn resolveFilter(alloc: Allocator, value: ?Value, property: []const u8, comptime fn_name: []const u8, comptime theme_ns: []const u8, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, val.value });
        },
        .named => {
            if (theme.resolve(val.value, theme_ns) != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "{s}-{s}", .{ theme_ns, val.value }));
                css_value = try std.fmt.allocPrint(alloc, "{s}(var({s}-{s}))", .{ fn_name, theme_ns, val.value });
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveFilterPercent(alloc: Allocator, value: ?Value, property: []const u8, comptime fn_name: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, val.value });
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}({s}%)", .{ fn_name, val.value });
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveFilterToggle(alloc: Allocator, value: ?Value, property: []const u8, comptime fn_name: []const u8) !?[]const Declaration {
    // grayscale, invert, sepia - default to 100%, accept 0
    var css_value: []const u8 = undefined;

    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                css_value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, val.value });
            },
            .named => {
                if (isPositiveInteger(val.value)) {
                    css_value = try std.fmt.allocPrint(alloc, "{s}({s}%)", .{ fn_name, val.value });
                } else {
                    return null;
                }
            },
        }
    } else {
        // No value means 100% (e.g., `grayscale` -> grayscale(100%))
        css_value = try std.fmt.allocPrint(alloc, "{s}(100%)", .{fn_name});
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

fn resolveFilterDeg(alloc: Allocator, value: ?Value, property: []const u8, comptime fn_name: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, val.value });
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}({s}deg)", .{ fn_name, val.value });
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Ease (transition-timing-function) ─────────────────────────────────────

fn resolveEase(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "linear")) {
                css_value = "linear";
            } else if (theme.resolve(val.value, "--ease") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--ease-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--ease-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transition-timing-function", .value = css_value };
    return decls;
}

// ─── Animate ───────────────────────────────────────────────────────────────

fn resolveAnimate(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else if (theme.resolve(val.value, "--animate") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--animate-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--animate-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "animation", .value = css_value };
    return decls;
}

// ─── Line Clamp ────────────────────────────────────────────────────────────

fn resolveLineClamp(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;

    switch (val.kind) {
        .arbitrary => {
            const decls = try alloc.alloc(Declaration, 4);
            decls[0] = Declaration{ .property = "overflow", .value = "hidden" };
            decls[1] = Declaration{ .property = "display", .value = "-webkit-box" };
            decls[2] = Declaration{ .property = "-webkit-box-orient", .value = "vertical" };
            decls[3] = Declaration{ .property = "-webkit-line-clamp", .value = val.value };
            return decls;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                const decls = try alloc.alloc(Declaration, 4);
                decls[0] = Declaration{ .property = "overflow", .value = "visible" };
                decls[1] = Declaration{ .property = "display", .value = "block" };
                decls[2] = Declaration{ .property = "-webkit-box-orient", .value = "horizontal" };
                decls[3] = Declaration{ .property = "-webkit-line-clamp", .value = "none" };
                return decls;
            } else if (isPositiveInteger(val.value)) {
                const decls = try alloc.alloc(Declaration, 4);
                decls[0] = Declaration{ .property = "overflow", .value = "hidden" };
                decls[1] = Declaration{ .property = "display", .value = "-webkit-box" };
                decls[2] = Declaration{ .property = "-webkit-box-orient", .value = "vertical" };
                decls[3] = Declaration{ .property = "-webkit-line-clamp", .value = val.value };
                return decls;
            }
            return null;
        },
    }
}

// ─── Content ───────────────────────────────────────────────────────────────

fn resolveContent(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "content", .value = css_value };
    return decls;
}

// ─── List Style Type ───────────────────────────────────────────────────────

fn resolveListStyleType(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "disc")) {
                css_value = "disc";
            } else if (std.mem.eql(u8, val.value, "decimal")) {
                css_value = "decimal";
            } else if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else {
                // Pass through named values
                css_value = val.value;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "list-style-type", .value = css_value };
    return decls;
}

// ─── Helpers ───────────────────────────────────────────────────────────────

fn replaceUnderscores(alloc: Allocator, s: []const u8) ![]const u8 {
    var count: usize = 0;
    for (s) |c| {
        if (c == '_') count += 1;
    }
    if (count == 0) return s;

    const result = try alloc.alloc(u8, s.len);
    for (s, 0..) |c, i| {
        result[i] = if (c == '_') ' ' else c;
    }
    return result;
}

fn isPositiveInteger(s: []const u8) bool {
    if (s.len == 0) return false;
    for (s) |c| {
        if (c < '0' or c > '9') return false;
    }
    return true;
}

fn isValidSpacingMultiplier(s: []const u8) bool {
    // Must be a valid number that is a multiple of 0.25
    // Accept integers and decimals like 0.5, 1.5, 2.5
    if (s.len == 0) return false;

    var has_dot = false;
    for (s) |c| {
        if (c == '.') {
            if (has_dot) return false;
            has_dot = true;
        } else if (c < '0' or c > '9') {
            return false;
        }
    }

    return true;
}

fn resolveFraction(alloc: Allocator, fraction: []const u8, negative: bool) ![]const u8 {
    // Parse "1/2" -> 50%
    const slash_idx = std.mem.indexOfScalar(u8, fraction, '/') orelse return error.OutOfMemory;
    const numerator_str = fraction[0..slash_idx];
    const denominator_str = fraction[slash_idx + 1 ..];

    const numerator = std.fmt.parseFloat(f64, numerator_str) catch return error.OutOfMemory;
    const denominator = std.fmt.parseFloat(f64, denominator_str) catch return error.OutOfMemory;

    if (denominator == 0) return error.OutOfMemory;

    var percentage = (numerator / denominator) * 100.0;
    if (negative) percentage = -percentage;

    // Format as integer percentage if possible
    const int_pct = @as(i64, @intFromFloat(@round(percentage)));
    if (@as(f64, @floatFromInt(int_pct)) == percentage) {
        return std.fmt.allocPrint(alloc, "{d}%", .{int_pct});
    }

    return std.fmt.allocPrint(alloc, "{d}%", .{percentage});
}

// ─── Space Between (gap-based) ─────────────────────────────────────────────

fn resolveSpaceBetween(alloc: Allocator, value: ?Value, property: []const u8, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "0")) {
                css_value = "0px";
            } else if (std.mem.eql(u8, val.value, "px")) {
                css_value = "1px";
            } else if (std.mem.eql(u8, val.value, "reverse")) {
                // space-x-reverse / space-y-reverse: set CSS var
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-space-reverse", .value = "1" };
                return decls;
            } else if (isValidSpacingMultiplier(val.value)) {
                theme.markUsed("--spacing");
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Divide Width ──────────────────────────────────────────────────────────

fn resolveDivide(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    var css_value: []const u8 = undefined;

    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                css_value = val.value;
            },
            .named => {
                if (std.mem.eql(u8, val.value, "0")) {
                    css_value = "0px";
                } else if (isPositiveInteger(val.value)) {
                    css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
                } else {
                    return null;
                }
            },
        }
    } else {
        // bare divide-x / divide-y -> 1px
        css_value = "1px";
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Underline Offset ──────────────────────────────────────────────────────

fn resolveUnderlineOffset(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "text-underline-offset", .value = css_value };
    return decls;
}

// ─── Gradient Direction ────────────────────────────────────────────────────

fn resolveGradient(alloc: Allocator, root: []const u8, value: ?Value) !?[]const Declaration {
    if (std.mem.eql(u8, root, "bg-linear") or std.mem.eql(u8, root, "-bg-linear")) {
        return resolveLinearGradient(alloc, value);
    } else if (std.mem.eql(u8, root, "bg-radial")) {
        return resolveRadialGradient(alloc, value);
    } else if (std.mem.eql(u8, root, "bg-conic") or std.mem.eql(u8, root, "-bg-conic")) {
        return resolveConicGradient(alloc, value);
    }
    return null;
}

fn resolveLinearGradient(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var direction: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            direction = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            const dir_map = std.StaticStringMap([]const u8).initComptime(.{
                .{ "to-t", "to top" },
                .{ "to-tr", "to top right" },
                .{ "to-r", "to right" },
                .{ "to-br", "to bottom right" },
                .{ "to-b", "to bottom" },
                .{ "to-bl", "to bottom left" },
                .{ "to-l", "to left" },
                .{ "to-tl", "to top left" },
            });
            if (dir_map.get(val.value)) |dir| {
                direction = dir;
            } else if (isValidSpacingMultiplier(val.value)) {
                // Bare number -> degrees
                direction = try std.fmt.allocPrint(alloc, "{s}deg", .{val.value});
            } else {
                return null;
            }
        },
    }

    const css_value = try std.fmt.allocPrint(alloc, "linear-gradient({s},var(--tw-gradient-stops,))", .{direction});
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "background-image", .value = css_value };
    return decls;
}

fn resolveRadialGradient(alloc: Allocator, value: ?Value) !?[]const Declaration {
    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                const inner = try replaceUnderscores(alloc, val.value);
                const css_value = try std.fmt.allocPrint(alloc, "radial-gradient({s} in oklab,var(--tw-gradient-stops,))", .{inner});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "background-image", .value = css_value };
                return decls;
            },
            .named => {
                return null;
            },
        }
    } else {
        // bare bg-radial
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "background-image", .value = "radial-gradient(in oklab,var(--tw-gradient-stops,))" };
        return decls;
    }
}

fn resolveConicGradient(alloc: Allocator, value: ?Value) !?[]const Declaration {
    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                const inner = try replaceUnderscores(alloc, val.value);
                const css_value = try std.fmt.allocPrint(alloc, "conic-gradient({s} in oklab,var(--tw-gradient-stops,))", .{inner});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "background-image", .value = css_value };
                return decls;
            },
            .named => {
                // Bare number -> from Ndeg
                if (isValidSpacingMultiplier(val.value)) {
                    const css_value = try std.fmt.allocPrint(alloc, "conic-gradient(from {s}deg in oklab,var(--tw-gradient-stops,))", .{val.value});
                    const decls = try alloc.alloc(Declaration, 1);
                    decls[0] = Declaration{ .property = "background-image", .value = css_value };
                    return decls;
                }
                return null;
            },
        }
    } else {
        // bare bg-conic
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "background-image", .value = "conic-gradient(in oklab,var(--tw-gradient-stops,))" };
        return decls;
    }
}

// ─── Gradient Color Stops ──────────────────────────────────────────────────

fn resolveGradientStop(alloc: Allocator, root: []const u8, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    const property: []const u8 = if (std.mem.eql(u8, root, "from"))
        "--tw-gradient-from"
    else if (std.mem.eql(u8, root, "via"))
        "--tw-gradient-via"
    else if (std.mem.eql(u8, root, "to"))
        "--tw-gradient-to"
    else
        return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "inherit")) {
                css_value = "inherit";
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                css_value = "transparent";
            } else if (std.mem.eql(u8, val.value, "current")) {
                css_value = "currentColor";
            } else if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else if (std.mem.endsWith(u8, val.value, "%")) {
                // Gradient position: from-0%, via-50%, to-100%
                const pos_prop: []const u8 = if (std.mem.eql(u8, root, "from"))
                    "--tw-gradient-from-position"
                else if (std.mem.eql(u8, root, "via"))
                    "--tw-gradient-via-position"
                else
                    "--tw-gradient-to-position";
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = pos_prop, .value = val.value };
                return decls;
            } else {
                return null;
            }
        },
    }

    // Apply opacity modifier if present
    if (modifier) |mod| {
        css_value = try applyColorOpacity(alloc, css_value, mod);
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Perspective ───────────────────────────────────────────────────────────

fn resolvePerspective(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else if (theme.resolve(val.value, "--perspective") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--perspective-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--perspective-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "perspective", .value = css_value };
    return decls;
}

// ─── Transform Origin ─────────────────────────────────────────────────────

fn resolveOrigin(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            const origin_map = std.StaticStringMap([]const u8).initComptime(.{
                .{ "center", "center" },
                .{ "top", "top" },
                .{ "top-right", "100% 0" },
                .{ "right", "100%" },
                .{ "bottom-right", "100% 100%" },
                .{ "bottom", "bottom" },
                .{ "bottom-left", "0 100%" },
                .{ "left", "0" },
                .{ "top-left", "0 0" },
            });
            if (origin_map.get(val.value)) |v| {
                css_value = v;
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transform-origin", .value = css_value };
    return decls;
}

// ─── Columns ───────────────────────────────────────────────────────────────

fn resolveColumns(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (isPositiveInteger(val.value)) {
                // Pure integer 1-12
                css_value = val.value;
            } else if (theme.resolve(val.value, "--container") != null) {
                // Named container size: 3xs, 2xs, xs, sm, md, lg, xl, 2xl, ...
                theme.markUsed(try std.fmt.allocPrint(alloc, "--container-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--container-{s})", .{val.value});
            } else {
                // Named size values (fallback)
                const size_map = std.StaticStringMap([]const u8).initComptime(.{
                    .{ "3xs", "16rem" },
                    .{ "2xs", "18rem" },
                    .{ "xs", "20rem" },
                    .{ "sm", "24rem" },
                    .{ "md", "28rem" },
                    .{ "lg", "32rem" },
                    .{ "xl", "36rem" },
                    .{ "2xl", "42rem" },
                    .{ "3xl", "48rem" },
                    .{ "4xl", "56rem" },
                    .{ "5xl", "64rem" },
                    .{ "6xl", "72rem" },
                    .{ "7xl", "80rem" },
                });
                if (size_map.get(val.value)) |sz| {
                    css_value = sz;
                } else {
                    return null;
                }
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "columns", .value = css_value };
    return decls;
}

// ─── Outline Offset ────────────────────────────────────────────────────────

fn resolveOutlineOffset(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "outline-offset", .value = css_value };
    return decls;
}

// ─── Outline (functional: width or color) ──────────────────────────────────

fn resolveOutline(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    switch (val.kind) {
        .arbitrary => {
            if (looksLikeBorderWidth(val.value)) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-width", .value = val.value };
                return decls;
            }
            // Otherwise treat as color
            var css_value: []const u8 = val.value;
            if (modifier) |mod| {
                css_value = try applyColorOpacity(alloc, css_value, mod);
            }
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "outline-color", .value = css_value };
            return decls;
        },
        .named => {
            // Check if it's a bare number (outline width)
            if (isPositiveInteger(val.value)) {
                const css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-width", .value = css_value };
                return decls;
            }

            // Try as color
            if (std.mem.eql(u8, val.value, "inherit")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "inherit" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "transparent" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "current")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "currentColor" };
                return decls;
            } else if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var css_value: []const u8 = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                if (modifier) |mod| {
                    css_value = try applyColorOpacity(alloc, css_value, mod);
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = css_value };
                return decls;
            }

            return null;
        },
    }
}

// ─── Grow / Shrink ─────────────────────────────────────────────────────────

fn resolveGrowShrink(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isValidSpacingMultiplier(val.value)) {
                css_value = val.value;
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = css_value };
    return decls;
}

// ─── Single Property Helper ────────────────────────────────────────────────

fn resolveSingleProp(alloc: Allocator, value: ?Value, property: []const u8) !?[]const Declaration {
    const val = value orelse return null;
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = property, .value = val.value };
    return decls;
}

// ─── Inset Shadow ──────────────────────────────────────────────────────────

fn resolveInsetShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "0 0 #0000";
            } else {
                const var_name = try std.fmt.allocPrint(alloc, "--inset-shadow-{s}", .{val.value});
                if (theme.get(var_name) != null) {
                    theme.markUsed(var_name);
                    css_value = try std.fmt.allocPrint(alloc, "var({s})", .{var_name});
                } else {
                    return null;
                }
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "box-shadow", .value = css_value };
    return decls;
}

// ─── Ring Offset ───────────────────────────────────────────────────────────

fn resolveRingOffset(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    _ = modifier;
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            // Check if it's a color
            if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                const color_val = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-ring-offset-color", .value = color_val };
                return decls;
            }
            // Otherwise it's a width
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
            } else {
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "--tw-ring-offset-width", .value = css_value };
    return decls;
}

// ─── Inset Ring ────────────────────────────────────────────────────────────

fn resolveInsetRing(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    _ = modifier;
    const val = value orelse {
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "box-shadow", .value = "inset 0 0 0 1px currentColor" };
        return decls;
    };
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            // Check if it's a color
            if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                const color_val = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-inset-ring-color", .value = color_val };
                return decls;
            }
            // Width
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "inset 0 0 0 {s}px currentColor", .{val.value});
            } else {
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "box-shadow", .value = css_value };
    return decls;
}

// ─── Text Shadow ───────────────────────────────────────────────────────────

fn resolveTextShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "0 0 #0000";
            } else {
                const var_name = try std.fmt.allocPrint(alloc, "--text-shadow-{s}", .{val.value});
                if (theme.get(var_name) != null) {
                    theme.markUsed(var_name);
                    css_value = try std.fmt.allocPrint(alloc, "var({s})", .{var_name});
                } else {
                    return null;
                }
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "text-shadow", .value = css_value };
    return decls;
}

// ─── Font Weight (standalone) ──────────────────────────────────────────────

fn resolveFontWeight(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            const var_name = try std.fmt.allocPrint(alloc, "--font-weight-{s}", .{val.value});
            if (theme.get(var_name) != null) {
                theme.markUsed(var_name);
                css_value = try std.fmt.allocPrint(alloc, "var({s})", .{var_name});
            } else if (isPositiveInteger(val.value)) {
                css_value = val.value;
            } else {
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "font-weight", .value = css_value };
    return decls;
}

// ─── Drop Shadow ───────────────────────────────────────────────────────────

fn resolveDropShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // bare drop-shadow = default
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "filter", .value = "drop-shadow(0 1px 2px rgb(0 0 0 / 0.1)) drop-shadow(0 1px 1px rgb(0 0 0 / 0.06))" };
        return decls;
    };
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = try std.fmt.allocPrint(alloc, "drop-shadow({s})", .{val.value});
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "drop-shadow(0 0 #0000)";
            } else {
                const var_name = try std.fmt.allocPrint(alloc, "--drop-shadow-{s}", .{val.value});
                if (theme.get(var_name) != null) {
                    theme.markUsed(var_name);
                    css_value = try std.fmt.allocPrint(alloc, "drop-shadow(var({s}))", .{var_name});
                } else {
                    return null;
                }
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "filter", .value = css_value };
    return decls;
}

// ─── Border Spacing ────────────────────────────────────────────────────────

fn resolveBorderSpacing(alloc: Allocator, root: []const u8, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (isValidSpacingMultiplier(val.value)) {
                theme.markUsed("--spacing");
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
            } else if (std.mem.eql(u8, val.value, "px")) {
                css_value = "1px";
            } else if (std.mem.eql(u8, val.value, "0")) {
                css_value = "0";
            } else {
                return null;
            }
        },
    }

    if (std.mem.eql(u8, root, "border-spacing-x")) {
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "border-spacing", .value = try std.fmt.allocPrint(alloc, "{s} 0", .{css_value}) };
        return decls;
    }
    if (std.mem.eql(u8, root, "border-spacing-y")) {
        const decls = try alloc.alloc(Declaration, 1);
        decls[0] = Declaration{ .property = "border-spacing", .value = try std.fmt.allocPrint(alloc, "0 {s}", .{css_value}) };
        return decls;
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "border-spacing", .value = try std.fmt.allocPrint(alloc, "{s} {s}", .{ css_value, css_value }) };
    return decls;
}

// ─── Text Indent ───────────────────────────────────────────────────────────

fn resolveIndent(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "px")) {
                css_value = "1px";
            } else if (isValidSpacingMultiplier(val.value)) {
                theme.markUsed("--spacing");
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
            } else {
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "text-indent", .value = css_value };
    return decls;
}

// ─── Decoration Thickness ──────────────────────────────────────────────────

fn resolveDecorationThickness(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (std.mem.eql(u8, val.value, "from-font")) {
                css_value = "from-font";
            } else if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
            } else {
                // Try as color (decoration-red-500) - delegate to color handler
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "text-decoration-thickness", .value = css_value };
    return decls;
}

// ─── Shadow Color ──────────────────────────────────────────────────────────

fn resolveShadowColor(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "inherit")) {
                css_value = "inherit";
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                css_value = "transparent";
            } else if (std.mem.eql(u8, val.value, "current")) {
                css_value = "currentColor";
            } else if (theme.resolve(val.value, "--color") != null) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }
    if (modifier) |mod| {
        css_value = try applyColorOpacity(alloc, css_value, mod);
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "--tw-shadow-color", .value = css_value };
    return decls;
}

// ─── Tests ─────────────────────────────────────────────────────────────────

test "lookupStatic: flex" {
    const decls = lookupStatic("flex");
    try std.testing.expect(decls != null);
    try std.testing.expectEqualStrings("display", decls.?[0].property);
    try std.testing.expectEqualStrings("flex", decls.?[0].value);
}

test "lookupStatic: sr-only" {
    const decls = lookupStatic("sr-only");
    try std.testing.expect(decls != null);
    try std.testing.expect(decls.?.len >= 8);
}

test "lookupStatic: unknown" {
    const decls = lookupStatic("nonexistent");
    try std.testing.expect(decls == null);
}

test "isStaticUtility" {
    try std.testing.expect(isStaticUtility("flex"));
    try std.testing.expect(isStaticUtility("hidden"));
    try std.testing.expect(isStaticUtility("sr-only"));
    try std.testing.expect(!isStaticUtility("bg"));
    try std.testing.expect(!isStaticUtility("nonexistent"));
}

test "isFunctionalUtility" {
    try std.testing.expect(isFunctionalUtility("bg"));
    try std.testing.expect(isFunctionalUtility("p"));
    try std.testing.expect(isFunctionalUtility("text"));
    try std.testing.expect(isFunctionalUtility("z"));
    try std.testing.expect(!isFunctionalUtility("flex"));
    try std.testing.expect(!isFunctionalUtility("nonexistent"));
}

test "isValidSpacingMultiplier" {
    try std.testing.expect(isValidSpacingMultiplier("4"));
    try std.testing.expect(isValidSpacingMultiplier("0.5"));
    try std.testing.expect(isValidSpacingMultiplier("2.5"));
    try std.testing.expect(isValidSpacingMultiplier("100"));
    try std.testing.expect(!isValidSpacingMultiplier(""));
    try std.testing.expect(!isValidSpacingMultiplier("abc"));
    try std.testing.expect(!isValidSpacingMultiplier("1.2.3"));
}
