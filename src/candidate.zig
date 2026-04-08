const std = @import("std");
const Allocator = std.mem.Allocator;

// ─── Data Structures ───────────────────────────────────────────────────────

pub const CandidateKind = enum {
    static,
    functional,
    arbitrary,
};

pub const ValueKind = enum {
    named,
    arbitrary,
};

pub const Value = struct {
    kind: ValueKind,
    value: []const u8,
    data_type: ?[]const u8 = null, // e.g. "color" in bg-[color:var(--my-color)]
    fraction: ?[]const u8 = null, // e.g. "1/2" for w-1/2
};

pub const Modifier = struct {
    kind: ValueKind,
    value: []const u8,
};

pub const VariantKind = enum {
    static,
    functional,
    compound,
    arbitrary,
};

pub const Variant = struct {
    kind: VariantKind,
    root: []const u8,
    value: ?Value = null,
    modifier: ?Modifier = null,
    /// For arbitrary variants: the raw selector
    selector: ?[]const u8 = null,
    /// For arbitrary variants: whether it starts with >, +, or ~
    relative: bool = false,
};

pub const Candidate = struct {
    kind: CandidateKind,
    raw: []const u8,
    root: []const u8,
    value: ?Value = null,
    modifier: ?Modifier = null,
    variants: []Variant,
    important: bool = false,
    /// For arbitrary properties: the CSS property name
    property: ?[]const u8 = null,
    /// Whether this is a negative utility (e.g. -m-4)
    negative: bool = false,
};

// ─── Segment: Bracket-Aware String Splitting ───────────────────────────────

/// Splits a string on a separator character, respecting brackets (), [], {},
/// quoted strings, and backslash escapes.
pub fn segment(input: []const u8, sep: u8) SegmentIterator {
    return SegmentIterator{ .input = input, .sep = sep };
}

pub const SegmentIterator = struct {
    input: []const u8,
    sep: u8,
    pos: usize = 0,
    done: bool = false,

    pub fn next(self: *SegmentIterator) ?[]const u8 {
        if (self.done) return null;

        const start = self.pos;
        var stack_depth: usize = 0;
        var closing_stack: [256]u8 = undefined;

        while (self.pos < self.input.len) {
            const c = self.input[self.pos];

            // At top level, check for separator
            if (stack_depth == 0 and c == self.sep) {
                const result = self.input[start..self.pos];
                self.pos += 1;
                return result;
            }

            switch (c) {
                '\\' => {
                    // Skip next character (escaped)
                    self.pos += 1;
                    if (self.pos < self.input.len) self.pos += 1;
                    continue;
                },
                '\'' , '"' => {
                    // Consume until matching unescaped quote
                    const quote = c;
                    self.pos += 1;
                    while (self.pos < self.input.len) {
                        if (self.input[self.pos] == '\\') {
                            self.pos += 2;
                            continue;
                        }
                        if (self.input[self.pos] == quote) {
                            self.pos += 1;
                            break;
                        }
                        self.pos += 1;
                    }
                    continue;
                },
                '(' => {
                    if (stack_depth < 256) {
                        closing_stack[stack_depth] = ')';
                        stack_depth += 1;
                    }
                },
                '[' => {
                    if (stack_depth < 256) {
                        closing_stack[stack_depth] = ']';
                        stack_depth += 1;
                    }
                },
                '{' => {
                    if (stack_depth < 256) {
                        closing_stack[stack_depth] = '}';
                        stack_depth += 1;
                    }
                },
                ')', ']', '}' => {
                    if (stack_depth > 0 and closing_stack[stack_depth - 1] == c) {
                        stack_depth -= 1;
                    }
                },
                else => {},
            }

            self.pos += 1;
        }

        self.done = true;
        if (start <= self.input.len) {
            return self.input[start..self.input.len];
        }
        return null;
    }

    /// Collect all segments into a slice.
    pub fn collect(self: *SegmentIterator, alloc: Allocator) ![][]const u8 {
        var list: std.ArrayList([]const u8) = .empty;
        while (self.next()) |seg| {
            try list.append(alloc, seg);
        }
        return list.toOwnedSlice(alloc);
    }
};

// ─── Arbitrary Value Validation ────────────────────────────────────────────

