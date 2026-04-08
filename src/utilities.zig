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
const color_mod = @import("color.zig");

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

const COMPOSABLE_FONT_VARIANT_NUMERIC = "var(--tw-ordinal,) var(--tw-slashed-zero,) var(--tw-numeric-figure,) var(--tw-numeric-spacing,) var(--tw-numeric-fraction,)";

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
    .{ "touch-pan-x", &[_]Declaration{
        .{ .property = "--tw-pan-x", .value = "pan-x" },
        .{ .property = "touch-action", .value = "var(--tw-pan-x,) var(--tw-pan-y,) var(--tw-pinch-zoom,)" },
    } },
    .{ "touch-pan-left", &[_]Declaration{.{ .property = "touch-action", .value = "pan-left" }} },
    .{ "touch-pan-right", &[_]Declaration{.{ .property = "touch-action", .value = "pan-right" }} },
    .{ "touch-pan-y", &[_]Declaration{
        .{ .property = "--tw-pan-y", .value = "pan-y" },
        .{ .property = "touch-action", .value = "var(--tw-pan-x,) var(--tw-pan-y,) var(--tw-pinch-zoom,)" },
    } },
    .{ "touch-pan-up", &[_]Declaration{.{ .property = "touch-action", .value = "pan-up" }} },
    .{ "touch-pan-down", &[_]Declaration{.{ .property = "touch-action", .value = "pan-down" }} },
    .{ "touch-pinch-zoom", &[_]Declaration{
        .{ .property = "--tw-pinch-zoom", .value = "pinch-zoom" },
        .{ .property = "touch-action", .value = "var(--tw-pan-x,) var(--tw-pan-y,) var(--tw-pinch-zoom,)" },
    } },
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
    .{ "flex-1", &[_]Declaration{.{ .property = "flex", .value = "1" }} },
    .{ "flex-auto", &[_]Declaration{.{ .property = "flex", .value = "auto" }} },
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
        .{ .property = "text-overflow", .value = "ellipsis" },
        .{ .property = "white-space", .value = "nowrap" },
        .{ .property = "overflow", .value = "hidden" },
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
    .{ "hyphens-none", &[_]Declaration{
        .{ .property = "-webkit-hyphens", .value = "none" },
        .{ .property = "hyphens", .value = "none" },
    } },
    .{ "hyphens-manual", &[_]Declaration{
        .{ .property = "-webkit-hyphens", .value = "manual" },
        .{ .property = "hyphens", .value = "manual" },
    } },
    .{ "hyphens-auto", &[_]Declaration{
        .{ .property = "-webkit-hyphens", .value = "auto" },
        .{ .property = "hyphens", .value = "auto" },
    } },

    // ─── Font Style ───
    .{ "italic", &[_]Declaration{.{ .property = "font-style", .value = "italic" }} },
    .{ "not-italic", &[_]Declaration{.{ .property = "font-style", .value = "normal" }} },

    // ─── Font Variant Numeric ───
    .{ "normal-nums", &[_]Declaration{.{ .property = "font-variant-numeric", .value = "normal" }} },
    .{ "ordinal", &[_]Declaration{ .{ .property = "--tw-ordinal", .value = "ordinal" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "slashed-zero", &[_]Declaration{ .{ .property = "--tw-slashed-zero", .value = "slashed-zero" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "lining-nums", &[_]Declaration{ .{ .property = "--tw-numeric-figure", .value = "lining-nums" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "oldstyle-nums", &[_]Declaration{ .{ .property = "--tw-numeric-figure", .value = "oldstyle-nums" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "proportional-nums", &[_]Declaration{ .{ .property = "--tw-numeric-spacing", .value = "proportional-nums" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "tabular-nums", &[_]Declaration{ .{ .property = "--tw-numeric-spacing", .value = "tabular-nums" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "diagonal-fractions", &[_]Declaration{ .{ .property = "--tw-numeric-fraction", .value = "diagonal-fractions" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },
    .{ "stacked-fractions", &[_]Declaration{ .{ .property = "--tw-numeric-fraction", .value = "stacked-fractions" }, .{ .property = "font-variant-numeric", .value = COMPOSABLE_FONT_VARIANT_NUMERIC } } },

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
    .{ "bg-clip-text", &[_]Declaration{ .{ .property = "-webkit-background-clip", .value = "text" }, .{ .property = "background-clip", .value = "text" } } },

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
    .{ "border-solid", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "solid" },
        .{ .property = "border-style", .value = "solid" },
    } },
    .{ "border-dashed", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "dashed" },
        .{ .property = "border-style", .value = "dashed" },
    } },
    .{ "border-dotted", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "dotted" },
        .{ .property = "border-style", .value = "dotted" },
    } },
    .{ "border-double", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "double" },
        .{ .property = "border-style", .value = "double" },
    } },
    .{ "border-hidden", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "hidden" },
        .{ .property = "border-style", .value = "hidden" },
    } },
    .{ "border-none", &[_]Declaration{
        .{ .property = "--tw-border-style", .value = "none" },
        .{ .property = "border-style", .value = "none" },
    } },

    // ─── Outline Style ───
    .{ "outline-none", &[_]Declaration{ .{ .property = "outline", .value = "2px solid #0000" }, .{ .property = "outline-offset", .value = "2px" } } },
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
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
    } },
    .{ "transition", &[_]Declaration{
        .{ .property = "transition-property", .value = "color,background-color,border-color,outline-color,text-decoration-color,fill,stroke,--tw-gradient-from,--tw-gradient-via,--tw-gradient-to,opacity,box-shadow,transform,translate,scale,rotate,filter,-webkit-backdrop-filter,backdrop-filter,display,content-visibility,overlay,pointer-events" },
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
    } },
    .{ "transition-colors", &[_]Declaration{
        .{ .property = "transition-property", .value = "color,background-color,border-color,outline-color,text-decoration-color,fill,stroke,--tw-gradient-from,--tw-gradient-via,--tw-gradient-to" },
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
    } },
    .{ "transition-opacity", &[_]Declaration{
        .{ .property = "transition-property", .value = "opacity" },
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
    } },
    .{ "transition-shadow", &[_]Declaration{
        .{ .property = "transition-property", .value = "box-shadow" },
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
    } },
    .{ "transition-transform", &[_]Declaration{
        .{ .property = "transition-property", .value = "transform,translate,scale,rotate" },
        .{ .property = "transition-timing-function", .value = "var(--tw-ease,var(--default-transition-timing-function))" },
        .{ .property = "transition-duration", .value = "var(--tw-duration,var(--default-transition-duration))" },
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
        .{ .property = "clip-path", .value = "inset(50%)" },
        .{ .property = "white-space", .value = "nowrap" },
        .{ .property = "border-width", .value = "0" },
        .{ .property = "width", .value = "1px" },
        .{ .property = "height", .value = "1px" },
        .{ .property = "margin", .value = "-1px" },
        .{ .property = "padding", .value = "0" },
        .{ .property = "position", .value = "absolute" },
        .{ .property = "overflow", .value = "hidden" },
    } },
    .{ "not-sr-only", &[_]Declaration{
        .{ .property = "position", .value = "static" },
        .{ .property = "width", .value = "auto" },
        .{ .property = "height", .value = "auto" },
        .{ .property = "padding", .value = "0" },
        .{ .property = "margin", .value = "0" },
        .{ .property = "overflow", .value = "visible" },
        .{ .property = "white-space", .value = "normal" },
        .{ .property = "clip-path", .value = "none" },
    } },

    // ─── Field Sizing ───
    .{ "field-sizing-content", &[_]Declaration{.{ .property = "field-sizing", .value = "content" }} },
    .{ "field-sizing-fixed", &[_]Declaration{.{ .property = "field-sizing", .value = "fixed" }} },

    // ─── Scroll Behavior ───
    .{ "scroll-auto", &[_]Declaration{.{ .property = "scroll-behavior", .value = "auto" }} },
    .{ "scroll-smooth", &[_]Declaration{.{ .property = "scroll-behavior", .value = "smooth" }} },

    // ─── Scroll Snap Type ───
    .{ "snap-none", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "none" }} },
    .{ "snap-x", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "x var(--tw-scroll-snap-strictness)" }} },
    .{ "snap-y", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "y var(--tw-scroll-snap-strictness)" }} },
    .{ "snap-both", &[_]Declaration{.{ .property = "scroll-snap-type", .value = "both var(--tw-scroll-snap-strictness)" }} },
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
    .{ "transform-gpu", &[_]Declaration{.{ .property = "transform", .value = "translateZ(0) var(--tw-rotate-x,) var(--tw-rotate-y,) var(--tw-rotate-z,) var(--tw-skew-x,) var(--tw-skew-y,)" }} },
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
    .{ "shadow-inner", &[_]Declaration{
        .{ .property = "--tw-shadow", .value = "inset 0 2px 4px 0 var(--tw-shadow-color,#0000000d)" },
        .{ .property = "box-shadow", .value = "var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)" },
    } },
    .{ "inset-shadow-none", &[_]Declaration{.{ .property = "box-shadow", .value = "0 0 #0000" }} },
    .{ "inset-shadow-initial", &[_]Declaration{.{ .property = "box-shadow", .value = "var(--tw-inset-shadow)" }} },
    .{ "text-shadow-none", &[_]Declaration{.{ .property = "text-shadow", .value = "none" }} },
    .{ "text-shadow-initial", &[_]Declaration{.{ .property = "text-shadow", .value = "var(--tw-text-shadow)" }} },
    .{ "ring-inset", &[_]Declaration{.{ .property = "--tw-ring-inset", .value = "inset" }} },

    // ─── Outline ───
    .{ "outline-hidden", &[_]Declaration{.{ .property = "outline-color", .value = "#0000" }} },

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

    // ─── Mask Clip ───
    .{ "mask-clip-border", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "border-box" }, .{ .property = "mask-clip", .value = "border-box" } } },
    .{ "mask-clip-padding", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "padding-box" }, .{ .property = "mask-clip", .value = "padding-box" } } },
    .{ "mask-clip-content", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "content-box" }, .{ .property = "mask-clip", .value = "content-box" } } },
    .{ "mask-clip-fill", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "fill-box" }, .{ .property = "mask-clip", .value = "fill-box" } } },
    .{ "mask-clip-stroke", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "stroke-box" }, .{ .property = "mask-clip", .value = "stroke-box" } } },
    .{ "mask-clip-view", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "view-box" }, .{ .property = "mask-clip", .value = "view-box" } } },
    .{ "mask-clip-no-clip", &[_]Declaration{ .{ .property = "-webkit-mask-clip", .value = "no-clip" }, .{ .property = "mask-clip", .value = "no-clip" } } },

    // ─── Mask Origin ───
    .{ "mask-origin-border", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "border-box" }, .{ .property = "mask-origin", .value = "border-box" } } },
    .{ "mask-origin-padding", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "padding-box" }, .{ .property = "mask-origin", .value = "padding-box" } } },
    .{ "mask-origin-content", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "content-box" }, .{ .property = "mask-origin", .value = "content-box" } } },
    .{ "mask-origin-fill", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "fill-box" }, .{ .property = "mask-origin", .value = "fill-box" } } },
    .{ "mask-origin-stroke", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "stroke-box" }, .{ .property = "mask-origin", .value = "stroke-box" } } },
    .{ "mask-origin-view", &[_]Declaration{ .{ .property = "-webkit-mask-origin", .value = "view-box" }, .{ .property = "mask-origin", .value = "view-box" } } },

    // ─── Mask Mode ───
    .{ "mask-mode-alpha", &[_]Declaration{.{ .property = "mask-mode", .value = "alpha" }} },
    .{ "mask-mode-luminance", &[_]Declaration{.{ .property = "mask-mode", .value = "luminance" }} },
    .{ "mask-mode-match", &[_]Declaration{.{ .property = "mask-mode", .value = "match-source" }} },

    // ─── Mask Composite ───
    .{ "mask-composite-add", &[_]Declaration{ .{ .property = "-webkit-mask-composite", .value = "source-over" }, .{ .property = "mask-composite", .value = "add" } } },
    .{ "mask-composite-subtract", &[_]Declaration{ .{ .property = "-webkit-mask-composite", .value = "source-out" }, .{ .property = "mask-composite", .value = "subtract" } } },
    .{ "mask-composite-intersect", &[_]Declaration{ .{ .property = "-webkit-mask-composite", .value = "source-in" }, .{ .property = "mask-composite", .value = "intersect" } } },
    .{ "mask-composite-exclude", &[_]Declaration{ .{ .property = "-webkit-mask-composite", .value = "xor" }, .{ .property = "mask-composite", .value = "exclude" } } },

    // ─── Mask Type ───
    .{ "mask-type-alpha", &[_]Declaration{.{ .property = "mask-type", .value = "alpha" }} },
    .{ "mask-type-luminance", &[_]Declaration{.{ .property = "mask-type", .value = "luminance" }} },

    // ─── Mask Repeat ───
    .{ "mask-repeat", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "repeat" }, .{ .property = "mask-repeat", .value = "repeat" } } },
    .{ "mask-no-repeat", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "no-repeat" }, .{ .property = "mask-repeat", .value = "no-repeat" } } },
    .{ "mask-repeat-x", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "repeat-x" }, .{ .property = "mask-repeat", .value = "repeat-x" } } },
    .{ "mask-repeat-y", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "repeat-y" }, .{ .property = "mask-repeat", .value = "repeat-y" } } },
    .{ "mask-repeat-round", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "round" }, .{ .property = "mask-repeat", .value = "round" } } },
    .{ "mask-repeat-space", &[_]Declaration{ .{ .property = "-webkit-mask-repeat", .value = "space" }, .{ .property = "mask-repeat", .value = "space" } } },

    // ─── Mask Size ───
    .{ "mask-auto", &[_]Declaration{ .{ .property = "-webkit-mask-size", .value = "auto" }, .{ .property = "mask-size", .value = "auto" } } },
    .{ "mask-cover", &[_]Declaration{ .{ .property = "-webkit-mask-size", .value = "cover" }, .{ .property = "mask-size", .value = "cover" } } },
    .{ "mask-contain", &[_]Declaration{ .{ .property = "-webkit-mask-size", .value = "contain" }, .{ .property = "mask-size", .value = "contain" } } },

    // ─── Mask Position ───
    .{ "mask-center", &[_]Declaration{ .{ .property = "-webkit-mask-position", .value = "center" }, .{ .property = "mask-position", .value = "center" } } },
    .{ "mask-top", &[_]Declaration{ .{ .property = "-webkit-mask-position", .value = "top" }, .{ .property = "mask-position", .value = "top" } } },
    .{ "mask-bottom", &[_]Declaration{ .{ .property = "-webkit-mask-position", .value = "bottom" }, .{ .property = "mask-position", .value = "bottom" } } },
    .{ "mask-left", &[_]Declaration{ .{ .property = "-webkit-mask-position", .value = "left" }, .{ .property = "mask-position", .value = "left" } } },
    .{ "mask-right", &[_]Declaration{ .{ .property = "-webkit-mask-position", .value = "right" }, .{ .property = "mask-position", .value = "right" } } },
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
    // Logical property spacing
    .{ "mbs", {} },
    .{ "mbe", {} },
    .{ "pbs", {} },
    .{ "pbe", {} },
    .{ "-mbs", {} },
    .{ "-mbe", {} },
    .{ "mis", {} },
    .{ "mie", {} },
    .{ "-mis", {} },
    .{ "-mie", {} },
    .{ "inline", {} },
    .{ "min-inline", {} },
    .{ "max-inline", {} },
    .{ "block", {} },
    .{ "min-block", {} },
    .{ "max-block", {} },
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
    .{ "rotate-x", {} },
    .{ "rotate-y", {} },
    .{ "rotate-z", {} },
    .{ "-rotate-x", {} },
    .{ "-rotate-y", {} },
    .{ "-rotate-z", {} },
    .{ "scale", {} },
    .{ "scale-x", {} },
    .{ "scale-y", {} },
    .{ "scale-z", {} },
    .{ "translate-x", {} },
    .{ "translate-y", {} },
    .{ "translate-z", {} },
    .{ "-translate-x", {} },
    .{ "-translate-y", {} },
    .{ "-translate-z", {} },
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

