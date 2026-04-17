const std = @import("std");
const Allocator = std.mem.Allocator;
const emitter = @import("emitter.zig");
const Rule = emitter.Rule;
const Declaration = emitter.Declaration;
const Theme = @import("theme.zig").Theme;
const candidate_mod = @import("candidate.zig");
const Variant = candidate_mod.Variant;

// ─── Variant Registry ──────────────────────────────────────────────────────

/// Check if a variant name is registered.
pub fn isVariant(name: []const u8) bool {
    if (static_variants.has(name)) return true;
    if (functional_variant_roots.has(name)) return true;
    if (compound_variant_roots.has(name)) return true;
    return false;
}

/// Check if a name is a registered functional variant root (e.g., aria, data, supports).
pub fn isFunctionalVariantRoot(name: []const u8) bool {
    return functional_variant_roots.has(name);
}

/// Get the sort order for a variant.
pub fn variantOrder(name: []const u8) u16 {
    return variant_order_map.get(name) orelse 999;
}

/// Apply a list of parsed variants to a CSS rule, wrapping it in the appropriate
/// selectors and media queries.
pub fn applyVariants(
    alloc: Allocator,
    base_rule: Rule,
    variants: []const Variant,
    theme: *Theme,
    raw_candidate: []const u8,
) !Rule {
    var current = base_rule;

    // Apply variants from innermost (first in array) to outermost (last)
    for (variants) |variant| {
        current = try applyVariant(alloc, current, variant, theme, raw_candidate);
    }

    return current;
}

fn applyVariant(
    alloc: Allocator,
    inner: Rule,
    variant: Variant,
    theme: *Theme,
    raw_candidate: []const u8,
) !Rule {
    switch (variant.kind) {
        .static => return applyStaticVariant(alloc, inner, variant.root, theme, raw_candidate),
        .functional => return applyFunctionalVariant(alloc, inner, variant, theme, raw_candidate),
        .compound => return applyCompoundVariant(alloc, inner, variant, raw_candidate),
        .arbitrary => return applyArbitraryVariant(alloc, inner, variant, raw_candidate),
    }
}