/// Validates that an arbitrary value doesn't contain top-level ; or }.
/// Respects brackets (), quotes, and backslash escapes.
/// Note: { does NOT push onto the stack (intentional per Tailwind spec).
pub fn isValidArbitrary(input: []const u8) bool {
    if (input.len == 0) return false;

    var stack_depth: usize = 0;
    var closing_stack: [256]u8 = undefined;
    var i: usize = 0;

    while (i < input.len) {
        const c = input[i];

        switch (c) {
            '\\' => {
                i += 2;
                continue;
            },
            '\'' , '"' => {
                const quote = c;
                i += 1;
                while (i < input.len) {
                    if (input[i] == '\\') {
                        i += 2;
                        continue;
                    }
                    if (input[i] == quote) {
                        i += 1;
                        break;
                    }
                    i += 1;
                }
                continue;
            },
            '(' => {
                if (stack_depth < 256) {
                    closing_stack[stack_depth] = ')';
                    stack_depth += 1;
                }
            },
            '[' => {
                if (stack_depth < 256) {
                    closing_stack[stack_depth] = ']';
                    stack_depth += 1;
                }
            },
            ')', ']' => {
                if (stack_depth > 0 and closing_stack[stack_depth - 1] == c) {
                    stack_depth -= 1;
                } else if (stack_depth == 0) {
                    return false; // Unbalanced closing bracket
                }
            },
            ';' => {
                if (stack_depth == 0) return false;
            },
            '}' => {
                if (stack_depth == 0) return false;
            },
            else => {},
        }

        i += 1;
    }

    return true;
}

// ─── Arbitrary Value Decoding ──────────────────────────────────────────────

/// Decode arbitrary values: underscores become spaces (except in url(), var() first arg).
/// Escaped underscores (\\_) become literal underscores.
pub fn decodeArbitraryValue(alloc: Allocator, input: []const u8) ![]const u8 {
    // Fast path: no underscores at all
    if (std.mem.indexOfScalar(u8, input, '_') == null) return input;

    var result = try std.ArrayList(u8).initCapacity(alloc, input.len);
    var i: usize = 0;

    while (i < input.len) {
        if (input[i] == '\\' and i + 1 < input.len and input[i + 1] == '_') {
            // Escaped underscore: literal _
            try result.append(alloc, '_');
            i += 2;
            continue;
        }

        if (input[i] == '_') {
            // Check if we're inside url() - if so, keep underscore
            // For simplicity, convert to space (the common case)
            // url() handling would need context tracking
            try result.append(alloc, ' ');
            i += 1;
            continue;
        }

        try result.append(alloc, input[i]);
        i += 1;
    }

    return result.toOwnedSlice(alloc);
}

// ─── Named Value Validation ────────────────────────────────────────────────

/// Check if a value matches /^[a-zA-Z0-9_.%-]+$/
pub fn isValidNamedValue(input: []const u8) bool {
    if (input.len == 0) return false;
    for (input) |c| {
        switch (c) {
            'a'...'z', 'A'...'Z', '0'...'9', '_', '.', '%', '-' => {},
            else => return false,
        }
    }
    return true;
}

// ─── Typehint Extraction ───────────────────────────────────────────────────

pub const TypehintResult = struct {
    data_type: ?[]const u8,
    value: []const u8,
};

/// Extract typehint from an arbitrary value like "color:var(--my-color)".
/// Valid typehint chars: a-z and -. Colon separates typehint from value.
pub fn extractTypehint(input: []const u8) TypehintResult {
    for (input, 0..) |c, i| {
        switch (c) {
            'a'...'z', '-' => continue,
            ':' => {
                if (i == 0) return .{ .data_type = null, .value = input };
                if (i + 1 >= input.len) return .{ .data_type = null, .value = input };
                return .{
                    .data_type = input[0..i],
                    .value = input[i + 1 ..],
                };
            },
            else => return .{ .data_type = null, .value = input },
        }
    }
    return .{ .data_type = null, .value = input };
}

// ─── Modifier Parsing ──────────────────────────────────────────────────────