// ─── Default Value Roots ───────────────────────────────────────────────────

/// Check if a functional utility root has a default value when used bare (no value).
/// e.g. `ring` -> 1px, `blur` -> 8px, `border` -> 1px, `shadow` -> default shadow.
pub fn hasDefaultValue(root: []const u8) bool {
    return default_value_roots.has(root);
}

const default_value_roots = std.StaticStringMap(void).initComptime(.{
    .{ "ring", {} },
    .{ "blur", {} },
    .{ "shadow", {} },
    .{ "border", {} },
    .{ "border-x", {} },
    .{ "border-y", {} },
    .{ "border-t", {} },
    .{ "border-r", {} },
    .{ "border-b", {} },
    .{ "border-l", {} },
    .{ "border-s", {} },
    .{ "border-e", {} },
    .{ "outline", {} },
    .{ "drop-shadow", {} },
    .{ "divide-x", {} },
    .{ "divide-y", {} },
    .{ "inset-ring", {} },
    .{ "grayscale", {} },
    .{ "invert", {} },
    .{ "sepia", {} },
    .{ "backdrop-grayscale", {} },
    .{ "backdrop-invert", {} },
    .{ "backdrop-sepia", {} },
    .{ "backdrop-blur", {} },
    .{ "inset-shadow", {} },
    .{ "container", {} },
});

// ─── Fraction Support ──────────────────────────────────────────────────────

/// Check if a functional utility root supports fraction values (e.g. w-1/2, aspect-4/3).
pub fn supportsFraction(root: []const u8) bool {
    return fraction_support.has(root);
}

const fraction_support = std.StaticStringMap(void).initComptime(.{
    // Sizing
    .{ "w", {} },
    .{ "h", {} },
    .{ "size", {} },
    .{ "min-w", {} },
    .{ "min-h", {} },
    .{ "max-w", {} },
    .{ "max-h", {} },
    // Logical sizing
    .{ "inline", {} },
    .{ "block", {} },
    .{ "min-inline", {} },
    .{ "min-block", {} },
    .{ "max-inline", {} },
    .{ "max-block", {} },
    // Aspect ratio
    .{ "aspect", {} },
    // Translate
    .{ "translate-x", {} },
    .{ "translate-y", {} },
    .{ "-translate-x", {} },
    .{ "-translate-y", {} },
    // Inset / position
    .{ "inset", {} },
    .{ "inset-x", {} },
    .{ "inset-y", {} },
    .{ "top", {} },
    .{ "right", {} },
    .{ "bottom", {} },
    .{ "left", {} },
    .{ "inset-s", {} },
    .{ "inset-e", {} },
    .{ "-inset", {} },
    .{ "-inset-x", {} },
    .{ "-inset-y", {} },
    .{ "-top", {} },
    .{ "-right", {} },
    .{ "-bottom", {} },
    .{ "-left", {} },
    .{ "-inset-s", {} },
    .{ "-inset-e", {} },
    // Grid spans
    .{ "col-span", {} },
    .{ "row-span", {} },
    // Basis
    .{ "basis", {} },
});

// ─── Modifier & Negative Support ───────────────────────────────────────────

/// Check if a functional utility root supports modifiers (e.g., opacity via /50).
/// Only color utilities, gradient stops, and a few others accept modifiers.
pub fn supportsModifier(root: []const u8) bool {
    return modifier_support.has(root);
}

/// Validate that a named modifier value is numeric (valid for color opacity).
/// Accepts integers (0-100) and valid decimals (2.5, 0.5, etc.).
pub fn isValidNamedModifier(value: []const u8) bool {
    if (value.len == 0) return false;
    var has_dot = false;
    for (value) |c| {
        if (c == '.') {
            if (has_dot) return false;
            has_dot = true;
        } else if (c < '0' or c > '9') {
            return false;
        }
    }
    // Reject trailing dot: "25."
    if (value[value.len - 1] == '.') return false;
    return true;
}

const modifier_support = std.StaticStringMap(void).initComptime(.{
    // Color utilities (accept opacity modifier)
    .{ "bg", {} },
    .{ "text", {} },
    .{ "border", {} },
    .{ "border-x", {} },
    .{ "border-y", {} },
    .{ "border-s", {} },
    .{ "border-e", {} },
    .{ "border-t", {} },
    .{ "border-r", {} },
    .{ "border-b", {} },
    .{ "border-l", {} },
    .{ "accent", {} },
    .{ "caret", {} },
    .{ "fill", {} },
    .{ "stroke", {} },
    .{ "outline-color", {} },
    .{ "outline", {} },
    .{ "decoration", {} },
    .{ "shadow-color", {} },
    .{ "shadow", {} },
    .{ "divide", {} },
    .{ "placeholder", {} },
    .{ "ring", {} },
    .{ "ring-offset", {} },
    .{ "inset-ring", {} },
    .{ "inset-shadow", {} },
    .{ "text-shadow", {} },
    .{ "from", {} },
    .{ "via", {} },
    .{ "to", {} },
    .{ "drop-shadow", {} },
    // Gradient utilities with position modifiers
    .{ "bg-linear", {} },
    .{ "bg-radial", {} },
    .{ "bg-conic", {} },
    .{ "bg-gradient", {} },
    .{ "-bg-linear", {} },
    .{ "-bg-conic", {} },
});

/// Check if a functional utility root supports the negative prefix.
/// Only spacing (margin, inset), transforms, z-index, order, and a few others.
pub fn supportsNegative(root: []const u8) bool {
    return negative_support.has(root);
}

const negative_support = std.StaticStringMap(void).initComptime(.{
    // Margin
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
    // Logical margin
    .{ "mbs", {} },
    .{ "mbe", {} },
    .{ "mis", {} },
    .{ "mie", {} },
    .{ "-mbs", {} },
    .{ "-mbe", {} },
    .{ "-mis", {} },
    .{ "-mie", {} },
    // Inset / position
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
    // Transforms
    .{ "rotate", {} },
    .{ "rotate-x", {} },
    .{ "rotate-y", {} },
    .{ "rotate-z", {} },
    .{ "-rotate", {} },
    .{ "-rotate-x", {} },
    .{ "-rotate-y", {} },
    .{ "-rotate-z", {} },
    .{ "translate-x", {} },
    .{ "translate-y", {} },
    .{ "translate-z", {} },
    .{ "-translate-x", {} },
    .{ "-translate-y", {} },
    .{ "-translate-z", {} },
    .{ "skew-x", {} },
    .{ "skew-y", {} },
    .{ "-skew-x", {} },
    .{ "-skew-y", {} },
    .{ "scale", {} },
    .{ "scale-x", {} },
    .{ "scale-y", {} },
    .{ "scale-z", {} },
    // Z-index, order
    .{ "z", {} },
    .{ "-z", {} },
    .{ "order", {} },
    .{ "-order", {} },
    // Scroll margin
    .{ "scroll-m", {} },
    .{ "scroll-mx", {} },
    .{ "scroll-my", {} },
    .{ "scroll-ms", {} },
    .{ "scroll-me", {} },
    .{ "scroll-mt", {} },
    .{ "scroll-mr", {} },
    .{ "scroll-mb", {} },
    .{ "scroll-ml", {} },
    // Text indent
    .{ "indent", {} },
    .{ "-indent", {} },
    // Outline offset
    .{ "outline-offset", {} },
    // Hue rotate
    .{ "hue-rotate", {} },
    .{ "backdrop-hue-rotate", {} },
    // Underline offset
    .{ "underline-offset", {} },
    // Gradient direction (supports negative rotation)
    .{ "bg-linear", {} },
    .{ "bg-conic", {} },
    .{ "-bg-linear", {} },
    .{ "-bg-conic", {} },
    // Space between (reverse)
    .{ "space-x", {} },
    .{ "space-y", {} },
});

// ─── @property Registration ────────────────────────────────────────────────