fn applyStaticVariant(
    alloc: Allocator,
    inner: Rule,
    name: []const u8,
    theme: *Theme,
    raw_candidate: []const u8,
) !Rule {
    _ = raw_candidate;

    // Selector-based pseudo-class variants
    if (std.mem.eql(u8, name, "hover")) {
        // hover is special: both @media (hover:hover) and :hover selector
        const hover_rule = Rule{
            .kind = .style,
            .selector = try appendPseudo(alloc, inner.selector orelse "", ":hover"),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
        const media_children = try alloc.alloc(Rule, 1);
        media_children[0] = hover_rule;
        return Rule{
            .kind = .media,
            .at_rule = "@media (hover:hover)",
            .children = media_children,
            .variant_order = inner.variant_order,
        };
    }

    // Simple pseudo-class variants
    if (pseudo_class_map.get(name)) |pseudo| {
        // If inner is a non-style rule (media, container, supports), apply pseudo to children
        if (inner.kind != .style and inner.children.len > 0) {
            var new_children = try alloc.alloc(Rule, inner.children.len);
            for (inner.children, 0..) |child, ci| {
                if (child.kind == .style) {
                    new_children[ci] = Rule{
                        .kind = .style,
                        .selector = try appendPseudo(alloc, child.selector orelse "", pseudo),
                        .declarations = child.declarations,
                        .children = child.children,
                        .variant_order = child.variant_order,
                    };
                } else {
                    new_children[ci] = child;
                }
            }
            return Rule{
                .kind = inner.kind,
                .at_rule = inner.at_rule,
                .selector = inner.selector,
                .declarations = inner.declarations,
                .children = new_children,
                .variant_order = inner.variant_order,
            };
        }
        return Rule{
            .kind = .style,
            .selector = try appendPseudo(alloc, inner.selector orelse "", pseudo),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }

    // Before/after pseudo-element variants (with content injection)
    if (std.mem.eql(u8, name, "before") or std.mem.eql(u8, name, "after")) {
        const pseudo = if (std.mem.eql(u8, name, "before")) "::before" else "::after";

        // Inject content declaration + original declarations
        const content_decl = Declaration{ .property = "content", .value = "var(--tw-content)" };
        var new_decls = try alloc.alloc(Declaration, inner.declarations.len + 1);
        new_decls[0] = content_decl;
        for (inner.declarations, 0..) |d, idx| {
            new_decls[idx + 1] = d;
        }

        return Rule{
            .kind = .style,
            .selector = try std.fmt.allocPrint(alloc, "{s}{s}", .{ inner.selector orelse "", pseudo }),
            .declarations = new_decls,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }

    // Multi-selector pseudo-element variants (marker, selection)
    // These need to target both the element itself and its descendants.
    if (multi_selector_pseudo_map.get(name)) |selectors| {
        const children = try alloc.alloc(Rule, selectors.len);
        for (selectors, 0..) |sel, i| {
            children[i] = Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
            };
        }
        return Rule{
            .kind = .style,
            .selector = inner.selector,
            .declarations = &.{},
            .children = children,
            .variant_order = inner.variant_order,
        };
    }

    // Pseudo-element variants — use CSS nesting: .sel { &::pseudo { ... } }
    if (pseudo_element_map.get(name)) |pseudo| {
        const child_sel = try std.fmt.allocPrint(alloc, "&{s}", .{pseudo});
        const children = try alloc.alloc(Rule, 1);
        children[0] = Rule{
            .kind = .style,
            .selector = child_sel,
            .declarations = inner.declarations,
            .children = inner.children,
        };
        return Rule{
            .kind = .style,
            .selector = inner.selector,
            .declarations = &.{},
            .children = children,
            .variant_order = inner.variant_order,
        };
    }

    // Media preference variants
    if (media_variant_map.get(name)) |media_query| {
        const children = try alloc.alloc(Rule, 1);
        children[0] = inner;
        return Rule{
            .kind = .media,
            .at_rule = media_query,
            .children = children,
            .variant_order = inner.variant_order,
        };
    }

    // At-rule variants
    if (std.mem.eql(u8, name, "starting")) {
        const children = try alloc.alloc(Rule, 1);
        children[0] = inner;
        return Rule{
            .kind = .at_starting_style,
            .children = children,
            .variant_order = inner.variant_order,
        };
    }

    // Responsive breakpoints: sm, md, lg, xl, 2xl
    if (std.mem.eql(u8, name, "sm") or std.mem.eql(u8, name, "md") or
        std.mem.eql(u8, name, "lg") or std.mem.eql(u8, name, "xl") or
        std.mem.eql(u8, name, "2xl"))
    {
        if (theme.getBreakpoint(name)) |bp_value| {
            const media = try std.fmt.allocPrint(alloc, "@media (width>={s})", .{bp_value});
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .media,
                .at_rule = media,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // * and ** variants
    if (std.mem.eql(u8, name, "*")) {
        return Rule{
            .kind = .style,
            .selector = try std.fmt.allocPrint(alloc, ":is({s} > *)", .{inner.selector orelse ""}),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }
    if (std.mem.eql(u8, name, "**")) {
        return Rule{
            .kind = .style,
            .selector = try std.fmt.allocPrint(alloc, ":is({s} *)", .{inner.selector orelse ""}),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }

    // Direction variants
    if (std.mem.eql(u8, name, "ltr")) {
        return Rule{
            .kind = .style,
            .selector = try std.fmt.allocPrint(alloc, "{s}:where(:dir(ltr), [dir=\"ltr\"], [dir=\"ltr\"] *)", .{inner.selector orelse ""}),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }
    if (std.mem.eql(u8, name, "rtl")) {
        return Rule{
            .kind = .style,
            .selector = try std.fmt.allocPrint(alloc, "{s}:where(:dir(rtl), [dir=\"rtl\"], [dir=\"rtl\"] *)", .{inner.selector orelse ""}),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }

    return inner;
}

fn applyFunctionalVariant(
    alloc: Allocator,
    inner: Rule,
    variant: Variant,
    theme: *Theme,
    raw_candidate: []const u8,
) !Rule {
    _ = raw_candidate;
    const root = variant.root;

    // Responsive breakpoints: sm, md, lg, xl, 2xl
    if (std.mem.eql(u8, root, "sm") or std.mem.eql(u8, root, "md") or
        std.mem.eql(u8, root, "lg") or std.mem.eql(u8, root, "xl") or
        std.mem.eql(u8, root, "2xl"))
    {
        if (theme.getBreakpoint(root)) |bp_value| {
            const media = try std.fmt.allocPrint(alloc, "@media (width>={s})", .{bp_value});
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .media,
                .at_rule = media,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // min-* variant
    if (std.mem.eql(u8, root, "min")) {
        if (variant.value) |val| {
            var bp_value: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    bp_value = val.value;
                },
                .named => {
                    bp_value = theme.getBreakpoint(val.value) orelse return inner;
                },
            }
            const media = try std.fmt.allocPrint(alloc, "@media (width>={s})", .{bp_value});
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .media,
                .at_rule = media,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // max-* variant
    if (std.mem.eql(u8, root, "max")) {
        if (variant.value) |val| {
            var bp_value: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    bp_value = val.value;
                },
                .named => {
                    bp_value = theme.getBreakpoint(val.value) orelse return inner;
                },
            }
            const media = try std.fmt.allocPrint(alloc, "@media not all and (width>={s})", .{bp_value});
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .media,
                .at_rule = media,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // @ container queries
    if (std.mem.eql(u8, root, "@")) {
        if (variant.value) |val| {
            var size_value: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    size_value = val.value;
                },
                .named => {
                    size_value = theme.getContainer(val.value) orelse return inner;
                },
            }
            var container_query: []const u8 = undefined;
            if (variant.modifier) |mod| {
                container_query = try std.fmt.allocPrint(alloc, "@container {s} (width>={s})", .{ mod.value, size_value });
            } else {
                container_query = try std.fmt.allocPrint(alloc, "@container (width>={s})", .{size_value});
            }
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .container,
                .at_rule = container_query,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // aria-* variant
    if (std.mem.eql(u8, root, "aria")) {
        if (variant.value) |val| {
            switch (val.kind) {
                .arbitrary => {
                    const sel = try std.fmt.allocPrint(alloc, "{s}[aria-{s}]", .{ inner.selector orelse "", val.value });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                },
                .named => {
                    const sel = try std.fmt.allocPrint(alloc, "{s}[aria-{s}=\"true\"]", .{ inner.selector orelse "", val.value });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                },
            }
        }
    }

    // data-* variant
    if (std.mem.eql(u8, root, "data")) {
        if (variant.value) |val| {
            switch (val.kind) {
                .arbitrary => {
                    const sel = try std.fmt.allocPrint(alloc, "{s}[data-{s}]", .{ inner.selector orelse "", val.value });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                },
                .named => {
                    const sel = try std.fmt.allocPrint(alloc, "{s}[data-{s}]", .{ inner.selector orelse "", val.value });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                },
            }
        }
    }

    // supports-* variant
    if (std.mem.eql(u8, root, "supports")) {
        if (variant.value) |val| {
            var query: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    if (std.mem.indexOfScalar(u8, val.value, ':') != null) {
                        query = try std.fmt.allocPrint(alloc, "@supports ({s})", .{val.value});
                    } else {
                        query = try std.fmt.allocPrint(alloc, "@supports ({s}: var(--tw))", .{val.value});
                    }
                },
                .named => {
                    query = try std.fmt.allocPrint(alloc, "@supports ({s}: var(--tw))", .{val.value});
                },
            }
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .supports,
                .at_rule = query,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // nth-* variants
    if (std.mem.eql(u8, root, "nth")) {
        if (variant.value) |val| {
            const arg = switch (val.kind) {
                .arbitrary => val.value,
                .named => val.value,
            };
            const sel = try std.fmt.allocPrint(alloc, "{s}:nth-child({s})", .{ inner.selector orelse "", arg });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    if (std.mem.eql(u8, root, "nth-last")) {
        if (variant.value) |val| {
            const arg = switch (val.kind) {
                .arbitrary => val.value,
                .named => val.value,
            };
            const sel = try std.fmt.allocPrint(alloc, "{s}:nth-last-child({s})", .{ inner.selector orelse "", arg });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    if (std.mem.eql(u8, root, "nth-of-type")) {
        if (variant.value) |val| {
            const arg = switch (val.kind) {
                .arbitrary => val.value,
                .named => val.value,
            };
            const sel = try std.fmt.allocPrint(alloc, "{s}:nth-of-type({s})", .{ inner.selector orelse "", arg });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    if (std.mem.eql(u8, root, "nth-last-of-type")) {
        if (variant.value) |val| {
            const arg = switch (val.kind) {
                .arbitrary => val.value,
                .named => val.value,
            };
            const sel = try std.fmt.allocPrint(alloc, "{s}:nth-last-of-type({s})", .{ inner.selector orelse "", arg });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // @min container query variant
    if (std.mem.eql(u8, root, "@min")) {
        if (variant.value) |val| {
            var size_value: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    size_value = val.value;
                },
                .named => {
                    size_value = theme.getContainer(val.value) orelse return inner;
                },
            }
            var container_query: []const u8 = undefined;
            if (variant.modifier) |mod| {
                container_query = try std.fmt.allocPrint(alloc, "@container {s} (width>={s})", .{ mod.value, size_value });
            } else {
                container_query = try std.fmt.allocPrint(alloc, "@container (width>={s})", .{size_value});
            }
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .container,
                .at_rule = container_query,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    // @max container query variant
    if (std.mem.eql(u8, root, "@max")) {
        if (variant.value) |val| {
            var size_value: []const u8 = undefined;
            switch (val.kind) {
                .arbitrary => {
                    size_value = val.value;
                },
                .named => {
                    size_value = theme.getContainer(val.value) orelse return inner;
                },
            }
            var container_query: []const u8 = undefined;
            if (variant.modifier) |mod| {
                container_query = try std.fmt.allocPrint(alloc, "@container {s} not (width>={s})", .{ mod.value, size_value });
            } else {
                container_query = try std.fmt.allocPrint(alloc, "@container not (width>={s})", .{size_value});
            }
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .container,
                .at_rule = container_query,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }
    }

    return inner;
}

/// Build an attribute selector from a functional variant value like "data-disabled"
/// or "data-[state=active]". For data variants:
///   "data-disabled"        -> "[data-disabled]"
///   "data-[state=active]"  -> "[data-state=active]"
/// For aria variants:
///   "aria-checked"         -> "[aria-checked=\"true\"]"
///   "aria-[sort=ascending]"-> "[aria-sort=ascending]"
fn buildFunctionalAttrSelector(alloc: Allocator, value: []const u8) !?[]const u8 {
    if (std.mem.startsWith(u8, value, "data-")) {
        const rest = value["data-".len..];
        if (rest.len > 2 and rest[0] == '[' and rest[rest.len - 1] == ']') {
            // Arbitrary: data-[state=active] -> [data-state=active]
            const arb_inner = rest[1 .. rest.len - 1];
            return try std.fmt.allocPrint(alloc, "[data-{s}]", .{arb_inner});
        }
        // Named: data-disabled -> [data-disabled]
        return try std.fmt.allocPrint(alloc, "[data-{s}]", .{rest});
    }
    if (std.mem.startsWith(u8, value, "aria-")) {
        const rest = value["aria-".len..];
        if (rest.len > 2 and rest[0] == '[' and rest[rest.len - 1] == ']') {
            // Arbitrary: aria-[sort=ascending] -> [aria-sort=ascending]
            const arb_inner = rest[1 .. rest.len - 1];
            return try std.fmt.allocPrint(alloc, "[aria-{s}]", .{arb_inner});
        }
        // Named: aria-checked -> [aria-checked="true"]
        return try std.fmt.allocPrint(alloc, "[aria-{s}=\"true\"]", .{rest});
    }
    return null;
}

fn applyCompoundVariant(
    alloc: Allocator,
    inner: Rule,
    variant: Variant,
    raw_candidate: []const u8,
) !Rule {
    _ = raw_candidate;
    const root = variant.root;

    if (std.mem.eql(u8, root, "group")) {
        // group-hover: wrap selector to match ancestor
        if (variant.value) |val| {
            if (val.kind == .named) {
                const group_class = if (variant.modifier) |mod|
                    try std.fmt.allocPrint(alloc, ".group\\/{s}", .{mod.value})
                else
                    ".group";

                if (pseudo_class_map.get(val.value)) |pseudo| {
                    const sel = try std.fmt.allocPrint(alloc, "{s}:is(:where({s}){s} *)", .{
                        inner.selector orelse "",
                        group_class,
                        pseudo,
                    });

                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                } else if (try buildFunctionalAttrSelector(alloc, val.value)) |attr_sel| {
                    // group-aria-checked, group-aria-[sort=ascending],
                    // group-data-visible, group-data-[state=active]
                    const sel = try std.fmt.allocPrint(alloc, "{s}:is(:where({s}{s}) *)", .{
                        inner.selector orelse "",
                        group_class,
                        attr_sel,
                    });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                }
            }
        }
    }

    if (std.mem.eql(u8, root, "peer")) {
        if (variant.value) |val| {
            if (val.kind == .named) {
                const peer_class = if (variant.modifier) |mod|
                    try std.fmt.allocPrint(alloc, ".peer\\/{s}", .{mod.value})
                else
                    ".peer";

                if (pseudo_class_map.get(val.value)) |pseudo| {
                    const sel = try std.fmt.allocPrint(alloc, "{s}:is(:where({s}){s} ~ *)", .{
                        inner.selector orelse "",
                        peer_class,
                        pseudo,
                    });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                } else if (try buildFunctionalAttrSelector(alloc, val.value)) |attr_sel| {
                    // peer-aria-checked, peer-aria-[sort=ascending],
                    // peer-data-visible, peer-data-[state=active]
                    const sel = try std.fmt.allocPrint(alloc, "{s}:is(:where({s}{s}) ~ *)", .{
                        inner.selector orelse "",
                        peer_class,
                        attr_sel,
                    });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                }
            }
        }
    }

    if (std.mem.eql(u8, root, "has")) {
        if (variant.value) |val| {
            const has_arg = switch (val.kind) {
                .arbitrary => val.value,
                .named => blk: {
                    if (pseudo_class_map.get(val.value)) |pseudo| {
                        break :blk pseudo;
                    }
                    // Check for data-*/aria-* functional attribute variants
                    if (try buildFunctionalAttrSelector(alloc, val.value)) |attr_sel| {
                        break :blk attr_sel;
                    }
                    break :blk val.value;
                },
            };
            const sel = try std.fmt.allocPrint(alloc, "{s}:has({s})", .{ inner.selector orelse "", has_arg });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    if (std.mem.eql(u8, root, "not")) {
        if (variant.value) |val| {
            if (val.kind == .named) {
                const not_arg: ?[]const u8 = if (pseudo_class_map.get(val.value)) |pseudo|
                    pseudo
                else if (try buildFunctionalAttrSelector(alloc, val.value)) |attr_sel|
                    attr_sel
                else
                    null;
                if (not_arg) |arg| {
                    const sel = try std.fmt.allocPrint(alloc, "{s}:not({s})", .{ inner.selector orelse "", arg });
                    return Rule{
                        .kind = .style,
                        .selector = sel,
                        .declarations = inner.declarations,
                        .children = inner.children,
                        .variant_order = inner.variant_order,
                    };
                }
            }
        }
    }

    if (std.mem.eql(u8, root, "in")) {
        const ancestor_sel: ?[]const u8 = if (variant.value) |val| switch (val.kind) {
            .arbitrary => val.value,
            .named => if (pseudo_class_map.get(val.value)) |pseudo| pseudo else val.value,
        } else if (variant.selector) |sel_val|
            sel_val
        else
            null;
        if (ancestor_sel) |anc_sel| {
            const sel = try std.fmt.allocPrint(alloc, ":where({s}) {s}", .{ anc_sel, inner.selector orelse "" });
            return Rule{
                .kind = .style,
                .selector = sel,
                .declarations = inner.declarations,
                .children = inner.children,
                .variant_order = inner.variant_order,
            };
        }
    }

    return inner;
}

fn applyArbitraryVariant(
    alloc: Allocator,
    inner: Rule,
    variant: Variant,
    raw_candidate: []const u8,
) !Rule {
    _ = raw_candidate;
    if (variant.selector) |raw_sel_template| {
        // Decode underscores to spaces in arbitrary variant selectors,
        // matching Tailwind CSS behavior where _ is a space substitute.
        // e.g., [&_p]:mb-4 -> "& p" selector (descendant combinator)
        const sel_template = try candidate_mod.decodeArbitraryValue(alloc, raw_sel_template);

        // Check if it's an at-rule (starts with @)
        if (sel_template.len > 0 and sel_template[0] == '@') {
            const children = try alloc.alloc(Rule, 1);
            children[0] = inner;
            return Rule{
                .kind = .media,
                .at_rule = sel_template,
                .children = children,
                .variant_order = inner.variant_order,
            };
        }

        // If inner is a wrapping rule (media, container, supports), apply the
        // selector variant to each child rule and keep the wrapper intact.
        if (inner.kind == .media or inner.kind == .container or inner.kind == .supports) {
            const new_children = try alloc.alloc(Rule, inner.children.len);
            for (inner.children, 0..) |child, i| {
                new_children[i] = try applyArbitrarySelectorToStyle(alloc, child, sel_template);
            }
            return Rule{
                .kind = inner.kind,
                .at_rule = inner.at_rule,
                .children = new_children,
                .variant_order = inner.variant_order,
            };
        }

        return applyArbitrarySelectorToStyle(alloc, inner, sel_template);
    }
    return inner;
}

/// Apply an arbitrary selector template (e.g. "&>h3") to a style rule.
fn applyArbitrarySelectorToStyle(alloc: Allocator, inner: Rule, sel_template: []const u8) !Rule {
    // Selector variant: replace & with the inner selector
    if (std.mem.indexOf(u8, sel_template, "&")) |_| {
        // Has & placeholder
        var result = try std.ArrayList(u8).initCapacity(alloc, sel_template.len + (inner.selector orelse "").len);
        for (sel_template) |c| {
            if (c == '&') {
                try result.appendSlice(alloc, inner.selector orelse "");
            } else {
                try result.append(alloc, c);
            }
        }
        return Rule{
            .kind = .style,
            .selector = try result.toOwnedSlice(alloc),
            .declarations = inner.declarations,
            .children = inner.children,
            .variant_order = inner.variant_order,
        };
    }

    // No & — descendent selector
    const sel = try std.fmt.allocPrint(alloc, "{s} {s}", .{ inner.selector orelse "", sel_template });
    return Rule{
        .kind = .style,
        .selector = sel,
        .declarations = inner.declarations,
        .children = inner.children,
        .variant_order = inner.variant_order,
    };
}

fn appendPseudo(alloc: Allocator, selector: []const u8, pseudo: []const u8) ![]const u8 {
    return std.fmt.allocPrint(alloc, "{s}{s}", .{ selector, pseudo });
}

// ─── Static Lookup Tables ──────────────────────────────────────────────────

const static_variants = std.StaticStringMap(void).initComptime(.{
    .{ "*", {} },
    .{ "**", {} },
    .{ "hover", {} },
    .{ "focus", {} },
    .{ "focus-within", {} },
    .{ "focus-visible", {} },
    .{ "active", {} },
    .{ "visited", {} },
    .{ "target", {} },
    .{ "first", {} },
    .{ "last", {} },
    .{ "only", {} },
    .{ "odd", {} },
    .{ "even", {} },
    .{ "first-of-type", {} },
    .{ "last-of-type", {} },
    .{ "only-of-type", {} },
    .{ "empty", {} },
    .{ "disabled", {} },
    .{ "enabled", {} },
    .{ "checked", {} },
    .{ "indeterminate", {} },
    .{ "default", {} },
    .{ "required", {} },
    .{ "valid", {} },
    .{ "invalid", {} },
    .{ "optional", {} },
    .{ "placeholder-shown", {} },
    .{ "autofill", {} },
    .{ "read-only", {} },
    .{ "open", {} },
    .{ "inert", {} },
    .{ "user-valid", {} },
    .{ "user-invalid", {} },
    .{ "in-range", {} },
    .{ "out-of-range", {} },
    .{ "before", {} },
    .{ "after", {} },
    .{ "first-letter", {} },
    .{ "first-line", {} },
    .{ "marker", {} },
    .{ "selection", {} },
    .{ "file", {} },
    .{ "placeholder", {} },
    .{ "backdrop", {} },
    .{ "details-content", {} },
    .{ "dark", {} },
    .{ "print", {} },
    .{ "motion-safe", {} },
    .{ "motion-reduce", {} },
    .{ "contrast-more", {} },
    .{ "contrast-less", {} },
    .{ "portrait", {} },
    .{ "landscape", {} },
    .{ "forced-colors", {} },
    .{ "inverted-colors", {} },
    .{ "pointer-none", {} },
    .{ "pointer-coarse", {} },
    .{ "pointer-fine", {} },
    .{ "any-hover", {} },
    .{ "any-pointer-none", {} },
    .{ "any-pointer-coarse", {} },
    .{ "any-pointer-fine", {} },
    .{ "prefers-reduced-transparency", {} },
    .{ "noscript", {} },
    .{ "ltr", {} },
    .{ "rtl", {} },
    .{ "starting", {} },
    // Breakpoints are handled as functional but also registered as static for the variant_exists check
    .{ "sm", {} },
    .{ "md", {} },
    .{ "lg", {} },
    .{ "xl", {} },
    .{ "2xl", {} },
});

const functional_variant_roots = std.StaticStringMap(void).initComptime(.{
    .{ "aria", {} },
    .{ "data", {} },
    .{ "supports", {} },
    .{ "min", {} },
    .{ "max", {} },
    .{ "nth", {} },
    .{ "nth-last", {} },
    .{ "nth-of-type", {} },
    .{ "nth-last-of-type", {} },
    .{ "@", {} },
    .{ "@min", {} },
    .{ "@max", {} },
});

const compound_variant_roots = std.StaticStringMap(void).initComptime(.{
    .{ "group", {} },
    .{ "peer", {} },
    .{ "has", {} },
    .{ "not", {} },
    .{ "in", {} },
});

const pseudo_class_map = std.StaticStringMap([]const u8).initComptime(.{
    .{ "hover", ":hover" },
    .{ "focus", ":focus" },
    .{ "focus-within", ":focus-within" },
    .{ "focus-visible", ":focus-visible" },
    .{ "active", ":active" },
    .{ "visited", ":visited" },
    .{ "target", ":target" },
    .{ "first", ":first-child" },
    .{ "last", ":last-child" },
    .{ "only", ":only-child" },
    .{ "odd", ":nth-child(odd)" },
    .{ "even", ":nth-child(2n)" },
    .{ "first-of-type", ":first-of-type" },
    .{ "last-of-type", ":last-of-type" },
    .{ "only-of-type", ":only-of-type" },
    .{ "empty", ":empty" },
    .{ "disabled", ":disabled" },
    .{ "enabled", ":enabled" },
    .{ "checked", ":checked" },
    .{ "indeterminate", ":indeterminate" },
    .{ "default", ":default" },
    .{ "required", ":required" },
    .{ "valid", ":valid" },
    .{ "invalid", ":invalid" },
    .{ "optional", ":optional" },
    .{ "placeholder-shown", ":placeholder-shown" },
    .{ "autofill", ":autofill" },
    .{ "read-only", ":read-only" },
    .{ "open", ":is([open], :popover-open, :open)" },
    .{ "inert", ":is([inert], [inert] *)" },
    .{ "user-valid", ":user-valid" },
    .{ "user-invalid", ":user-invalid" },
    .{ "in-range", ":in-range" },
    .{ "out-of-range", ":out-of-range" },
});

const pseudo_element_map = std.StaticStringMap([]const u8).initComptime(.{
    .{ "before", "::before" },
    .{ "after", "::after" },
    .{ "first-letter", "::first-letter" },
    .{ "first-line", "::first-line" },
    .{ "file", "::file-selector-button" },
    .{ "placeholder", "::placeholder" },
    .{ "backdrop", "::backdrop" },
    .{ "details-content", "::details-content" },
});

// Pseudo-element variants that target both descendants and the element itself.
const multi_selector_pseudo_map = std.StaticStringMap([]const []const u8).initComptime(.{
    .{ "marker", &[_][]const u8{
        "& *::marker",
        "&::marker",
        "& *::-webkit-details-marker",
        "&::-webkit-details-marker",
    } },
    .{ "selection", &[_][]const u8{
        "& *::selection",
        "&::selection",
    } },
});

const media_variant_map = std.StaticStringMap([]const u8).initComptime(.{
    .{ "dark", "@media (prefers-color-scheme:dark)" },
    .{ "print", "@media print" },
    .{ "motion-safe", "@media (prefers-reduced-motion:no-preference)" },
    .{ "motion-reduce", "@media (prefers-reduced-motion:reduce)" },
    .{ "contrast-more", "@media (prefers-contrast:more)" },
    .{ "contrast-less", "@media (prefers-contrast:less)" },
    .{ "portrait", "@media (orientation:portrait)" },
    .{ "landscape", "@media (orientation:landscape)" },
    .{ "forced-colors", "@media (forced-colors:active)" },
    .{ "inverted-colors", "@media (inverted-colors:inverted)" },
    .{ "pointer-none", "@media (pointer:none)" },
    .{ "pointer-coarse", "@media (pointer:coarse)" },
    .{ "pointer-fine", "@media (pointer:fine)" },
    .{ "any-hover", "@media (any-hover:hover)" },
    .{ "any-pointer-none", "@media (any-pointer:none)" },
    .{ "any-pointer-coarse", "@media (any-pointer:coarse)" },
    .{ "any-pointer-fine", "@media (any-pointer:fine)" },
    .{ "prefers-reduced-transparency", "@media (prefers-reduced-transparency:reduce)" },
    .{ "noscript", "@media (scripting:none)" },
});

const variant_order_map = std.StaticStringMap(u16).initComptime(.{
    .{ "*", 1 },
    .{ "**", 2 },
    .{ "not", 3 },
    .{ "group", 4 },
    .{ "peer", 5 },
    .{ "first-letter", 6 },
    .{ "first-line", 7 },
    .{ "marker", 8 },
    .{ "selection", 9 },
    .{ "file", 10 },
    .{ "placeholder", 11 },
    .{ "backdrop", 12 },
    .{ "details-content", 13 },
    .{ "before", 14 },
    .{ "after", 15 },
    .{ "first", 16 },
    .{ "last", 17 },
    .{ "only", 18 },
    .{ "odd", 19 },
    .{ "even", 20 },
    .{ "first-of-type", 21 },
    .{ "last-of-type", 22 },
    .{ "only-of-type", 23 },
    .{ "visited", 24 },
    .{ "target", 25 },
    .{ "open", 26 },
    .{ "default", 27 },
    .{ "checked", 28 },
    .{ "indeterminate", 29 },
    .{ "placeholder-shown", 30 },
    .{ "autofill", 31 },
    .{ "optional", 32 },
    .{ "required", 33 },
    .{ "valid", 34 },
    .{ "invalid", 35 },
    .{ "user-valid", 36 },
    .{ "user-invalid", 37 },
    .{ "in-range", 38 },
    .{ "out-of-range", 39 },
    .{ "read-only", 40 },
    .{ "empty", 41 },
    .{ "focus-within", 42 },
    .{ "hover", 43 },
    .{ "focus", 44 },
    .{ "focus-visible", 45 },
    .{ "active", 46 },
    .{ "enabled", 47 },
    .{ "disabled", 48 },
    .{ "inert", 49 },
    .{ "in", 50 },
    .{ "has", 51 },
    .{ "aria", 52 },
    .{ "data", 53 },
    .{ "nth", 54 },
    .{ "nth-last", 55 },
    .{ "nth-of-type", 56 },
    .{ "nth-last-of-type", 57 },
    .{ "supports", 58 },
    .{ "motion-safe", 59 },
    .{ "motion-reduce", 60 },
    .{ "contrast-more", 61 },
    .{ "contrast-less", 62 },
    .{ "max", 63 },
    .{ "sm", 64 },
    .{ "md", 65 },
    .{ "lg", 66 },
    .{ "xl", 67 },
    .{ "2xl", 68 },
    .{ "min", 69 },
    .{ "@max", 70 },
    .{ "@", 71 },
    .{ "@min", 71 },
    .{ "portrait", 72 },
    .{ "landscape", 73 },
    .{ "ltr", 74 },
    .{ "rtl", 75 },
    .{ "dark", 76 },
    .{ "starting", 77 },
    .{ "print", 78 },
    .{ "forced-colors", 79 },
    .{ "inverted-colors", 80 },
    .{ "pointer-none", 81 },
    .{ "pointer-coarse", 82 },
    .{ "pointer-fine", 83 },
    .{ "any-hover", 84 },
    .{ "any-pointer-none", 85 },
    .{ "any-pointer-coarse", 86 },
    .{ "any-pointer-fine", 87 },
    .{ "prefers-reduced-transparency", 88 },
    .{ "noscript", 89 },
});

// ─── Tests ─────────────────────────────────────────────────────────────────

test "isVariant: known variants" {
    try std.testing.expect(isVariant("hover"));
    try std.testing.expect(isVariant("focus"));
    try std.testing.expect(isVariant("dark"));
    try std.testing.expect(isVariant("sm"));
    try std.testing.expect(isVariant("aria"));
    try std.testing.expect(isVariant("group"));
}

test "isVariant: unknown" {
    try std.testing.expect(!isVariant("nonexistent"));
}

test "variantOrder: ordering" {
    try std.testing.expect(variantOrder("hover") < variantOrder("dark"));
    try std.testing.expect(variantOrder("focus") < variantOrder("sm"));
    try std.testing.expect(variantOrder("*") < variantOrder("hover"));
    // Responsive breakpoints must be in ascending order (mobile-first)
    try std.testing.expect(variantOrder("sm") < variantOrder("md"));
    try std.testing.expect(variantOrder("md") < variantOrder("lg"));
    try std.testing.expect(variantOrder("lg") < variantOrder("xl"));
    try std.testing.expect(variantOrder("xl") < variantOrder("2xl"));
}