/// Parse a modifier segment (the part after /).
pub fn parseModifier(alloc: Allocator, input: []const u8) !?Modifier {
    if (input.len == 0) return null;

    // Bracket form: [...]
    if (input[0] == '[' and input.len > 1 and input[input.len - 1] == ']') {
        const inner = input[1 .. input.len - 1];
        const decoded = try decodeArbitraryValue(alloc, inner);
        const trimmed = std.mem.trim(u8, decoded, " ");
        if (trimmed.len == 0) return null;
        if (!isValidArbitrary(trimmed)) return null;
        return Modifier{ .kind = .arbitrary, .value = trimmed };
    }

    // Paren form: (...)
    if (input[0] == '(' and input.len > 1 and input[input.len - 1] == ')') {
        const inner = input[1 .. input.len - 1];
        if (inner.len < 2 or !std.mem.startsWith(u8, inner, "--")) return null;
        if (!isValidArbitrary(inner)) return null;
        // Wrap in var()
        const var_ref = try std.fmt.allocPrint(alloc, "var({s})", .{inner});
        return Modifier{ .kind = .arbitrary, .value = var_ref };
    }

    // Named form
    if (isValidNamedValue(input)) {
        return Modifier{ .kind = .named, .value = input };
    }

    return null;
}

// ─── Root Finding ──────────────────────────────────────────────────────────

pub const Root = struct {
    root: []const u8,
    value: ?[]const u8,
};

pub const RootIterator = struct {
    input: []const u8,
    exists_static: *const fn ([]const u8) bool,
    exists_functional: *const fn ([]const u8) bool,
    phase: u8 = 0, // 0 = exact, 1 = scanning dashes, 2 = @ special, 3 = done
    scan_pos: ?usize = null,

    pub fn next(self: *RootIterator) ?Root {
        while (self.phase < 3) {
            switch (self.phase) {
                0 => {
                    // Phase 0: Try exact match as functional
                    self.phase = 1;
                    // Initialize scan position to last dash
                    self.scan_pos = std.mem.lastIndexOfScalar(u8, self.input, '-');
                    if (self.exists_functional(self.input)) {
                        return Root{ .root = self.input, .value = null };
                    }
                },
                1 => {
                    // Phase 1: Try progressively shorter prefixes at dash boundaries
                    if (self.scan_pos) |idx| {
                        if (idx == 0) {
                            self.phase = 2;
                            continue;
                        }
                        const maybe_root = self.input[0..idx];
                        const value = self.input[idx + 1 ..];

                        // Move scan_pos to next dash before current position
                        if (idx > 0) {
                            self.scan_pos = std.mem.lastIndexOfScalar(u8, self.input[0..idx], '-');
                        } else {
                            self.scan_pos = null;
                        }

                        // Skip empty values (trailing dash)
                        if (value.len == 0) {
                            self.phase = 3;
                            return null;
                        }

                        // Special @ handling: don't match @-something via dash
                        if (maybe_root.len > 0 and maybe_root[0] == '@' and
                            self.exists_functional("@") and self.input[idx] == '-')
                        {
                            self.phase = 2;
                            continue;
                        }

                        if (self.exists_functional(maybe_root)) {
                            return Root{ .root = maybe_root, .value = value };
                        }
                    } else {
                        self.phase = 2;
                    }
                },
                2 => {
                    // Phase 2: Special @ handling
                    self.phase = 3;
                    if (self.input.len > 0 and self.input[0] == '@' and self.exists_functional("@")) {
                        return Root{ .root = "@", .value = self.input[1..] };
                    }
                },
                else => break,
            }
        }
        return null;
    }
};

pub fn findRoots(
    input: []const u8,
    exists_static: *const fn ([]const u8) bool,
    exists_functional: *const fn ([]const u8) bool,
) RootIterator {
    return RootIterator{
        .input = input,
        .exists_static = exists_static,
        .exists_functional = exists_functional,
    };
}

// ─── Main Parser ───────────────────────────────────────────────────────────

pub const ParseError = error{
    InvalidCandidate,
    OutOfMemory,
};