/// Return any @property declarations needed for a given utility root.
pub fn getRequiredProperties(root: []const u8) []const AtProperty {
    // shadow utilities
    if (std.mem.eql(u8, root, "shadow") or std.mem.eql(u8, root, "shadow-inner")) {
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
    // scale-z
    if (std.mem.eql(u8, root, "scale-z")) {
        return &[_]AtProperty{
            .{ .name = "--tw-scale-z", .syntax = "*", .inherits = false, .initial_value = "1" },
        };
    }
    // rotate axis (3D)
    if (std.mem.eql(u8, root, "rotate-x") or std.mem.eql(u8, root, "-rotate-x")) {
        return &[_]AtProperty{
            .{ .name = "--tw-rotate-x", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    if (std.mem.eql(u8, root, "rotate-y") or std.mem.eql(u8, root, "-rotate-y")) {
        return &[_]AtProperty{
            .{ .name = "--tw-rotate-y", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    if (std.mem.eql(u8, root, "rotate-z") or std.mem.eql(u8, root, "-rotate-z")) {
        return &[_]AtProperty{
            .{ .name = "--tw-rotate-z", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    // translate-z (3D)
    if (std.mem.eql(u8, root, "translate-z") or std.mem.eql(u8, root, "-translate-z")) {
        return &[_]AtProperty{
            .{ .name = "--tw-translate-z", .syntax = "*", .inherits = false, .initial_value = "0" },
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
            .{ .name = "--tw-ring-offset-shadow", .syntax = "*", .inherits = false, .initial_value = "0 0 #0000" },
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
            .{ .name = "--tw-drop-shadow", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-drop-shadow-color", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-drop-shadow-alpha", .syntax = "<percentage>", .inherits = false, .initial_value = "100%" },
            .{ .name = "--tw-drop-shadow-size", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    // gradient
    if (std.mem.eql(u8, root, "from") or std.mem.eql(u8, root, "via") or std.mem.eql(u8, root, "to") or
        std.mem.eql(u8, root, "bg-linear") or std.mem.eql(u8, root, "bg-radial") or std.mem.eql(u8, root, "bg-conic") or
        std.mem.eql(u8, root, "bg-gradient"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-gradient-from", .syntax = "<color>", .inherits = false, .initial_value = "#0000" },
            .{ .name = "--tw-gradient-via", .syntax = "<color>", .inherits = false, .initial_value = "#0000" },
            .{ .name = "--tw-gradient-to", .syntax = "<color>", .inherits = false, .initial_value = "#0000" },
            .{ .name = "--tw-gradient-stops", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-position", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-via-stops", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-gradient-from-position", .syntax = "<length-percentage>", .inherits = false, .initial_value = "0%" },
            .{ .name = "--tw-gradient-via-position", .syntax = "<length-percentage>", .inherits = false, .initial_value = "50%" },
            .{ .name = "--tw-gradient-to-position", .syntax = "<length-percentage>", .inherits = false, .initial_value = "100%" },
        };
    }
    // leading (line-height)
    if (std.mem.eql(u8, root, "leading")) {
        return &[_]AtProperty{
            .{ .name = "--tw-leading", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    // tracking (letter-spacing)
    if (std.mem.eql(u8, root, "tracking")) {
        return &[_]AtProperty{
            .{ .name = "--tw-tracking", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    // border-spacing
    if (std.mem.eql(u8, root, "border-spacing") or
        std.mem.eql(u8, root, "border-spacing-x") or
        std.mem.eql(u8, root, "border-spacing-y"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-border-spacing-x", .syntax = "<length>", .inherits = false, .initial_value = "0" },
            .{ .name = "--tw-border-spacing-y", .syntax = "<length>", .inherits = false, .initial_value = "0" },
        };
    }
    // font-variant-numeric composable properties
    if (std.mem.eql(u8, root, "ordinal") or
        std.mem.eql(u8, root, "slashed-zero") or
        std.mem.eql(u8, root, "lining-nums") or
        std.mem.eql(u8, root, "oldstyle-nums") or
        std.mem.eql(u8, root, "proportional-nums") or
        std.mem.eql(u8, root, "tabular-nums") or
        std.mem.eql(u8, root, "diagonal-fractions") or
        std.mem.eql(u8, root, "stacked-fractions"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-ordinal", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-slashed-zero", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-numeric-figure", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-numeric-spacing", .syntax = "*", .inherits = false, .initial_value = null },
            .{ .name = "--tw-numeric-fraction", .syntax = "*", .inherits = false, .initial_value = null },
        };
    }
    // outline (functional: width needs --tw-outline-style)
    if (std.mem.eql(u8, root, "outline")) {
        return &[_]AtProperty{
            .{ .name = "--tw-outline-style", .syntax = "*", .inherits = false, .initial_value = "solid" },
        };
    }
    // scroll snap strictness
    if (std.mem.eql(u8, root, "snap-x") or
        std.mem.eql(u8, root, "snap-y") or
        std.mem.eql(u8, root, "snap-both"))
    {
        return &[_]AtProperty{
            .{ .name = "--tw-scroll-snap-strictness", .syntax = "*", .inherits = false, .initial_value = "proximity" },
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

const ResolverTag = enum {
    spacing,
    color,
    decoration_dual,
    text,
    border,
    ring,
    font,
    leading,
    tracking,
    z_index,
    neg_z_index,
    opacity,
    order,
    neg_order,
    rounded,
    duration,
    delay,
    aspect,
    grid_template_cols,
    grid_template_rows,
    grid_col,
    grid_col_span,
    grid_col_start,
    grid_col_end,
    grid_row,
    grid_row_span,
    grid_row_start,
    grid_row_end,
    auto_cols,
    auto_rows,
    rotate,
    neg_rotate,
    rotate_axis,
    scale,
    scale_z,
    translate_x,
    neg_translate_x,
    translate_y,
    neg_translate_y,
    translate_z,
    skew_x,
    neg_skew_x,
    skew_y,
    neg_skew_y,
    shadow,
    shadow_color,
    inset_shadow,
    drop_shadow,
    blur,
    brightness,
    contrast,
    grayscale,
    invert,
    sepia,
    saturate,
    hue_rotate,
    backdrop_blur,
    backdrop_brightness,
    backdrop_contrast,
    backdrop_grayscale,
    backdrop_invert,
    backdrop_sepia,
    backdrop_saturate,
    backdrop_hue_rotate,
    backdrop_opacity,
    ease,
    animate,
    line_clamp,
    content,
    list,
    space_x,
    space_y,
    divide_x,
    divide_y,
    underline_offset,
    bg_gradient_dir,
    bg_gradient,
    gradient_stop,
    perspective,
    origin,
    columns,
    outline_offset,
    outline,
    grow,
    shrink,
    inset_ring,
    ring_offset,
    text_shadow,
    font_weight,
    mask_image,
    list_image,
    neg_bg_gradient_dir,
    mask_position,
    mask_size,
    mask_repeat,
    mask_type,
    bg_size,
    bg_position,
    font_stretch_fn,
    border_spacing,
    indent,
};

const functional_dispatch = std.StaticStringMap(ResolverTag).initComptime(.{
    // ── Spacing utilities ──
    .{ "p", .spacing },
    .{ "px", .spacing },
    .{ "py", .spacing },
    .{ "ps", .spacing },
    .{ "pe", .spacing },
    .{ "pt", .spacing },
    .{ "pr", .spacing },
    .{ "pb", .spacing },
    .{ "pl", .spacing },
    .{ "m", .spacing },
    .{ "mx", .spacing },
    .{ "my", .spacing },
    .{ "ms", .spacing },
    .{ "me", .spacing },
    .{ "mt", .spacing },
    .{ "mr", .spacing },
    .{ "mb", .spacing },
    .{ "ml", .spacing },
    .{ "-m", .spacing },
    .{ "-mx", .spacing },
    .{ "-my", .spacing },
    .{ "-ms", .spacing },
    .{ "-me", .spacing },
    .{ "-mt", .spacing },
    .{ "-mr", .spacing },
    .{ "-mb", .spacing },
    .{ "-ml", .spacing },
    .{ "w", .spacing },
    .{ "h", .spacing },
    .{ "min-w", .spacing },
    .{ "min-h", .spacing },
    .{ "max-w", .spacing },
    .{ "max-h", .spacing },
    .{ "size", .spacing },
    .{ "inset", .spacing },
    .{ "inset-x", .spacing },
    .{ "inset-y", .spacing },
    .{ "inset-s", .spacing },
    .{ "inset-e", .spacing },
    .{ "top", .spacing },
    .{ "right", .spacing },
    .{ "bottom", .spacing },
    .{ "left", .spacing },
    .{ "-inset", .spacing },
    .{ "-inset-x", .spacing },
    .{ "-inset-y", .spacing },
    .{ "-inset-s", .spacing },
    .{ "-inset-e", .spacing },
    .{ "-top", .spacing },
    .{ "-right", .spacing },
    .{ "-bottom", .spacing },
    .{ "-left", .spacing },
    .{ "gap", .spacing },
    .{ "gap-x", .spacing },
    .{ "gap-y", .spacing },
    .{ "scroll-m", .spacing },
    .{ "scroll-mx", .spacing },
    .{ "scroll-my", .spacing },
    .{ "scroll-ms", .spacing },
    .{ "scroll-me", .spacing },
    .{ "scroll-mt", .spacing },
    .{ "scroll-mr", .spacing },
    .{ "scroll-mb", .spacing },
    .{ "scroll-ml", .spacing },
    .{ "scroll-p", .spacing },
    .{ "scroll-px", .spacing },
    .{ "scroll-py", .spacing },
    .{ "scroll-ps", .spacing },
    .{ "scroll-pe", .spacing },
    .{ "scroll-pt", .spacing },
    .{ "scroll-pr", .spacing },
    .{ "scroll-pb", .spacing },
    .{ "scroll-pl", .spacing },
    .{ "basis", .spacing },
    // ── Logical property spacing utilities ──
    .{ "mbs", .spacing },
    .{ "mbe", .spacing },
    .{ "pbs", .spacing },
    .{ "pbe", .spacing },
    .{ "-mbs", .spacing },
    .{ "-mbe", .spacing },
    .{ "mis", .spacing },
    .{ "mie", .spacing },
    .{ "-mis", .spacing },
    .{ "-mie", .spacing },
    .{ "inline", .spacing },
    .{ "min-inline", .spacing },
    .{ "max-inline", .spacing },
    .{ "block", .spacing },
    .{ "min-block", .spacing },
    .{ "max-block", .spacing },
    // ── Color utilities ──
    .{ "bg", .color },
    .{ "accent", .color },
    .{ "caret", .color },
    .{ "fill", .color },
    .{ "stroke", .color },
    .{ "outline-color", .color },
    .{ "placeholder", .color },
    // ── Decoration (dual: thickness or color) ──
    .{ "decoration", .decoration_dual },
    // ── Text (dual: color or font-size) ──
    .{ "text", .text },
    // ── Border (dual: color or width) ──
    .{ "border", .border },
    .{ "border-x", .border },
    .{ "border-y", .border },
    .{ "border-s", .border },
    .{ "border-e", .border },
    .{ "border-t", .border },
    .{ "border-r", .border },
    .{ "border-b", .border },
    .{ "border-l", .border },
    // ── Ring ──
    .{ "ring", .ring },
    // ── Font (family + weight) ──
    .{ "font", .font },
    // ── Leading (line-height) ──
    .{ "leading", .leading },
    // ── Tracking (letter-spacing) ──
    .{ "tracking", .tracking },
    // ── Z-index ──
    .{ "z", .z_index },
    .{ "-z", .neg_z_index },
    // ── Opacity ──
    .{ "opacity", .opacity },
    // ── Order ──
    .{ "order", .order },
    .{ "-order", .neg_order },
    // ── Border radius ──
    .{ "rounded", .rounded },
    .{ "rounded-t", .rounded },
    .{ "rounded-r", .rounded },
    .{ "rounded-b", .rounded },
    .{ "rounded-l", .rounded },
    .{ "rounded-tl", .rounded },
    .{ "rounded-tr", .rounded },
    .{ "rounded-br", .rounded },
    .{ "rounded-bl", .rounded },
    .{ "rounded-s", .rounded },
    .{ "rounded-e", .rounded },
    .{ "rounded-ss", .rounded },
    .{ "rounded-se", .rounded },
    .{ "rounded-es", .rounded },
    .{ "rounded-ee", .rounded },
    // ── Duration ──
    .{ "duration", .duration },
    // ── Delay ──
    .{ "delay", .delay },
    // ── Aspect ratio ──
    .{ "aspect", .aspect },
    // ── Grid template columns/rows ──
    .{ "cols", .grid_template_cols },
    .{ "grid-cols", .grid_template_cols },
    .{ "rows", .grid_template_rows },
    .{ "grid-rows", .grid_template_rows },
    // ── Grid column/row placement ──
    .{ "col", .grid_col },
    .{ "col-span", .grid_col_span },
    .{ "col-start", .grid_col_start },
    .{ "col-end", .grid_col_end },
    .{ "row", .grid_row },
    .{ "row-span", .grid_row_span },
    .{ "row-start", .grid_row_start },
    .{ "row-end", .grid_row_end },
    // ── Grid auto columns/rows ──
    .{ "auto-cols", .auto_cols },
    .{ "auto-rows", .auto_rows },
    // ── Transform: rotate ──
    .{ "rotate", .rotate },
    .{ "-rotate", .neg_rotate },
    // ── Transform: rotate axis (3D) ──
    .{ "rotate-x", .rotate_axis },
    .{ "rotate-y", .rotate_axis },
    .{ "rotate-z", .rotate_axis },
    .{ "-rotate-x", .rotate_axis },
    .{ "-rotate-y", .rotate_axis },
    .{ "-rotate-z", .rotate_axis },
    // ── Transform: scale ──
    .{ "scale", .scale },
    .{ "scale-x", .scale },
    .{ "scale-y", .scale },
    .{ "scale-z", .scale_z },
    // ── Transform: translate ──
    .{ "translate-x", .translate_x },
    .{ "-translate-x", .neg_translate_x },
    .{ "translate-y", .translate_y },
    .{ "-translate-y", .neg_translate_y },
    // ── Transform: translate-z (3D) ──
    .{ "translate-z", .translate_z },
    .{ "-translate-z", .translate_z },
    // ── Transform: skew ──
    .{ "skew-x", .skew_x },
    .{ "-skew-x", .neg_skew_x },
    .{ "skew-y", .skew_y },
    .{ "-skew-y", .neg_skew_y },
    // ── Shadow ──
    .{ "shadow", .shadow },
    .{ "shadow-color", .shadow_color },
    // ── Inset shadow ──
    .{ "inset-shadow", .inset_shadow },
    // ── Drop shadow ──
    .{ "drop-shadow", .drop_shadow },
    // ── Filter utilities ──
    .{ "blur", .blur },
    .{ "brightness", .brightness },
    .{ "contrast", .contrast },
    .{ "grayscale", .grayscale },
    .{ "invert", .invert },
    .{ "sepia", .sepia },
    .{ "saturate", .saturate },
    .{ "hue-rotate", .hue_rotate },
    // ── Backdrop filter utilities ──
    .{ "backdrop-blur", .backdrop_blur },
    .{ "backdrop-brightness", .backdrop_brightness },
    .{ "backdrop-contrast", .backdrop_contrast },
    .{ "backdrop-grayscale", .backdrop_grayscale },
    .{ "backdrop-invert", .backdrop_invert },
    .{ "backdrop-sepia", .backdrop_sepia },
    .{ "backdrop-saturate", .backdrop_saturate },
    .{ "backdrop-hue-rotate", .backdrop_hue_rotate },
    .{ "backdrop-opacity", .backdrop_opacity },
    // ── Ease ──
    .{ "ease", .ease },
    // ── Animate ──
    .{ "animate", .animate },
    // ── Line clamp ──
    .{ "line-clamp", .line_clamp },
    // ── Content ──
    .{ "content", .content },
    // ── List style type ──
    .{ "list", .list },
    // ── Space between ──
    .{ "space-x", .space_x },
    .{ "space-y", .space_y },
    // ── Divide width ──
    .{ "divide-x", .divide_x },
    .{ "divide-y", .divide_y },
    // ── Divide color (handled as color) ──
    .{ "divide", .color },
    // ── Underline offset ──
    .{ "underline-offset", .underline_offset },
    // ── Gradient direction utilities ──
    .{ "bg-linear", .bg_gradient_dir },
    .{ "bg-radial", .bg_gradient_dir },
    .{ "bg-conic", .bg_gradient_dir },
    .{ "bg-gradient", .bg_gradient },
    // ── Gradient color stop utilities ──
    .{ "from", .gradient_stop },
    .{ "via", .gradient_stop },
    .{ "to", .gradient_stop },
    // ── Perspective ──
    .{ "perspective", .perspective },
    // ── Transform origin ──
    .{ "origin", .origin },
    // ── Columns ──
    .{ "columns", .columns },
    // ── Outline offset ──
    .{ "outline-offset", .outline_offset },
    // ── Outline (functional: width or color) ──
    .{ "outline", .outline },
    // ── Grow / Shrink ──
    .{ "grow", .grow },
    .{ "shrink", .shrink },
    // ── Inset ring ──
    .{ "inset-ring", .inset_ring },
    // ── Ring offset ──
    .{ "ring-offset", .ring_offset },
    // ── Text shadow ──
    .{ "text-shadow", .text_shadow },
    // ── Font weight (standalone) ──
    .{ "font-weight", .font_weight },
    // ── Mask image ──
    .{ "mask-image", .mask_image },
    // ── List image ──
    .{ "list-image", .list_image },
    // ── Negative gradient direction utilities ──
    .{ "-bg-linear", .neg_bg_gradient_dir },
    .{ "-bg-conic", .neg_bg_gradient_dir },
    // ── Mask utilities (single-property) ──
    .{ "mask-position", .mask_position },
    .{ "mask-size", .mask_size },
    .{ "mask-repeat", .mask_repeat },
    .{ "mask-type", .mask_type },
    // ── Background size/position ──
    .{ "bg-size", .bg_size },
    .{ "bg-position", .bg_position },
    // ── Font stretch ──
    .{ "font-stretch", .font_stretch_fn },
    // ── Border spacing ──
    .{ "border-spacing", .border_spacing },
    .{ "border-spacing-x", .border_spacing },
    .{ "border-spacing-y", .border_spacing },
    // ── Text indent ──
    .{ "indent", .indent },
    .{ "-indent", .indent },
});

/// Resolve a functional utility to CSS declarations.
pub fn resolveFunctional(
    alloc: Allocator,
    root: []const u8,
    value: ?Value,
    modifier: ?Modifier,
    theme: *Theme,
    negative: bool,
) !?[]const Declaration {
    const tag = functional_dispatch.get(root) orelse return null;

    return switch (tag) {
        .spacing => resolveSpacing(alloc, root, value, theme, negative),
        .decoration_dual => blk: {
            if (value) |val| {
                if (val.kind == .named and isPositiveInteger(val.value))
                    break :blk resolveDecorationThickness(alloc, value);
                if (val.kind == .named and (std.mem.eql(u8, val.value, "auto") or std.mem.eql(u8, val.value, "from-font")))
                    break :blk resolveDecorationThickness(alloc, value);
                if (val.kind == .arbitrary and looksLikeLength(val.value))
                    break :blk resolveDecorationThickness(alloc, value);
            }
            break :blk resolveColor(alloc, root, value, modifier, theme);
        },
        .color => resolveColor(alloc, root, value, modifier, theme),
        .text => resolveText(alloc, value, modifier, theme),
        .border => resolveBorder(alloc, root, value, modifier, theme),
        .ring => resolveRing(alloc, value, modifier, theme),
        .font => resolveFont(alloc, value, theme),
        .leading => resolveLeading(alloc, value, theme),
        .tracking => resolveTracking(alloc, value, theme),
        .z_index => resolveZIndex(alloc, value, negative),
        .neg_z_index => resolveZIndex(alloc, value, true),
        .opacity => resolveOpacity(alloc, value),
        .order => resolveOrder(alloc, value, negative),
        .neg_order => resolveOrder(alloc, value, true),
        .rounded => resolveRounded(alloc, root, value, theme),
        .duration => resolveDuration(alloc, value),
        .delay => resolveDelay(alloc, value),
        .aspect => resolveAspect(alloc, value, theme),
        .grid_template_cols => resolveGridTemplate(alloc, value, "grid-template-columns", theme),
        .grid_template_rows => resolveGridTemplate(alloc, value, "grid-template-rows", theme),
        .grid_col => resolveGridPlacement(alloc, value, "grid-column"),
        .grid_col_span => resolveGridSpan(alloc, value, "grid-column"),
        .grid_col_start => resolveGridStartEnd(alloc, value, "grid-column-start"),
        .grid_col_end => resolveGridStartEnd(alloc, value, "grid-column-end"),
        .grid_row => resolveGridPlacement(alloc, value, "grid-row"),
        .grid_row_span => resolveGridSpan(alloc, value, "grid-row"),
        .grid_row_start => resolveGridStartEnd(alloc, value, "grid-row-start"),
        .grid_row_end => resolveGridStartEnd(alloc, value, "grid-row-end"),
        .auto_cols => resolveGridAuto(alloc, value, "grid-auto-columns"),
        .auto_rows => resolveGridAuto(alloc, value, "grid-auto-rows"),
        .rotate => resolveRotate(alloc, value, negative),
        .neg_rotate => resolveRotate(alloc, value, true),
        .rotate_axis => resolveRotateAxis(alloc, root, value, negative),
        .scale => resolveScale(alloc, value, root),
        .scale_z => resolveScaleZ(alloc, value),
        .translate_x => resolveTranslate(alloc, value, "X", negative, theme),
        .neg_translate_x => resolveTranslate(alloc, value, "X", true, theme),
        .translate_y => resolveTranslate(alloc, value, "Y", negative, theme),
        .neg_translate_y => resolveTranslate(alloc, value, "Y", true, theme),
        .translate_z => resolveTranslateZ(alloc, root, value, negative, theme),
        .skew_x => resolveSkew(alloc, value, "X", negative),
        .neg_skew_x => resolveSkew(alloc, value, "X", true),
        .skew_y => resolveSkew(alloc, value, "Y", negative),
        .neg_skew_y => resolveSkew(alloc, value, "Y", true),
        .shadow => blk: {
            if (value) |val| {
                if (val.kind == .named) {
                    if (std.mem.eql(u8, val.value, "inherit") or
                        std.mem.eql(u8, val.value, "transparent") or
                        std.mem.eql(u8, val.value, "current") or
                        theme.resolve(val.value, "--color"))
                    {
                        break :blk resolveShadowColor(alloc, value, modifier, theme);
                    }
                }
            }
            break :blk resolveShadow(alloc, value, theme);
        },
        .shadow_color => resolveShadowColor(alloc, value, modifier, theme),
        .inset_shadow => resolveInsetShadow(alloc, value, theme),
        .drop_shadow => resolveDropShadow(alloc, value, theme),
        .blur => resolveFilterBlur(alloc, value, false, "--blur", theme),
        .brightness => resolveFilterPercent(alloc, value, false, "brightness"),
        .contrast => resolveFilterPercent(alloc, value, false, "contrast"),
        .grayscale => resolveFilterToggle(alloc, value, false, "grayscale"),
        .invert => resolveFilterToggle(alloc, value, false, "invert"),
        .sepia => resolveFilterToggle(alloc, value, false, "sepia"),
        .saturate => resolveFilterPercent(alloc, value, false, "saturate"),
        .hue_rotate => resolveFilterDeg(alloc, value, false, "hue-rotate"),
        .backdrop_blur => resolveFilterBlur(alloc, value, true, "--blur", theme),
        .backdrop_brightness => resolveFilterPercent(alloc, value, true, "brightness"),
        .backdrop_contrast => resolveFilterPercent(alloc, value, true, "contrast"),
        .backdrop_grayscale => resolveFilterToggle(alloc, value, true, "grayscale"),
        .backdrop_invert => resolveFilterToggle(alloc, value, true, "invert"),
        .backdrop_sepia => resolveFilterToggle(alloc, value, true, "sepia"),
        .backdrop_saturate => resolveFilterPercent(alloc, value, true, "saturate"),
        .backdrop_hue_rotate => resolveFilterDeg(alloc, value, true, "hue-rotate"),
        .backdrop_opacity => resolveFilterPercent(alloc, value, true, "opacity"),
        .ease => resolveEase(alloc, value, theme),
        .animate => resolveAnimate(alloc, value, theme),
        .line_clamp => resolveLineClamp(alloc, value),
        .content => resolveContent(alloc, value),
        .list => resolveListStyleType(alloc, value),
        .space_x => resolveSpaceBetween(alloc, value, "column-gap", theme),
        .space_y => resolveSpaceBetween(alloc, value, "row-gap", theme),
        .divide_x => resolveDivide(alloc, value, "border-inline-width"),
        .divide_y => resolveDivide(alloc, value, "border-block-width"),
        .underline_offset => resolveUnderlineOffset(alloc, value),
        .bg_gradient_dir => resolveGradient(alloc, root, value),
        .bg_gradient => resolveGradient(alloc, "bg-linear", value),
        .gradient_stop => resolveGradientStop(alloc, root, value, modifier, theme),
        .perspective => resolvePerspective(alloc, value, theme),
        .origin => resolveOrigin(alloc, value),
        .columns => resolveColumns(alloc, value, theme),
        .outline_offset => resolveOutlineOffset(alloc, value),
        .outline => resolveOutline(alloc, value, modifier, theme),
        .grow => resolveGrowShrink(alloc, value, "flex-grow"),
        .shrink => resolveGrowShrink(alloc, value, "flex-shrink"),
        .inset_ring => resolveInsetRing(alloc, value, modifier, theme),
        .ring_offset => resolveRingOffset(alloc, value, modifier, theme),
        .text_shadow => resolveTextShadow(alloc, value, theme),
        .font_weight => resolveFontWeight(alloc, value, theme),
        .mask_image => blk: {
            const val = value orelse break :blk null;
            const decls = try alloc.alloc(Declaration, 2);
            decls[0] = Declaration{ .property = "-webkit-mask-image", .value = val.value };
            decls[1] = Declaration{ .property = "mask-image", .value = val.value };
            break :blk decls;
        },
        .list_image => blk: {
            const val = value orelse break :blk null;
            switch (val.kind) {
                .arbitrary => {
                    const decls = try alloc.alloc(Declaration, 1);
                    decls[0] = Declaration{ .property = "list-style-image", .value = val.value };
                    break :blk decls;
                },
                .named => {
                    if (std.mem.eql(u8, val.value, "none")) {
                        const decls = try alloc.alloc(Declaration, 1);
                        decls[0] = Declaration{ .property = "list-style-image", .value = "none" };
                        break :blk decls;
                    }
                    break :blk null;
                },
            }
        },
        .neg_bg_gradient_dir => resolveGradient(alloc, root, value),
        .mask_position => resolveSingleProp(alloc, value, "mask-position"),
        .mask_size => resolveSingleProp(alloc, value, "mask-size"),
        .mask_repeat => resolveSingleProp(alloc, value, "mask-repeat"),
        .mask_type => resolveSingleProp(alloc, value, "mask-type"),
        .bg_size => resolveSingleProp(alloc, value, "background-size"),
        .bg_position => resolveSingleProp(alloc, value, "background-position"),
        .font_stretch_fn => resolveSingleProp(alloc, value, "font-stretch"),
        .border_spacing => resolveBorderSpacing(alloc, root, value, theme),
        .indent => resolveIndent(alloc, value, theme),
    };
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
        .{ "mbs", &[_][]const u8{"margin-block-start"} },
        .{ "mbe", &[_][]const u8{"margin-block-end"} },
        .{ "-mbs", &[_][]const u8{"margin-block-start"} },
        .{ "-mbe", &[_][]const u8{"margin-block-end"} },
        .{ "pbs", &[_][]const u8{"padding-block-start"} },
        .{ "pbe", &[_][]const u8{"padding-block-end"} },
        .{ "mis", &[_][]const u8{"margin-inline-start"} },
        .{ "mie", &[_][]const u8{"margin-inline-end"} },
        .{ "-mis", &[_][]const u8{"margin-inline-start"} },
        .{ "-mie", &[_][]const u8{"margin-inline-end"} },
        .{ "inline", &[_][]const u8{"inline-size"} },
        .{ "min-inline", &[_][]const u8{"min-inline-size"} },
        .{ "max-inline", &[_][]const u8{"max-inline-size"} },
        .{ "block", &[_][]const u8{"block-size"} },
        .{ "min-block", &[_][]const u8{"min-block-size"} },
        .{ "max-block", &[_][]const u8{"max-block-size"} },
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
            // Strip units from zero values: 0px, 0rem, 0em -> 0
            const arb_val = if (std.mem.eql(u8, val.value, "0px") or
                std.mem.eql(u8, val.value, "0rem") or
                std.mem.eql(u8, val.value, "0em")) "0" else val.value;
            if (is_neg) {
                if (std.mem.startsWith(u8, arb_val, "var(")) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{arb_val});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "-{s}", .{arb_val});
                }
            } else {
                css_value = arb_val;
            }
        },
        .named => {
            // Check for special keywords
            if (std.mem.eql(u8, val.value, "auto")) {
                // max-w, max-h, max-inline, max-block don't support auto
                if (std.mem.startsWith(u8, root, "max-")) return null;
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
            } else if (std.mem.eql(u8, val.value, "svw")) {
                css_value = "100svw";
            } else if (std.mem.eql(u8, val.value, "lvw")) {
                css_value = "100lvw";
            } else if (std.mem.eql(u8, val.value, "dvw")) {
                css_value = "100dvw";
            } else if (std.mem.eql(u8, val.value, "svh")) {
                css_value = "100svh";
            } else if (std.mem.eql(u8, val.value, "lvh")) {
                css_value = "100lvh";
            } else if (std.mem.eql(u8, val.value, "dvh")) {
                css_value = "100dvh";
            } else if (std.mem.eql(u8, val.value, "lh")) {
                css_value = "1lh";
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
                    css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * -{s})", .{stripLeadingZero(val.value)});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{stripLeadingZero(val.value)});
                }
            } else if (theme.resolve(val.value, "--spacing")) {
                // Named spacing value from theme
                const var_name = try std.fmt.allocPrint(alloc, "var(--spacing-{s})", .{val.value});
                if (is_neg) {
                    css_value = try std.fmt.allocPrint(alloc, "calc({s} * -1)", .{var_name});
                } else {
                    css_value = var_name;
                }
            } else if ((std.mem.eql(u8, root, "max-w") or std.mem.eql(u8, root, "max-h")) and !is_neg) {
                // Named max-width values (container sizes) -> var(--container-*)
                const max_w_names = std.StaticStringMap(void).initComptime(.{
                    .{ "xs", {} },
                    .{ "sm", {} },
                    .{ "md", {} },
                    .{ "lg", {} },
                    .{ "xl", {} },
                    .{ "2xl", {} },
                    .{ "3xl", {} },
                    .{ "4xl", {} },
                    .{ "5xl", {} },
                    .{ "6xl", {} },
                    .{ "7xl", {} },
                    .{ "screen-sm", {} },
                    .{ "screen-md", {} },
                    .{ "screen-lg", {} },
                    .{ "screen-xl", {} },
                    .{ "screen-2xl", {} },
                });
                if (max_w_names.has(val.value)) {
                    if (std.mem.startsWith(u8, val.value, "screen-")) {
                        // screen-sm -> var(--breakpoint-sm)
                        const bp_name = val.value["screen-".len..];
                        css_value = try std.fmt.allocPrint(alloc, "var(--breakpoint-{s})", .{bp_name});
                    } else {
                        css_value = try std.fmt.allocPrint(alloc, "var(--container-{s})", .{val.value});
                    }
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
                css_value = "#0000";
            } else if (std.mem.eql(u8, val.value, "current")) {
                css_value = "currentColor";
            } else if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    // Apply color opacity modifier if present
    if (modifier) |mod| {
        css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
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
                if (negative) return null; // -z-auto is invalid
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
            // Strip leading zero: 0.1 -> .1
            if (std.mem.startsWith(u8, val.value, "0.")) {
                css_value = val.value[1..];
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                // Convert percentage to decimal: opacity-50 -> 0.5, opacity-80 -> 0.8
                const num = std.fmt.parseInt(u32, val.value, 10) catch return null;
                if (num > 100) return null;
                if (num == 0) {
                    css_value = "0";
                } else if (num == 100) {
                    css_value = "1";
                } else if (num % 10 == 0) {
                    // 80 -> .8, 50 -> .5, 10 -> .1
                    css_value = try std.fmt.allocPrint(alloc, ".{d}", .{num / 10});
                } else {
                    // 75 -> .75, 25 -> .25, 5 -> .05
                    if (num < 10) {
                        css_value = try std.fmt.allocPrint(alloc, ".0{d}", .{num});
                    } else {
                        css_value = try std.fmt.allocPrint(alloc, ".{d}", .{num});
                    }
                }
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
                if (negative) return null; // -order-first is invalid
                css_value = "-9999";
            } else if (std.mem.eql(u8, val.value, "last")) {
                if (negative) return null; // -order-last is invalid
                css_value = "9999";
            } else if (std.mem.eql(u8, val.value, "none")) {
                if (negative) return null; // -order-none is invalid
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
        .{ "rounded-b", &[_][]const u8{ "border-bottom-right-radius", "border-bottom-left-radius" } },
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
                css_value = "3.40282e38px";
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
            css_value = try normalizeDurationValue(alloc, val.value);
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                // Convert ms to seconds: duration-200 -> 0.2s
                const ms = std.fmt.parseInt(u32, val.value, 10) catch return null;
                css_value = try formatMsToSeconds(alloc, ms);
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-duration", .value = css_value };
    decls[1] = Declaration{ .property = "transition-duration", .value = css_value };
    return decls;
}

fn resolveDelay(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;
    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try normalizeDurationValue(alloc, val.value);
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                const ms = std.fmt.parseInt(u32, val.value, 10) catch return null;
                css_value = try formatMsToSeconds(alloc, ms);
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "transition-delay", .value = css_value };
    return decls;
}

// ─── Duration/Delay Formatting Helper ──────────────────────────────────────

fn formatMsToSeconds(alloc: Allocator, ms: u32) ![]const u8 {
    if (ms == 0) {
        return "0s";
    } else if (ms < 100) {
        return std.fmt.allocPrint(alloc, "{d}ms", .{ms});
    } else if (ms % 1000 == 0) {
        return std.fmt.allocPrint(alloc, "{d}s", .{ms / 1000});
    } else {
        // Convert to seconds as a decimal, stripping trailing zeros
        // e.g., 300 -> ".3s", 150 -> ".15s", 1500 -> "1.5s"
        // TW omits leading zero: .3s not 0.3s
        const whole = ms / 1000;
        var frac = ms % 1000;
        var digits: u32 = 3;
        while (digits > 0 and frac % 10 == 0) {
            frac /= 10;
            digits -= 1;
        }
        if (whole == 0) {
            if (digits == 1) return std.fmt.allocPrint(alloc, ".{d}s", .{frac});
            if (digits == 2) return std.fmt.allocPrint(alloc, ".{d:0>2}s", .{frac});
            return std.fmt.allocPrint(alloc, ".{d:0>3}s", .{frac});
        }
        if (digits == 1) return std.fmt.allocPrint(alloc, "{d}.{d}s", .{ whole, frac });
        if (digits == 2) return std.fmt.allocPrint(alloc, "{d}.{d:0>2}s", .{ whole, frac });
        return std.fmt.allocPrint(alloc, "{d}.{d:0>3}s", .{ whole, frac });
    }
}

// ─── Color Opacity Helper ──────────────────────────────────────────────────

fn applyColorOpacity(alloc: Allocator, color: []const u8, mod: Modifier) ![]const u8 {
    return applyColorOpacityWithTheme(alloc, color, mod, null);
}

fn applyColorOpacityWithTheme(alloc: Allocator, color: []const u8, mod: Modifier, theme: ?*Theme) ![]const u8 {
    // Determine alpha percentage
    var alpha_pct: ?u8 = null;
    switch (mod.kind) {
        .arbitrary => {
            const f = std.fmt.parseFloat(f64, mod.value) catch {
                // Can't pre-resolve with non-numeric modifier
                return std.fmt.allocPrint(alloc, "color-mix(in oklab,{s} {s},transparent)", .{ color, mod.value });
            };
            const pct_val = @as(u32, @intFromFloat(@round(f * 100.0)));
            if (pct_val <= 255) alpha_pct = @intCast(pct_val);
        },
        .named => {
            alpha_pct = std.fmt.parseInt(u8, mod.value, 10) catch null;
        },
    }

    // Try to pre-resolve: look up the raw color value from theme
    if (alpha_pct) |pct| {
        if (theme) |t| {
            // color is like "var(--color-blue-500)" — extract the var name
            if (std.mem.startsWith(u8, color, "var(") and color.len > 5) {
                const var_name = color[4 .. color.len - 1]; // --color-blue-500
                if (t.get(var_name)) |raw_color| {
                    // Pre-resolve: oklch/hex -> #RRGGBBAA
                    return color_mod.resolveColorMixWithKey(alloc, raw_color, pct, var_name);
                }
            }
            // Direct color value (not a var reference)
            if (std.mem.startsWith(u8, color, "oklch(") or color[0] == '#') {
                return color_mod.resolveColorMix(alloc, color, pct);
            }
        }
    }

    // Fallback to color-mix()
    const percent = switch (mod.kind) {
        .arbitrary => try std.fmt.allocPrint(alloc, "{d}%", .{@as(u32, @intFromFloat(@round(std.fmt.parseFloat(f64, mod.value) catch 0) * 100.0))}),
        .named => try std.fmt.allocPrint(alloc, "{s}%", .{mod.value}),
    };
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
                theme.resolve(val.value, "--color"))
            {
                // It's a color value
                var css_value: []const u8 = undefined;
                if (std.mem.eql(u8, val.value, "inherit")) {
                    css_value = "inherit";
                } else if (std.mem.eql(u8, val.value, "transparent")) {
                    css_value = "#0000";
                } else if (std.mem.eql(u8, val.value, "current")) {
                    css_value = "currentColor";
                } else {
                    theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                    css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                }
                if (modifier) |mod| {
                    css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "color", .value = css_value };
                return decls;
            }

            // Try font-size theme
            if (theme.resolve(val.value, "--text")) {
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
            const decls = try alloc.alloc(Declaration, 2);
            decls[0] = Declaration{ .property = "--tw-font-weight", .value = val.value };
            decls[1] = Declaration{ .property = "font-weight", .value = val.value };
            return decls;
        },
        .named => {
            // Try font-family first (--font-{value})
            if (theme.resolve(val.value, "--font")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--font-{s}", .{val.value}));
                const css_value = try std.fmt.allocPrint(alloc, "var(--font-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "font-family", .value = css_value };
                return decls;
            }

            // Try font-weight (--font-weight-{value})
            if (theme.resolve(val.value, "--font-weight")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--font-weight-{s}", .{val.value}));
                const css_value = try std.fmt.allocPrint(alloc, "var(--font-weight-{s})", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-font-weight", .value = css_value };
                decls[1] = Declaration{ .property = "font-weight", .value = css_value };
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
            if (theme.resolve(val.value, "--leading")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--leading-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--leading-{s})", .{val.value});
            } else if (std.mem.eql(u8, val.value, "none")) {
                css_value = "1";
            } else if (isValidSpacingMultiplier(val.value)) {
                // Bare number = spacing multiplier
                theme.markUsed("--spacing");
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{stripLeadingZero(val.value)});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-leading", .value = css_value };
    decls[1] = Declaration{ .property = "line-height", .value = css_value };
    return decls;
}

// ─── Tracking (letter-spacing) ─────────────────────────────────────────────

fn resolveTracking(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Strip leading zero: 0.01em -> .01em
            if (std.mem.startsWith(u8, val.value, "0.")) {
                css_value = val.value[1..];
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (theme.resolve(val.value, "--tracking")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--tracking-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--tracking-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-tracking", .value = css_value };
    decls[1] = Declaration{ .property = "letter-spacing", .value = css_value };
    return decls;
}

// ─── Border (dual: color + width) ──────────────────────────────────────────

fn resolveBorder(alloc: Allocator, root: []const u8, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // bare `border`, `border-t`, `border-l`, etc. with no value -> width: 1px
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = borderStyleProperty(root), .value = "var(--tw-border-style)" };
        decls[1] = Declaration{ .property = borderWidthProperty(root), .value = "1px" };
        return decls;
    };

    const width_property = borderWidthProperty(root);

    switch (val.kind) {
        .arbitrary => {
            // Check if it looks like a width value (has px, number, etc.)
            if (looksLikeBorderWidth(val.value)) {
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = borderStyleProperty(root), .value = "var(--tw-border-style)" };
                decls[1] = Declaration{ .property = width_property, .value = val.value };
                return decls;
            }
            // Otherwise treat as color
            const color_property = borderColorProperty(root);
            var css_value: []const u8 = val.value;
            if (modifier) |mod| {
                css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
            }
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = color_property, .value = css_value };
            return decls;
        },
        .named => {
            // Check if it's a bare number (border width)
            if (isPositiveInteger(val.value)) {
                const css_value = if (std.mem.eql(u8, val.value, "0"))
                    @as([]const u8, "0")
                else
                    try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = borderStyleProperty(root), .value = "var(--tw-border-style)" };
                decls[1] = Declaration{ .property = width_property, .value = css_value };
                return decls;
            }

            const color_property = borderColorProperty(root);

            // Try as color
            if (std.mem.eql(u8, val.value, "inherit")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = color_property, .value = "inherit" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = color_property, .value = "#0000" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "current")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = color_property, .value = "currentColor" };
                return decls;
            } else if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var css_value: []const u8 = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                if (modifier) |mod| {
                    css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = color_property, .value = css_value };
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

fn borderColorProperty(root: []const u8) []const u8 {
    const map = std.StaticStringMap([]const u8).initComptime(.{
        .{ "border", "border-color" },
        .{ "border-x", "border-inline-color" },
        .{ "border-y", "border-block-color" },
        .{ "border-s", "border-inline-start-color" },
        .{ "border-e", "border-inline-end-color" },
        .{ "border-t", "border-top-color" },
        .{ "border-r", "border-right-color" },
        .{ "border-b", "border-bottom-color" },
        .{ "border-l", "border-left-color" },
    });
    return map.get(root) orelse "border-color";
}

fn borderStyleProperty(root: []const u8) []const u8 {
    const map = std.StaticStringMap([]const u8).initComptime(.{
        .{ "border", "border-style" },
        .{ "border-x", "border-inline-style" },
        .{ "border-y", "border-block-style" },
        .{ "border-s", "border-inline-start-style" },
        .{ "border-e", "border-inline-end-style" },
        .{ "border-t", "border-top-style" },
        .{ "border-r", "border-right-style" },
        .{ "border-b", "border-bottom-style" },
        .{ "border-l", "border-left-style" },
    });
    return map.get(root) orelse "border-style";
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
            // Simplify "1/1" to "1"
            if (std.mem.eql(u8, val.value, "1/1")) {
                css_value = "1";
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (std.mem.eql(u8, val.value, "auto")) {
                css_value = "auto";
            } else if (std.mem.eql(u8, val.value, "square")) {
                css_value = "1";
            } else if (val.fraction != null) {
                // Fraction like 4/3
                css_value = val.fraction.?;
            } else if (theme.resolve(val.value, "--aspect")) {
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

fn resolveGridTemplate(alloc: Allocator, value: ?Value, property: []const u8, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    // Determine the theme namespace from the property
    const theme_ns: []const u8 = if (std.mem.eql(u8, property, "grid-template-columns"))
        "--grid-cols"
    else
        "--grid-rows";

    switch (val.kind) {
        .arbitrary => {
            css_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                css_value = "none";
            } else if (std.mem.eql(u8, val.value, "subgrid")) {
                css_value = "subgrid";
            } else if (isPositiveInteger(val.value) and !std.mem.eql(u8, val.value, "0")) {
                css_value = try std.fmt.allocPrint(alloc, "repeat({s},minmax(0,1fr))", .{val.value});
            } else if (theme.resolve(val.value, theme_ns)) {
                // Theme lookup: grid-cols-blog → var(--grid-cols-blog)
                var buf: [128]u8 = undefined;
                const var_name = std.fmt.bufPrint(&buf, "{s}-{s}", .{ theme_ns, val.value }) catch return null;
                theme.markUsed(var_name);
                css_value = try std.fmt.allocPrint(alloc, "var({s}-{s})", .{ theme_ns, val.value });
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
                css_value = try std.fmt.allocPrint(alloc, "-{s}", .{val.value});
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (isValidSpacingMultiplier(val.value)) {
                if (negative) {
                    css_value = try std.fmt.allocPrint(alloc, "-{s}deg", .{val.value});
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

// ─── Transform: rotate axis (3D) ──────────────────────────────────────────

fn resolveRotateAxis(alloc: Allocator, root: []const u8, value: ?Value, negative: bool) !?[]const Declaration {
    const val = value orelse return null;

    // Determine if negative from prefix or flag
    const is_neg = negative or (root.len > 0 and root[0] == '-');
    const axis_root = if (root[0] == '-') root[1..] else root;

    // "rotate-x" -> 'x', "rotate-y" -> 'y', "rotate-z" -> 'z'
    const axis = axis_root[axis_root.len - 1];
    const fn_name: []const u8 = switch (axis) {
        'x' => "rotateX",
        'y' => "rotateY",
        'z' => "rotateZ",
        else => return null,
    };

    var css_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            if (is_neg) {
                css_value = try std.fmt.allocPrint(alloc, "-{s}", .{val.value});
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                if (is_neg) {
                    css_value = try std.fmt.allocPrint(alloc, "-{s}deg", .{val.value});
                } else {
                    css_value = try std.fmt.allocPrint(alloc, "{s}deg", .{val.value});
                }
            } else {
                return null;
            }
        },
    }

    const custom_prop: []const u8 = switch (axis) {
        'x' => "--tw-rotate-x",
        'y' => "--tw-rotate-y",
        'z' => "--tw-rotate-z",
        else => return null,
    };

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = custom_prop, .value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, css_value }) };
    decls[1] = Declaration{ .property = "transform", .value = COMPOSABLE_TRANSFORM };
    return decls;
}

// ─── Transform: scale ──────────────────────────────────────────────────────

fn resolveScale(alloc: Allocator, value: ?Value, root: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Strip leading zero: 0.95 -> .95
            if (std.mem.startsWith(u8, val.value, "0.")) {
                css_value = val.value[1..];
            } else {
                css_value = val.value;
            }
            // Arbitrary values output directly without composable custom properties
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "scale", .value = css_value };
            return decls;
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}%", .{val.value});
            } else {
                return null;
            }
        },
    }

    const is_x_only = std.mem.eql(u8, root, "scale-x");
    const is_y_only = std.mem.eql(u8, root, "scale-y");

    if (is_x_only) {
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-scale-x", .value = css_value };
        decls[1] = Declaration{ .property = "scale", .value = "var(--tw-scale-x) var(--tw-scale-y)" };
        return decls;
    } else if (is_y_only) {
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-scale-y", .value = css_value };
        decls[1] = Declaration{ .property = "scale", .value = "var(--tw-scale-x) var(--tw-scale-y)" };
        return decls;
    } else {
        // scale (both axes)
        const decls = try alloc.alloc(Declaration, 4);
        decls[0] = Declaration{ .property = "--tw-scale-x", .value = css_value };
        decls[1] = Declaration{ .property = "--tw-scale-y", .value = css_value };
        decls[2] = Declaration{ .property = "--tw-scale-z", .value = css_value };
        decls[3] = Declaration{ .property = "scale", .value = "var(--tw-scale-x) var(--tw-scale-y)" };
        return decls;
    }
}

// ─── Transform: translate ──────────────────────────────────────────────────

fn resolveScaleZ(alloc: Allocator, value: ?Value) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (std.mem.startsWith(u8, val.value, "0.")) {
                css_value = val.value[1..];
            } else {
                css_value = val.value;
            }
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}%", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-scale-z", .value = css_value };
    decls[1] = Declaration{ .property = "scale", .value = "var(--tw-scale-x) var(--tw-scale-y) var(--tw-scale-z)" };
    return decls;
}

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
                inner = try resolveFractionCalc(alloc, frac, negative);
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

    // Use custom property + translate shorthand
    const custom_prop = if (std.mem.eql(u8, axis, "X")) "--tw-translate-x" else "--tw-translate-y";

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = custom_prop, .value = inner };
    decls[1] = Declaration{ .property = "translate", .value = "var(--tw-translate-x) var(--tw-translate-y)" };
    return decls;
}

fn resolveTranslateZ(alloc: Allocator, root: []const u8, value: ?Value, negative: bool, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    const is_neg = negative or (root.len > 0 and root[0] == '-');

    var inner: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            if (is_neg) {
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
            // translate-z only accepts px and spacing values, not full/keywords
            if (std.mem.eql(u8, val.value, "px")) {
                inner = if (is_neg) "-1px" else "1px";
            } else if (isValidSpacingMultiplier(val.value)) {
                theme.markUsed("--spacing");
                if (is_neg) {
                    inner = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * -{s})", .{val.value});
                } else {
                    inner = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{val.value});
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-translate-z", .value = inner };
    decls[1] = Declaration{ .property = "translate", .value = "var(--tw-translate-x) var(--tw-translate-y) var(--tw-translate-z)" };
    return decls;
}
// ─── Transform: skew ───────────────────────────────────────────────────────

const COMPOSABLE_TRANSFORM = "var(--tw-rotate-x,) var(--tw-rotate-y,) var(--tw-rotate-z,) var(--tw-skew-x,) var(--tw-skew-y,)";

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

    const skew_fn = try std.fmt.allocPrint(alloc, "skew{s}({s})", .{ axis, deg_value });
    const prop = if (std.mem.eql(u8, axis, "X")) "--tw-skew-x" else "--tw-skew-y";

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = prop, .value = skew_fn };
    decls[1] = Declaration{ .property = "transform", .value = COMPOSABLE_TRANSFORM };
    return decls;
}

// ─── Shadow ────────────────────────────────────────────────────────────────

fn resolveShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const COMPOSABLE_BOX_SHADOW = "var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)";

    const val = value orelse {
        // Bare shadow = default shadow (--shadow-sm equivalent)
        if (theme.get("--shadow-sm")) |raw_val| {
            theme.markUsed("--shadow-sm");
            const shadow_value = try convertShadowColors(alloc, raw_val);
            const decls = try alloc.alloc(Declaration, 2);
            decls[0] = Declaration{ .property = "--tw-shadow", .value = shadow_value };
            decls[1] = Declaration{ .property = "box-shadow", .value = COMPOSABLE_BOX_SHADOW };
            return decls;
        }
        return null;
    };

    var shadow_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Replace underscores with spaces
            shadow_value = try replaceUnderscores(alloc, val.value);
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                shadow_value = "0 0 #0000";
            } else if (theme.resolve(val.value, "--shadow")) {
                const var_name = try std.fmt.allocPrint(alloc, "--shadow-{s}", .{val.value});
                theme.markUsed(var_name);
                if (theme.get(var_name)) |raw_val| {
                    // Convert rgb() colors to hex8 and wrap in var(--tw-shadow-color,...)
                    shadow_value = try convertShadowColors(alloc, raw_val);
                } else {
                    shadow_value = try std.fmt.allocPrint(alloc, "var({s})", .{var_name});
                }
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-shadow", .value = shadow_value };
    decls[1] = Declaration{ .property = "box-shadow", .value = COMPOSABLE_BOX_SHADOW };
    return decls;
}

// ─── Ring ──────────────────────────────────────────────────────────────────

fn resolveRing(alloc: Allocator, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const COMPOSABLE_BOX_SHADOW = "var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)";

    const val = value orelse {
        // ring with no value = 1px ring, but reject modifiers on bare ring
        if (modifier != null) return null;
        const ring_val = "var(--tw-ring-inset,) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color,currentcolor)";
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-ring-shadow", .value = ring_val };
        decls[1] = Declaration{ .property = "box-shadow", .value = COMPOSABLE_BOX_SHADOW };
        return decls;
    };

    switch (val.kind) {
        .arbitrary => {
            // Could be color or width - check for numeric or length typehint
            const is_width = isPositiveInteger(val.value) or
                std.mem.endsWith(u8, val.value, "px") or
                std.mem.endsWith(u8, val.value, "rem") or
                (val.data_type != null and std.mem.eql(u8, val.data_type.?, "length"));
            if (is_width) {
                if (modifier != null) return null; // Width mode doesn't accept modifiers
                const ring_val = try std.fmt.allocPrint(alloc, "var(--tw-ring-inset,) 0 0 0 calc({s} + var(--tw-ring-offset-width)) var(--tw-ring-color,currentcolor)", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-ring-shadow", .value = ring_val };
                decls[1] = Declaration{ .property = "box-shadow", .value = COMPOSABLE_BOX_SHADOW };
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
                const color_val = if (std.mem.eql(u8, val.value, "current")) "currentColor" else if (std.mem.eql(u8, val.value, "transparent")) "transparent" else val.value;
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-ring-color", .value = color_val };
                return decls;
            }

            // Try as color from theme
            if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var color_css: []const u8 = undefined;
                if (modifier) |mod| {
                    color_css = try applyColorOpacityWithTheme(alloc, try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value}), mod, theme);
                } else {
                    color_css = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                }
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "--tw-ring-color", .value = color_css };
                return decls;
            }

            // Try as width — modifiers not allowed in width mode
            if (isPositiveInteger(val.value)) {
                if (modifier != null) return null;
                const ring_val = try std.fmt.allocPrint(alloc, "var(--tw-ring-inset,) 0 0 0 calc({s}px + var(--tw-ring-offset-width)) var(--tw-ring-color,currentcolor)", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-ring-shadow", .value = ring_val };
                decls[1] = Declaration{ .property = "box-shadow", .value = COMPOSABLE_BOX_SHADOW };
                return decls;
            }

            return null;
        },
    }
}

// ─── Filter utilities ──────────────────────────────────────────────────────

const COMPOSABLE_FILTER = "var(--tw-blur,) var(--tw-brightness,) var(--tw-contrast,) var(--tw-grayscale,) var(--tw-hue-rotate,) var(--tw-invert,) var(--tw-saturate,) var(--tw-sepia,) var(--tw-drop-shadow,)";
const COMPOSABLE_BACKDROP_FILTER = "var(--tw-backdrop-blur,) var(--tw-backdrop-brightness,) var(--tw-backdrop-contrast,) var(--tw-backdrop-grayscale,) var(--tw-backdrop-hue-rotate,) var(--tw-backdrop-invert,) var(--tw-backdrop-opacity,) var(--tw-backdrop-saturate,) var(--tw-backdrop-sepia,)";

fn buildFilterDecls(alloc: Allocator, fn_value: []const u8, comptime is_backdrop: bool, comptime fn_name: []const u8) !?[]const Declaration {
    const custom_prop = if (is_backdrop) "--tw-backdrop-" ++ fn_name else "--tw-" ++ fn_name;
    if (is_backdrop) {
        const decls = try alloc.alloc(Declaration, 3);
        decls[0] = Declaration{ .property = custom_prop, .value = fn_value };
        decls[1] = Declaration{ .property = "-webkit-backdrop-filter", .value = COMPOSABLE_BACKDROP_FILTER };
        decls[2] = Declaration{ .property = "backdrop-filter", .value = COMPOSABLE_BACKDROP_FILTER };
        return decls;
    } else {
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = custom_prop, .value = fn_value };
        decls[1] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
        return decls;
    }
}

fn resolveFilterBlur(alloc: Allocator, value: ?Value, comptime is_backdrop: bool, comptime theme_ns: []const u8, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // Bare blur/backdrop-blur = default 8px
        return buildFilterDecls(alloc, "blur(8px)", is_backdrop, "blur");
    };

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            css_value = try std.fmt.allocPrint(alloc, "blur({s})", .{val.value});
        },
        .named => {
            if (theme.resolve(val.value, theme_ns)) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "{s}-{s}", .{ theme_ns, val.value }));
                css_value = try std.fmt.allocPrint(alloc, "blur(var({s}-{s}))", .{ theme_ns, val.value });
            } else {
                return null;
            }
        },
    }

    return buildFilterDecls(alloc, css_value, is_backdrop, "blur");
}

fn resolveFilterPercent(alloc: Allocator, value: ?Value, comptime is_backdrop: bool, comptime fn_name: []const u8) !?[]const Declaration {
    const val = value orelse return null;

    var css_value: []const u8 = undefined;

    switch (val.kind) {
        .arbitrary => {
            // Strip leading zero from decimal values: 0.8 -> .8
            const inner = if (std.mem.startsWith(u8, val.value, "0."))
                val.value[1..]
            else
                val.value;
            css_value = try std.fmt.allocPrint(alloc, "{s}({s})", .{ fn_name, inner });
        },
        .named => {
            if (isPositiveInteger(val.value)) {
                css_value = try std.fmt.allocPrint(alloc, "{s}({s}%)", .{ fn_name, val.value });
            } else {
                return null;
            }
        },
    }

    return buildFilterDecls(alloc, css_value, is_backdrop, fn_name);
}

fn resolveFilterToggle(alloc: Allocator, value: ?Value, comptime is_backdrop: bool, comptime fn_name: []const u8) !?[]const Declaration {
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

    return buildFilterDecls(alloc, css_value, is_backdrop, fn_name);
}

fn resolveFilterDeg(alloc: Allocator, value: ?Value, comptime is_backdrop: bool, comptime fn_name: []const u8) !?[]const Declaration {
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

    return buildFilterDecls(alloc, css_value, is_backdrop, fn_name);
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
            } else if (theme.resolve(val.value, "--ease")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--ease-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--ease-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-ease", .value = css_value };
    decls[1] = Declaration{ .property = "transition-timing-function", .value = css_value };
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
            } else if (theme.resolve(val.value, "--animate")) {
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
            decls[0] = Declaration{ .property = "-webkit-line-clamp", .value = val.value };
            decls[1] = Declaration{ .property = "-webkit-box-orient", .value = "vertical" };
            decls[2] = Declaration{ .property = "display", .value = "-webkit-box" };
            decls[3] = Declaration{ .property = "overflow", .value = "hidden" };
            return decls;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                const decls = try alloc.alloc(Declaration, 4);
                decls[0] = Declaration{ .property = "-webkit-line-clamp", .value = "unset" };
                decls[1] = Declaration{ .property = "-webkit-box-orient", .value = "horizontal" };
                decls[2] = Declaration{ .property = "display", .value = "block" };
                decls[3] = Declaration{ .property = "overflow", .value = "visible" };
                return decls;
            } else if (isPositiveInteger(val.value)) {
                const decls = try alloc.alloc(Declaration, 4);
                decls[0] = Declaration{ .property = "-webkit-line-clamp", .value = val.value };
                decls[1] = Declaration{ .property = "-webkit-box-orient", .value = "vertical" };
                decls[2] = Declaration{ .property = "display", .value = "-webkit-box" };
                decls[3] = Declaration{ .property = "overflow", .value = "hidden" };
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

/// Check if a value looks like a CSS length (ends with px, rem, em, etc.)
fn looksLikeLength(s: []const u8) bool {
    return std.mem.endsWith(u8, s, "px") or
        std.mem.endsWith(u8, s, "rem") or
        std.mem.endsWith(u8, s, "em") or
        std.mem.endsWith(u8, s, "vh") or
        std.mem.endsWith(u8, s, "vw") or
        std.mem.endsWith(u8, s, "ch") or
        std.mem.endsWith(u8, s, "ex") or
        std.mem.endsWith(u8, s, "cm") or
        std.mem.endsWith(u8, s, "mm") or
        std.mem.endsWith(u8, s, "in") or
        std.mem.endsWith(u8, s, "pt") or
        std.mem.endsWith(u8, s, "pc") or
        std.mem.endsWith(u8, s, "%");
}

fn isPositiveInteger(s: []const u8) bool {
    if (s.len == 0) return false;
    for (s) |c| {
        if (c < '0' or c > '9') return false;
    }
    return true;
}

/// Strip leading zero from decimal numbers: "0.5" -> ".5", "1.5" -> "1.5", "4" -> "4"
fn stripLeadingZero(s: []const u8) []const u8 {
    if (s.len >= 2 and s[0] == '0' and s[1] == '.') {
        return s[1..]; // ".5" instead of "0.5"
    }
    return s;
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
    // Parse "1/2" -> "50%" for sizing contexts (w-1/2, h-1/3, etc.)
    const slash_idx = std.mem.indexOfScalar(u8, fraction, '/') orelse return error.OutOfMemory;
    const numerator_str = fraction[0..slash_idx];
    const denominator_str = fraction[slash_idx + 1 ..];

    const numerator = std.fmt.parseFloat(f64, numerator_str) catch return error.OutOfMemory;
    const denominator = std.fmt.parseFloat(f64, denominator_str) catch return error.OutOfMemory;
    if (denominator == 0) return error.OutOfMemory;

    var percentage = (numerator / denominator) * 100.0;
    if (negative) percentage = -percentage;

    const int_pct = @as(i64, @intFromFloat(@round(percentage)));
    if (@as(f64, @floatFromInt(int_pct)) == percentage) {
        return std.fmt.allocPrint(alloc, "{d}%", .{int_pct});
    }
    // Format with 6 significant digits (matching TW behavior)
    // 33.3333%, 8.33333%, 66.6667% — count digits before decimal to determine precision
    const abs_pct = if (percentage < 0) -percentage else percentage;
    const digits_before: u32 = if (abs_pct >= 100) 3 else if (abs_pct >= 10) 2 else 1;
    const decimal_places = 6 - digits_before;
    const formatted = switch (decimal_places) {
        3 => try std.fmt.allocPrint(alloc, "{d:.3}%", .{percentage}),
        4 => try std.fmt.allocPrint(alloc, "{d:.4}%", .{percentage}),
        5 => try std.fmt.allocPrint(alloc, "{d:.5}%", .{percentage}),
        else => try std.fmt.allocPrint(alloc, "{d:.4}%", .{percentage}),
    };
    // Find the '%' and strip trailing zeros before it
    const pct_idx = std.mem.indexOfScalar(u8, formatted, '%') orelse return formatted;
    var end = pct_idx;
    while (end > 0 and formatted[end - 1] == '0') {
        end -= 1;
    }
    // Don't strip the decimal point itself if it would leave a bare dot
    if (end > 0 and formatted[end - 1] == '.') {
        end -= 1;
    }
    const trimmed = try std.fmt.allocPrint(alloc, "{s}%", .{formatted[0..end]});
    return trimmed;
}

fn resolveFractionCalc(alloc: Allocator, fraction: []const u8, negative: bool) ![]const u8 {
    // Parse "1/2" -> "calc(1 / 2 * 100%)" for translate contexts
    const slash_idx = std.mem.indexOfScalar(u8, fraction, '/') orelse return error.OutOfMemory;
    const numerator_str = fraction[0..slash_idx];
    const denominator_str = fraction[slash_idx + 1 ..];

    if (negative) {
        return std.fmt.allocPrint(alloc, "calc(calc({s} / {s} * 100%) * -1)", .{ numerator_str, denominator_str });
    } else {
        return std.fmt.allocPrint(alloc, "calc({s} / {s} * 100%)", .{ numerator_str, denominator_str });
    }
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
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{stripLeadingZero(val.value)});
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
    var is_named = false;

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
                is_named = true;
            } else if (isValidSpacingMultiplier(val.value)) {
                // Bare number -> degrees
                direction = try std.fmt.allocPrint(alloc, "{s}deg", .{val.value});
                is_named = true;
            } else {
                return null;
            }
        },
    }

    const decls = try alloc.alloc(Declaration, 2);
    if (is_named) {
        decls[0] = Declaration{ .property = "--tw-gradient-position", .value = try std.fmt.allocPrint(alloc, "{s} in oklab", .{direction}) };
    } else {
        decls[0] = Declaration{ .property = "--tw-gradient-position", .value = direction };
    }
    decls[1] = Declaration{ .property = "background-image", .value = "linear-gradient(var(--tw-gradient-stops))" };
    return decls;
}

fn resolveRadialGradient(alloc: Allocator, value: ?Value) !?[]const Declaration {
    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                const inner = try replaceUnderscores(alloc, val.value);
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-gradient-position", .value = inner };
                decls[1] = Declaration{ .property = "background-image", .value = "radial-gradient(var(--tw-gradient-stops))" };
                return decls;
            },
            .named => {
                return null;
            },
        }
    } else {
        // bare bg-radial
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-gradient-position", .value = "in oklab" };
        decls[1] = Declaration{ .property = "background-image", .value = "radial-gradient(var(--tw-gradient-stops))" };
        return decls;
    }
}

fn resolveConicGradient(alloc: Allocator, value: ?Value) !?[]const Declaration {
    if (value) |val| {
        switch (val.kind) {
            .arbitrary => {
                const inner = try replaceUnderscores(alloc, val.value);
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-gradient-position", .value = inner };
                decls[1] = Declaration{ .property = "background-image", .value = "conic-gradient(var(--tw-gradient-stops))" };
                return decls;
            },
            .named => {
                // Bare number -> from Ndeg
                if (isValidSpacingMultiplier(val.value)) {
                    const decls = try alloc.alloc(Declaration, 2);
                    decls[0] = Declaration{ .property = "--tw-gradient-position", .value = try std.fmt.allocPrint(alloc, "from {s}deg in oklab", .{val.value}) };
                    decls[1] = Declaration{ .property = "background-image", .value = "conic-gradient(var(--tw-gradient-stops))" };
                    return decls;
                }
                return null;
            },
        }
    } else {
        // bare bg-conic
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-gradient-position", .value = "in oklab" };
        decls[1] = Declaration{ .property = "background-image", .value = "conic-gradient(var(--tw-gradient-stops))" };
        return decls;
    }
}