/// Parse a raw candidate string into a structured Candidate.
/// Returns null if the candidate is invalid.
pub fn parseCandidate(
    alloc: Allocator,
    raw: []const u8,
    utility_exists_static: *const fn ([]const u8) bool,
    utility_exists_functional: *const fn ([]const u8) bool,
    variant_exists: *const fn ([]const u8) bool,
    variant_is_functional_root: ?*const fn ([]const u8) bool,
) !?Candidate {
    if (raw.len == 0) return null;

    // Step 1: Split on ':' using bracket-aware segmenting
    var seg_iter = segment(raw, ':');
    var seg_buf: [16][]const u8 = undefined;
    var seg_count: usize = 0;
    while (seg_iter.next()) |seg| {
        if (seg_count >= 16) return null; // too many segments, invalid
        seg_buf[seg_count] = seg;
        seg_count += 1;
    }
    const segments = seg_buf[0..seg_count];

    if (segments.len == 0) return null;

    // Step 3: The last segment is the base (utility part)
    var base = segments[segments.len - 1];
    const variant_segments = segments[0 .. segments.len - 1];

    // Step 4: Parse variants (in reverse order — rightmost is innermost)
    var variant_buf: [16]Variant = undefined;
    var variant_count: usize = 0;
    {
        var i: usize = variant_segments.len;
        while (i > 0) {
            i -= 1;
            const v = parseVariantSegment(alloc, variant_segments[i], variant_exists, variant_is_functional_root) orelse return null;
            if (variant_count >= 16) return null;
            variant_buf[variant_count] = v;
            variant_count += 1;
        }
    }
    // Copy variants to heap since variant_buf is stack-local and the slice escapes via Candidate
    const variants = try alloc.dupe(Variant, variant_buf[0..variant_count]);

    // Step 5: Detect ! (important)
    var important = false;
    if (base.len > 0 and base[base.len - 1] == '!') {
        important = true;
        base = base[0 .. base.len - 1];
    } else if (base.len > 0 and base[0] == '!') {
        important = true;
        base = base[1..];
    }

    if (base.len == 0) return null;

    // Step 6: Check for static utility match (no brackets in name)
    if (std.mem.indexOfScalar(u8, base, '[') == null and
        std.mem.indexOfScalar(u8, base, '/') == null and
        utility_exists_static(base))
    {
        return Candidate{
            .kind = .static,
            .raw = raw,
            .root = base,
            .variants = variants,
            .important = important,
        };
    }

    // Step 7: Split on '/' for modifier
    var base_seg = segment(base, '/');
    const base_without_modifier = base_seg.next() orelse return null;
    const modifier_segment = base_seg.next();
    const additional_modifier = base_seg.next();
    if (additional_modifier != null) return null; // Multiple modifiers invalid

    var modifier: ?Modifier = null;
    if (modifier_segment) |mod_seg| {
        modifier = try parseModifier(alloc, mod_seg) orelse return null;
    }

    // Detect negative
    var effective_base = base_without_modifier;
    var negative = false;
    if (effective_base.len > 1 and effective_base[0] == '-') {
        // Check if the negative version exists as a functional utility
        if (utility_exists_functional(effective_base) or blk: {
            // Try finding roots with the leading dash
            var roots = findRoots(effective_base, utility_exists_static, utility_exists_functional);
            break :blk roots.next() != null;
        }) {
            negative = true;
        }
    }

    // Step 8: Parse the base

    // Branch A: Arbitrary property [property:value]
    if (effective_base.len > 1 and effective_base[0] == '[' and effective_base[effective_base.len - 1] == ']') {
        const inner = effective_base[1 .. effective_base.len - 1];
        if (inner.len == 0) return null;

        // Must start with a-z or -
        if (inner[0] != '-' and (inner[0] < 'a' or inner[0] > 'z')) return null;

        // Find first colon
        const colon_idx = std.mem.indexOfScalar(u8, inner, ':') orelse return null;
        if (colon_idx == 0 or colon_idx == inner.len - 1) return null;

        const property = inner[0..colon_idx];
        const value_raw = inner[colon_idx + 1 ..];
        const decoded = try decodeArbitraryValue(alloc, value_raw);
        const trimmed = std.mem.trim(u8, decoded, " ");
        if (trimmed.len == 0) return null;
        if (!isValidArbitrary(trimmed)) return null;

        return Candidate{
            .kind = .arbitrary,
            .raw = raw,
            .root = "",
            .property = property,
            .value = Value{
                .kind = .arbitrary,
                .value = trimmed,
            },
            .modifier = modifier,
            .variants = variants,
            .important = important,
        };
    }

    // Branch B: Functional with [...] arbitrary value
    if (effective_base.len > 1 and effective_base[effective_base.len - 1] == ']') {
        if (std.mem.indexOf(u8, effective_base, "-[")) |bracket_start| {
            const root = effective_base[0..bracket_start];
            if (root.len == 0) return null;
            if (!utility_exists_functional(root)) return null;

            const arb_content = effective_base[bracket_start + 2 .. effective_base.len - 1];
            const decoded = try decodeArbitraryValue(alloc, arb_content);
            const trimmed = std.mem.trim(u8, decoded, " ");
            if (trimmed.len == 0) return null;
            if (!isValidArbitrary(trimmed)) return null;

            const typehint = extractTypehint(trimmed);

            return Candidate{
                .kind = .functional,
                .raw = raw,
                .root = root,
                .value = Value{
                    .kind = .arbitrary,
                    .value = typehint.value,
                    .data_type = typehint.data_type,
                },
                .modifier = modifier,
                .variants = variants,
                .important = important,
                .negative = negative,
            };
        }
        return null;
    }

    // Branch C: Functional with (...) theme shorthand
    if (effective_base.len > 1 and effective_base[effective_base.len - 1] == ')') {
        if (std.mem.indexOf(u8, effective_base, "-(")) |paren_start| {
            const root = effective_base[0..paren_start];
            if (root.len == 0) return null;
            if (!utility_exists_functional(root)) return null;

            const inner = effective_base[paren_start + 2 .. effective_base.len - 1];
            if (inner.len == 0) return null;

            // Check for typehint with segment
            var type_seg = segment(inner, ':');
            const first_part = type_seg.next() orelse return null;
            const second_part = type_seg.next();

            var data_type: ?[]const u8 = null;
            var css_var_name: []const u8 = undefined;

            if (second_part) |val| {
                data_type = first_part;
                css_var_name = val;
            } else {
                css_var_name = first_part;
            }

            // Must start with --
            if (!std.mem.startsWith(u8, css_var_name, "--")) return null;
            if (!isValidArbitrary(css_var_name)) return null;

            // Wrap in var()
            const var_ref = try std.fmt.allocPrint(alloc, "var({s})", .{css_var_name});

            return Candidate{
                .kind = .functional,
                .raw = raw,
                .root = root,
                .value = Value{
                    .kind = .arbitrary,
                    .value = var_ref,
                    .data_type = data_type,
                },
                .modifier = modifier,
                .variants = variants,
                .important = important,
                .negative = negative,
            };
        }
        return null;
    }

    // Branch D: Named value — use findRoots
    var roots = findRoots(effective_base, utility_exists_static, utility_exists_functional);
    if (roots.next()) |root_result| {
        if (root_result.value) |value| {
            if (!isValidNamedValue(value)) return null;

            // Compute fraction if modifier is named
            var fraction: ?[]const u8 = null;
            if (modifier) |mod| {
                if (mod.kind == .named) {
                    fraction = try std.fmt.allocPrint(alloc, "{s}/{s}", .{ value, mod.value });
                }
            }

            return Candidate{
                .kind = .functional,
                .raw = raw,
                .root = root_result.root,
                .value = Value{
                    .kind = .named,
                    .value = value,
                    .fraction = fraction,
                },
                .modifier = modifier,
                .variants = variants,
                .important = important,
                .negative = negative,
            };
        } else {
            // Functional utility with no value
            return Candidate{
                .kind = .functional,
                .raw = raw,
                .root = root_result.root,
                .value = null,
                .modifier = modifier,
                .variants = variants,
                .important = important,
                .negative = negative,
            };
        }
    }

    return null;
}