// ─── Gradient Color Stops ──────────────────────────────────────────────────

const GRADIENT_STOPS_COMPOSITION = "var(--tw-gradient-via-stops,var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-to) var(--tw-gradient-to-position))";
const GRADIENT_VIA_STOPS_COMPOSITION = "var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-via) var(--tw-gradient-via-position), var(--tw-gradient-to) var(--tw-gradient-to-position)";

fn resolveGradientStop(alloc: Allocator, root: []const u8, value: ?Value, modifier: ?Modifier, theme: *Theme) !?[]const Declaration {
    const val = value orelse return null;

    const is_from = std.mem.eql(u8, root, "from");
    const is_via = std.mem.eql(u8, root, "via");
    const is_to = std.mem.eql(u8, root, "to");

    const property: []const u8 = if (is_from)
        "--tw-gradient-from"
    else if (is_via)
        "--tw-gradient-via"
    else if (is_to)
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
                css_value = "currentcolor"; // lowercase in gradient stops
            } else if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else if (std.mem.endsWith(u8, val.value, "%") and val.value.len > 1 and isPositiveInteger(val.value[0 .. val.value.len - 1])) {
                // Gradient position: from-0%, via-50%, to-100% (must be non-negative integer%)
                const pos_prop: []const u8 = if (is_from)
                    "--tw-gradient-from-position"
                else if (is_via)
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
        css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
    }

    if (is_via) {
        // via sets --tw-gradient-via + --tw-gradient-via-stops + --tw-gradient-stops
        const decls = try alloc.alloc(Declaration, 3);
        decls[0] = Declaration{ .property = property, .value = css_value };
        decls[1] = Declaration{ .property = "--tw-gradient-via-stops", .value = GRADIENT_VIA_STOPS_COMPOSITION };
        decls[2] = Declaration{ .property = "--tw-gradient-stops", .value = "var(--tw-gradient-via-stops)" };
        return decls;
    } else {
        // from and to set their color + --tw-gradient-stops
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = property, .value = css_value };
        decls[1] = Declaration{ .property = "--tw-gradient-stops", .value = GRADIENT_STOPS_COMPOSITION };
        return decls;
    }
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
            } else if (theme.resolve(val.value, "--perspective")) {
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
            } else if (theme.resolve(val.value, "--container")) {
                // Named container size: 3xs, 2xs, xs, sm, md, lg, xl, 2xl, ...
                theme.markUsed(try std.fmt.allocPrint(alloc, "--container-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--container-{s})", .{val.value});
            } else {
                // Named size values (fallback) -> var(--container-*)
                const size_names = std.StaticStringMap(void).initComptime(.{
                    .{ "3xs", {} },
                    .{ "2xs", {} },
                    .{ "xs", {} },
                    .{ "sm", {} },
                    .{ "md", {} },
                    .{ "lg", {} },
                    .{ "xl", {} },
                    .{ "2xl", {} },
                    .{ "3xl", {} },
                    .{ "4xl", {} },
                    .{ "5xl", {} },
                    .{ "6xl", {} },
                    .{ "7xl", {} },
                });
                if (size_names.has(val.value)) {
                    css_value = try std.fmt.allocPrint(alloc, "var(--container-{s})", .{val.value});
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
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "outline-style", .value = "var(--tw-outline-style)" };
                decls[1] = Declaration{ .property = "outline-width", .value = val.value };
                return decls;
            }
            // Otherwise treat as color
            var css_value: []const u8 = val.value;
            if (modifier) |mod| {
                css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
            }
            const decls = try alloc.alloc(Declaration, 1);
            decls[0] = Declaration{ .property = "outline-color", .value = css_value };
            return decls;
        },
        .named => {
            // Check if it's a bare number (outline width)
            if (isPositiveInteger(val.value)) {
                const css_value = try std.fmt.allocPrint(alloc, "{s}px", .{val.value});
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "outline-style", .value = "var(--tw-outline-style)" };
                decls[1] = Declaration{ .property = "outline-width", .value = css_value };
                return decls;
            }

            // Try as color
            if (std.mem.eql(u8, val.value, "inherit")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "inherit" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "transparent")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "#0000" };
                return decls;
            } else if (std.mem.eql(u8, val.value, "current")) {
                const decls = try alloc.alloc(Declaration, 1);
                decls[0] = Declaration{ .property = "outline-color", .value = "currentColor" };
                return decls;
            } else if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                var css_value: []const u8 = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
                if (modifier) |mod| {
                    css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
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
            // Only accept non-negative integers (no decimals)
            if (isPositiveInteger(val.value)) {
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
            if (theme.resolve(val.value, "--color")) {
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
    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-ring-offset-width", .value = css_value };
    decls[1] = Declaration{ .property = "--tw-ring-offset-shadow", .value = "var(--tw-ring-inset,) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color)" };
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
            if (theme.resolve(val.value, "--color")) {
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
    var custom_prop_value: []const u8 = undefined;
    switch (val.kind) {
        .arbitrary => {
            css_value = val.value;
            custom_prop_value = val.value;
        },
        .named => {
            const var_name = try std.fmt.allocPrint(alloc, "--font-weight-{s}", .{val.value});
            if (theme.get(var_name) != null) {
                theme.markUsed(var_name);
                css_value = try std.fmt.allocPrint(alloc, "var({s})", .{var_name});
                custom_prop_value = css_value;
            } else if (isPositiveInteger(val.value)) {
                css_value = val.value;
                custom_prop_value = val.value;
            } else {
                return null;
            }
        },
    }
    const decls = try alloc.alloc(Declaration, 2);
    decls[0] = Declaration{ .property = "--tw-font-weight", .value = custom_prop_value };
    decls[1] = Declaration{ .property = "font-weight", .value = css_value };
    return decls;
}

// ─── Drop Shadow ───────────────────────────────────────────────────────────

fn resolveDropShadow(alloc: Allocator, value: ?Value, theme: *Theme) !?[]const Declaration {
    const val = value orelse {
        // bare drop-shadow = default: resolve from theme and convert colors
        if (theme.get("--drop-shadow")) |raw_val| {
            theme.markUsed("--drop-shadow");
            // --tw-drop-shadow-size: with var(--tw-drop-shadow-color,...) wrapping
            const color_wrapped = try convertDropShadowColors(alloc, raw_val);
            const drop_shadow_size = try wrapDropShadowParts(alloc, color_wrapped);
            // --tw-drop-shadow: with raw hex colors (no var wrapping)
            const hex_converted = try convertRgbToHexOnly(alloc, raw_val);
            const drop_shadow_value = try wrapDropShadowParts(alloc, hex_converted);
            const decls = try alloc.alloc(Declaration, 3);
            decls[0] = Declaration{ .property = "--tw-drop-shadow-size", .value = drop_shadow_size };
            decls[1] = Declaration{ .property = "--tw-drop-shadow", .value = drop_shadow_value };
            decls[2] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
            return decls;
        }
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-drop-shadow", .value = "drop-shadow(var(--drop-shadow))" };
        decls[1] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
        return decls;
    };
    switch (val.kind) {
        .arbitrary => {
            const decls = try alloc.alloc(Declaration, 2);
            decls[0] = Declaration{ .property = "--tw-drop-shadow", .value = try std.fmt.allocPrint(alloc, "drop-shadow({s})", .{val.value}) };
            decls[1] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
            return decls;
        },
        .named => {
            if (std.mem.eql(u8, val.value, "none")) {
                const decls = try alloc.alloc(Declaration, 2);
                decls[0] = Declaration{ .property = "--tw-drop-shadow", .value = " " };
                decls[1] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
                return decls;
            } else {
                const var_name = try std.fmt.allocPrint(alloc, "--drop-shadow-{s}", .{val.value});
                if (theme.get(var_name)) |raw_val| {
                    theme.markUsed(var_name);
                    // --tw-drop-shadow-size: color-wrapped in var(--tw-drop-shadow-color,...)
                    const color_wrapped = try convertDropShadowColors(alloc, raw_val);
                    const drop_shadow_size = try wrapDropShadowParts(alloc, color_wrapped);
                    // --tw-drop-shadow: uses var() reference (not pre-resolved)
                    const drop_shadow_value = try std.fmt.allocPrint(alloc, "drop-shadow(var({s}))", .{var_name});
                    const decls = try alloc.alloc(Declaration, 3);
                    decls[0] = Declaration{ .property = "--tw-drop-shadow-size", .value = drop_shadow_size };
                    decls[1] = Declaration{ .property = "--tw-drop-shadow", .value = drop_shadow_value };
                    decls[2] = Declaration{ .property = "filter", .value = COMPOSABLE_FILTER };
                    return decls;
                } else {
                    return null;
                }
            }
        },
    }
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
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{stripLeadingZero(val.value)});
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
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-border-spacing-x", .value = css_value };
        decls[1] = Declaration{ .property = "border-spacing", .value = "var(--tw-border-spacing-x) var(--tw-border-spacing-y)" };
        return decls;
    }
    if (std.mem.eql(u8, root, "border-spacing-y")) {
        const decls = try alloc.alloc(Declaration, 2);
        decls[0] = Declaration{ .property = "--tw-border-spacing-y", .value = css_value };
        decls[1] = Declaration{ .property = "border-spacing", .value = "var(--tw-border-spacing-x) var(--tw-border-spacing-y)" };
        return decls;
    }
    // bare border-spacing sets both x and y
    const decls = try alloc.alloc(Declaration, 3);
    decls[0] = Declaration{ .property = "--tw-border-spacing-x", .value = css_value };
    decls[1] = Declaration{ .property = "--tw-border-spacing-y", .value = css_value };
    decls[2] = Declaration{ .property = "border-spacing", .value = "var(--tw-border-spacing-x) var(--tw-border-spacing-y)" };
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
                css_value = try std.fmt.allocPrint(alloc, "calc(var(--spacing) * {s})", .{stripLeadingZero(val.value)});
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
                css_value = "#0000";
            } else if (std.mem.eql(u8, val.value, "current")) {
                css_value = "currentColor";
            } else if (theme.resolve(val.value, "--color")) {
                theme.markUsed(try std.fmt.allocPrint(alloc, "--color-{s}", .{val.value}));
                css_value = try std.fmt.allocPrint(alloc, "var(--color-{s})", .{val.value});
            } else {
                return null;
            }
        },
    }
    if (modifier) |mod| {
        css_value = try applyColorOpacityWithTheme(alloc, css_value, mod, theme);
    }
    const decls = try alloc.alloc(Declaration, 1);
    decls[0] = Declaration{ .property = "--tw-shadow-color", .value = css_value };
    return decls;
}

// ─── Shadow Color Conversion Helpers ────────────────────────────────────────

/// Convert rgb() colors in a shadow value to hex8 format and wrap in var(--tw-shadow-color,...).
/// e.g. "0 10px 15px -3px rgb(0 0 0 / 0.1)" -> "0 10px 15px -3px var(--tw-shadow-color,#0000001a)"
fn convertShadowColors(alloc: Allocator, raw: []const u8) ![]const u8 {
    var result = try std.ArrayList(u8).initCapacity(alloc, raw.len);
    var i: usize = 0;
    while (i < raw.len) {
        if (i + 4 <= raw.len and std.mem.eql(u8, raw[i .. i + 4], "rgb(")) {
            // Find closing paren
            var depth: usize = 0;
            var j = i;
            while (j < raw.len) {
                if (raw[j] == '(') depth += 1;
                if (raw[j] == ')') {
                    depth -= 1;
                    if (depth == 0) {
                        j += 1;
                        break;
                    }
                }
                j += 1;
            }
            const rgb_str = raw[i..j];
            // Convert to hex and wrap
            const hex = try rgbToHex8(alloc, rgb_str);
            try result.appendSlice(alloc, "var(--tw-shadow-color,");
            try result.appendSlice(alloc, hex);
            try result.append(alloc, ')');
            i = j;
        } else {
            try result.append(alloc, raw[i]);
            i += 1;
        }
    }
    return result.toOwnedSlice(alloc);
}