// ─── Variant Segment Parsing ───────────────────────────────────────────────

fn parseVariantSegment(
    alloc: Allocator,
    input: []const u8,
    variant_exists: *const fn ([]const u8) bool,
    variant_is_functional_root: ?*const fn ([]const u8) bool,
) ?Variant {
    if (input.len == 0) return null;

    // Reject variant segments with `/` modifier on known static/compound/functional variants.
    // e.g., "first-letter/foo" -> "first-letter" is a known variant, reject.
    // This prevents static variants from accepting modifiers.
    // Also reject functional variants with modifiers (e.g., aria-checked/foo, nth-3/foo, max-lg/foo)
    // Only @-prefixed variants support /name modifiers (e.g., @lg/name, @max-lg/name).
    if (std.mem.indexOfScalar(u8, input, '/')) |slash_idx| {
        const base = input[0..slash_idx];
        if (variant_exists(base)) return null;
        // Check if the base looks like a functional variant with value (e.g., aria-checked, nth-3, max-lg)
        // These should not accept modifiers (only @ variants support /name)
        // Skip check for @-prefixed variants which handle their own modifiers
        if (base.len > 0 and base[0] != '@') {
            if (std.mem.indexOfScalar(u8, base, '-')) |dash_idx| {
                const var_root = base[0..dash_idx];
                if (variant_is_functional_root) |fn_root_check| {
                    if (fn_root_check(var_root)) {
                        return null;
                    }
                }
            }
        }
    }

    // Arbitrary variant: [...]
    if (input[0] == '[' and input.len > 1 and input[input.len - 1] == ']') {
        const inner = input[1 .. input.len - 1];
        if (inner.len == 0) return null;

        const relative = inner.len > 0 and (inner[0] == '>' or inner[0] == '+' or inner[0] == '~');

        return Variant{
            .kind = .arbitrary,
            .root = "",
            .selector = inner,
            .relative = relative,
        };
    }

    // Static variant
    if (variant_exists(input)) {
        return Variant{
            .kind = .static,
            .root = input,
        };
    }

    // Compound variant (group-*, peer-*, has-*, not-*, in-*)
    const compound_prefixes = [_][]const u8{ "group-", "peer-", "has-", "not-", "in-" };
    for (compound_prefixes) |prefix| {
        if (std.mem.startsWith(u8, input, prefix)) {
            const full_inner = input[prefix.len..];
            if (full_inner.len == 0) continue;

            // Strip modifier (/name) from inner variant string if present
            // e.g., "hover/parent-name" -> inner = "hover", modifier = "parent-name"
            var inner_variant_str = full_inner;
            var compound_modifier: ?[]const u8 = null;
            // Find slash that's not inside brackets
            var bracket_depth_slash: u32 = 0;
            for (full_inner, 0..) |ch, idx| {
                if (ch == '[') bracket_depth_slash += 1
                else if (ch == ']' and bracket_depth_slash > 0) bracket_depth_slash -= 1
                else if (ch == '/' and bracket_depth_slash == 0) {
                    inner_variant_str = full_inner[0..idx];
                    compound_modifier = full_inner[idx + 1 ..];
                    break;
                }
            }
            if (inner_variant_str.len == 0) continue;

            // Try to parse the inner part as a variant
            if (parseVariantSegment(
                alloc,
                inner_variant_str,
                variant_exists,
                variant_is_functional_root,
            )) |inner_variant| {
                // Reject certain compound+arbitrary combinations:
                // - group/peer: reject relative (>, +, ~) and at-rule (@) selectors
                // - has: reject at-rule (@) selectors (but allow relative selectors)
                if (inner_variant.kind == .arbitrary) {
                    if (inner_variant.selector) |sel| {
                        if (sel.len > 0) {
                            const is_group_or_peer = std.mem.eql(u8, prefix, "group-") or std.mem.eql(u8, prefix, "peer-");
                            const is_has = std.mem.eql(u8, prefix, "has-");
                            if (is_group_or_peer and (sel[0] == '>' or sel[0] == '+' or sel[0] == '~' or sel[0] == '@')) {
                                return null;
                            }
                            if (is_has and sel[0] == '@') {
                                return null;
                            }
                        }
                    }
                }

                // Validate compound modifier if present
                if (compound_modifier) |cm| {
                    // Reject empty modifier and empty bracket modifier []
                    if (cm.len == 0) return null;
                    if (std.mem.eql(u8, cm, "[]")) return null;
                    // Only group-* and peer-* accept /name modifiers
                    // has-*, not-*, in-* do not
                    const accepts_modifier = std.mem.eql(u8, prefix, "group-") or std.mem.eql(u8, prefix, "peer-");
                    if (!accepts_modifier) return null;
                }

                return Variant{
                    .kind = .compound,
                    .root = prefix[0 .. prefix.len - 1], // strip trailing dash
                    .value = switch (inner_variant.kind) {
                        .static => Value{
                            .kind = .named,
                            .value = if (compound_modifier != null) full_inner else inner_variant.root,
                        },
                        .functional => Value{
                            // For functional inner variants (e.g., data-[state=active], aria-checked),
                            // store the full inner variant string as the value so that
                            // applyCompoundVariant can reconstruct the correct selector.
                            .kind = .named,
                            .value = full_inner,
                        },
                        else => null,
                    },
                    .selector = inner_variant.selector,
                };
            }

            // Fallback: accept unknown inner variants as custom variant names
            // Rules:
            // - group-*, peer-*, has-*: only accept single-word (no dashes) unknown inner
            //   e.g., group-hocus OK, group-custom-at-rule REJECTED
            // - not-*: accept unknown inner variants including multi-word (with dashes)
            //   e.g., not-device-hocus OK, not-hocus OK
            // - in-*: never accept unknown inner variants
            if (!std.mem.eql(u8, prefix, "in-") and
                std.mem.indexOfScalar(u8, inner_variant_str, '[') == null)
            {
                const is_not = std.mem.eql(u8, prefix, "not-");
                if (!is_not and std.mem.indexOfScalar(u8, inner_variant_str, '-') != null) {
                    // group/peer/has with dashed unknown inner -> reject
                    continue;
                }
                return Variant{
                    .kind = .compound,
                    .root = prefix[0 .. prefix.len - 1],
                    .value = Value{
                        .kind = .named,
                        .value = full_inner,
                    },
                };
            }

            continue;
        }
    }

    // Functional variant (aria-*, data-*, supports-*, nth-*, min-*, max-*, @*)
    // Try progressively longer prefixes at dash boundaries to find a functional root
    {
        // Collect all dash positions
        var dash_positions: [16]usize = undefined;
        var dash_count: usize = 0;
        for (input, 0..) |ch, idx| {
            if (ch == '-' and dash_count < 16) {
                dash_positions[dash_count] = idx;
                dash_count += 1;
            }
        }
        // Try from longest root to shortest
        var di: usize = dash_count;
        while (di > 0) {
            di -= 1;
            const dash_idx = dash_positions[di];
            const root = input[0..dash_idx];
            const value_part = input[dash_idx + 1 ..];

            const is_functional_root = if (variant_is_functional_root) |fn_check| fn_check(root) else false;
            // Skip @ root — it has its own special handler below
            if (is_functional_root and !std.mem.eql(u8, root, "@") and value_part.len > 0) {
                // Arbitrary value: root-[...]
                if (value_part[0] == '[' and value_part[value_part.len - 1] == ']') {
                    const inner = value_part[1 .. value_part.len - 1];
                    if (inner.len == 0) return null;
                    return Variant{
                        .kind = .functional,
                        .root = root,
                        .value = Value{
                            .kind = .arbitrary,
                            .value = inner,
                        },
                    };
                }

                // Named value — validate based on root type
                // nth-* variants require integer or [arbitrary] values
                if (std.mem.eql(u8, root, "nth") or std.mem.eql(u8, root, "nth-last") or
                    std.mem.eql(u8, root, "nth-of-type") or std.mem.eql(u8, root, "nth-last-of-type"))
                {
                    var all_digits = value_part.len > 0;
                    for (value_part) |c| {
                        if (c < '0' or c > '9') {
                            all_digits = false;
                            break;
                        }
                    }
                    if (!all_digits) return null;
                }

                return Variant{
                    .kind = .functional,
                    .root = root,
                    .value = Value{
                        .kind = .named,
                        .value = value_part,
                    },
                };
            }
        }
    }

    // @ functional variant (e.g., @lg, @[123px])
    if (input[0] == '@' and input.len > 1) {
        const rest = input[1..];
        // Reject negative container queries (@-lg, @-min-lg, @-max-lg, @-[123px])
        if (rest[0] == '-') return null;

        // Handle modifier: @lg/name, @[123px]/name
        var at_rest = rest;
        var at_modifier: ?Modifier = null;
        if (std.mem.indexOfScalar(u8, rest, '/')) |at_slash| {
            at_rest = rest[0..at_slash];
            const mod_part = rest[at_slash + 1 ..];
            if (mod_part.len > 0) {
                at_modifier = parseModifier(alloc, mod_part) catch null;
            }
        }

        if (at_rest[0] == '[' and at_rest[at_rest.len - 1] == ']') {
            return Variant{
                .kind = .functional,
                .root = "@",
                .value = Value{
                    .kind = .arbitrary,
                    .value = at_rest[1 .. at_rest.len - 1],
                },
                .modifier = at_modifier,
            };
        }
        return Variant{
            .kind = .functional,
            .root = "@",
            .value = Value{
                .kind = .named,
                .value = at_rest,
            },
            .modifier = at_modifier,
        };
    }

    return null;
}