/// Split a comma-separated drop-shadow value and wrap each part in drop-shadow().
/// E.g. "0 1px 2px #0000001a, 0 1px 1px #0000000f" -> "drop-shadow(0 1px 2px #0000001a) drop-shadow(0 1px 1px #0000000f)"
fn wrapDropShadowParts(alloc: Allocator, converted: []const u8) ![]const u8 {
    var result = try std.ArrayList(u8).initCapacity(alloc, converted.len + 30);
    // Split on commas, but only top-level (not inside parens)
    var start: usize = 0;
    var depth: usize = 0;
    var first = true;
    for (converted, 0..) |ch, idx| {
        if (ch == '(') depth += 1;
        if (ch == ')') depth -= 1;
        if (ch == ',' and depth == 0) {
            const part = std.mem.trim(u8, converted[start..idx], " ");
            if (part.len > 0) {
                if (!first) try result.append(alloc, ' ');
                try result.appendSlice(alloc, "drop-shadow(");
                try result.appendSlice(alloc, part);
                try result.append(alloc, ')');
                first = false;
            }
            start = idx + 1;
        }
    }
    // Last part
    const part = std.mem.trim(u8, converted[start..], " ");
    if (part.len > 0) {
        if (!first) try result.append(alloc, ' ');
        try result.appendSlice(alloc, "drop-shadow(");
        try result.appendSlice(alloc, part);
        try result.append(alloc, ')');
    }
    return result.toOwnedSlice(alloc);
}

/// Convert rgb() colors in a drop-shadow value to hex8 format and wrap in var(--tw-drop-shadow-color,...).
fn convertDropShadowColors(alloc: Allocator, raw: []const u8) ![]const u8 {
    var result = try std.ArrayList(u8).initCapacity(alloc, raw.len);
    var i: usize = 0;
    while (i < raw.len) {
        if (i + 4 <= raw.len and std.mem.eql(u8, raw[i .. i + 4], "rgb(")) {
            // Find closing paren
            var depth: usize = 0;
            var j = i;
            while (j < raw.len) {
                if (raw[j] == '(') depth += 1;
                if (raw[j] == ')') {
                    depth -= 1;
                    if (depth == 0) {
                        j += 1;
                        break;
                    }
                }
                j += 1;
            }
            const rgb_str = raw[i..j];
            const hex = try rgbToHex8(alloc, rgb_str);
            try result.appendSlice(alloc, "var(--tw-drop-shadow-color,");
            try result.appendSlice(alloc, hex);
            try result.append(alloc, ')');
            i = j;
        } else {
            try result.append(alloc, raw[i]);
            i += 1;
        }
    }
    return result.toOwnedSlice(alloc);
}

/// Convert rgb() colors to hex without var() wrapping (for --tw-drop-shadow).
fn convertRgbToHexOnly(alloc: Allocator, raw: []const u8) ![]const u8 {
    var result = try std.ArrayList(u8).initCapacity(alloc, raw.len);
    var i: usize = 0;
    while (i < raw.len) {
        if (i + 4 <= raw.len and std.mem.eql(u8, raw[i .. i + 4], "rgb(")) {
            var depth: usize = 0;
            var j = i;
            while (j < raw.len) {
                if (raw[j] == '(') depth += 1;
                if (raw[j] == ')') { depth -= 1; if (depth == 0) { j += 1; break; } }
                j += 1;
            }
            const hex = try rgbToHex8(alloc, raw[i..j]);
            try result.appendSlice(alloc, hex);
            i = j;
        } else {
            try result.append(alloc, raw[i]);
            i += 1;
        }
    }
    return result.toOwnedSlice(alloc);
}

/// Parse "rgb(R G B / A)" and convert to "#RRGGBBAA" hex8 format.
fn rgbToHex8(alloc: Allocator, rgb: []const u8) ![]const u8 {
    const inner_start = std.mem.indexOf(u8, rgb, "(") orelse return rgb;
    const inner_end = std.mem.lastIndexOf(u8, rgb, ")") orelse return rgb;
    if (inner_start + 1 >= inner_end) return rgb;
    const inner = std.mem.trim(u8, rgb[inner_start + 1 .. inner_end], " ");

    // Split on spaces and /
    var parts: [4][]const u8 = undefined;
    var part_count: usize = 0;
    var iter = std.mem.tokenizeAny(u8, inner, " /");
    while (iter.next()) |part| {
        if (part_count < 4) {
            parts[part_count] = part;
            part_count += 1;
        }
    }

    if (part_count < 4) return rgb; // Can't parse, return as-is

    const r = std.fmt.parseInt(u8, parts[0], 10) catch return rgb;
    const g = std.fmt.parseInt(u8, parts[1], 10) catch return rgb;
    const b = std.fmt.parseInt(u8, parts[2], 10) catch return rgb;
    const alpha = std.fmt.parseFloat(f64, parts[3]) catch return rgb;
    const a: u8 = @intFromFloat(@round(alpha * 255.0));

    return std.fmt.allocPrint(alloc, "#{x:0>2}{x:0>2}{x:0>2}{x:0>2}", .{ r, g, b, a });
}

/// Normalize arbitrary duration/delay values: convert "250ms" -> ".25s", pass through "s" values.
fn normalizeDurationValue(alloc: Allocator, val: []const u8) ![]const u8 {
    if (std.mem.endsWith(u8, val, "ms")) {
        const num_str = val[0 .. val.len - 2];
        const ms_val = std.fmt.parseInt(u32, num_str, 10) catch return val;
        return formatMsToSeconds(alloc, ms_val);
    }
    return val;
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