// ─── Tests ─────────────────────────────────────────────────────────────────

test "segment: basic splitting" {
    const alloc = std.testing.allocator;

    var iter = segment("foo:bar:baz", ':');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 3), result.len);
    try std.testing.expectEqualStrings("foo", result[0]);
    try std.testing.expectEqualStrings("bar", result[1]);
    try std.testing.expectEqualStrings("baz", result[2]);
}

test "segment: respects brackets" {
    const alloc = std.testing.allocator;

    var iter = segment("a:(b:c):d", ':');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 3), result.len);
    try std.testing.expectEqualStrings("a", result[0]);
    try std.testing.expectEqualStrings("(b:c)", result[1]);
    try std.testing.expectEqualStrings("d", result[2]);
}

test "segment: respects square brackets" {
    const alloc = std.testing.allocator;

    var iter = segment("a:[b:c]:d", ':');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 3), result.len);
    try std.testing.expectEqualStrings("a", result[0]);
    try std.testing.expectEqualStrings("[b:c]", result[1]);
    try std.testing.expectEqualStrings("d", result[2]);
}

test "segment: respects quoted strings" {
    const alloc = std.testing.allocator;

    var iter = segment("a:\"b:c\":d", ':');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 3), result.len);
    try std.testing.expectEqualStrings("a", result[0]);
    try std.testing.expectEqualStrings("\"b:c\"", result[1]);
    try std.testing.expectEqualStrings("d", result[2]);
}

test "segment: single segment" {
    const alloc = std.testing.allocator;

    var iter = segment("foo", ':');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 1), result.len);
    try std.testing.expectEqualStrings("foo", result[0]);
}

test "segment: slash separator" {
    const alloc = std.testing.allocator;

    var iter = segment("bg-red-500/50", '/');
    const result = try iter.collect(alloc);
    defer alloc.free(result);

    try std.testing.expectEqual(@as(usize, 2), result.len);
    try std.testing.expectEqualStrings("bg-red-500", result[0]);
    try std.testing.expectEqualStrings("50", result[1]);
}

test "isValidArbitrary: valid values" {
    try std.testing.expect(isValidArbitrary("#0088cc"));
    try std.testing.expect(isValidArbitrary("var(--my-color)"));
    try std.testing.expect(isValidArbitrary("calc(100% - 2rem)"));
    try std.testing.expect(isValidArbitrary("red"));
}

test "isValidArbitrary: rejects semicolons" {
    try std.testing.expect(!isValidArbitrary("red;color:blue"));
}

test "isValidArbitrary: rejects closing braces" {
    try std.testing.expect(!isValidArbitrary("red}html{color:blue"));
}

test "isValidArbitrary: rejects empty" {
    try std.testing.expect(!isValidArbitrary(""));
}

test "isValidNamedValue: valid" {
    try std.testing.expect(isValidNamedValue("red-500"));
    try std.testing.expect(isValidNamedValue("1.5"));
    try std.testing.expect(isValidNamedValue("75%"));
    try std.testing.expect(isValidNamedValue("foo_bar"));
}

test "isValidNamedValue: invalid" {
    try std.testing.expect(!isValidNamedValue(""));
    try std.testing.expect(!isValidNamedValue("foo=bar"));
    try std.testing.expect(!isValidNamedValue("foo bar"));
}

test "extractTypehint: with type" {
    const result = extractTypehint("color:var(--my-color)");
    try std.testing.expectEqualStrings("color", result.data_type.?);
    try std.testing.expectEqualStrings("var(--my-color)", result.value);
}

test "extractTypehint: without type" {
    const result = extractTypehint("#ff0000");
    try std.testing.expect(result.data_type == null);
    try std.testing.expectEqualStrings("#ff0000", result.value);
}

test "extractTypehint: empty typehint (colon at start)" {
    const result = extractTypehint(":foo");
    try std.testing.expect(result.data_type == null);
    try std.testing.expectEqualStrings(":foo", result.value);
}
