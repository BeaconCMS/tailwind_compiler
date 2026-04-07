const std = @import("std");
const Allocator = std.mem.Allocator;

/// Pre-computed sRGB hex values for all default theme oklch colors.
/// Generated from Tailwind CLI v4.2.2 output (LightningCSS conversion).
/// Used for exact parity with TW's color-mix pre-resolution.
const precomputed_hex = std.StaticStringMap([]const u8).initComptime(.{
    .{ "--color-amber-100", "fef3c6" },
    .{ "--color-amber-200", "fee685" },
    .{ "--color-amber-300", "ffd236" },
    .{ "--color-amber-400", "fcbb00" },
    .{ "--color-amber-50", "fffbeb" },
    .{ "--color-amber-500", "f99c00" },
    .{ "--color-amber-600", "dd7400" },
    .{ "--color-amber-700", "b75000" },
    .{ "--color-amber-800", "953d00" },
    .{ "--color-amber-900", "7b3306" },
    .{ "--color-amber-950", "461901" },
    .{ "--color-black", "000000" },
    .{ "--color-blue-100", "dbeafe" },
    .{ "--color-blue-200", "bedbff" },
    .{ "--color-blue-300", "90c5ff" },
    .{ "--color-blue-400", "54a2ff" },
    .{ "--color-blue-50", "eff6ff" },
    .{ "--color-blue-500", "3080ff" },
    .{ "--color-blue-600", "155dfc" },
    .{ "--color-blue-700", "1447e6" },
    .{ "--color-blue-800", "193cb8" },
    .{ "--color-blue-900", "1c398e" },
    .{ "--color-blue-950", "162456" },
    .{ "--color-cyan-100", "cefafe" },
    .{ "--color-cyan-200", "a2f4fd" },
    .{ "--color-cyan-300", "53eafd" },
    .{ "--color-cyan-400", "00d2ef" },
    .{ "--color-cyan-50", "ecfeff" },
    .{ "--color-cyan-500", "00b7d7" },
    .{ "--color-cyan-600", "0092b5" },
    .{ "--color-cyan-700", "007492" },
    .{ "--color-cyan-800", "005f78" },
    .{ "--color-cyan-900", "104e64" },
    .{ "--color-cyan-950", "053345" },
    .{ "--color-emerald-100", "d0fae5" },
    .{ "--color-emerald-200", "a4f4cf" },
    .{ "--color-emerald-300", "5ee9b5" },
    .{ "--color-emerald-400", "00d294" },
    .{ "--color-emerald-50", "ecfdf5" },
    .{ "--color-emerald-500", "00bb7f" },
    .{ "--color-emerald-600", "009767" },
    .{ "--color-emerald-700", "007956" },
    .{ "--color-emerald-800", "005f46" },
    .{ "--color-emerald-900", "004e3b" },
    .{ "--color-emerald-950", "002c22" },
    .{ "--color-fuchsia-100", "fae8ff" },
    .{ "--color-fuchsia-200", "f6cfff" },
    .{ "--color-fuchsia-300", "f2a9ff" },
    .{ "--color-fuchsia-400", "ec6cff" },
    .{ "--color-fuchsia-50", "fdf4ff" },
    .{ "--color-fuchsia-500", "e12afb" },
    .{ "--color-fuchsia-600", "c600db" },
    .{ "--color-fuchsia-700", "a600b5" },
    .{ "--color-fuchsia-800", "8a0194" },
    .{ "--color-fuchsia-900", "721378" },
    .{ "--color-fuchsia-950", "4b004f" },
    .{ "--color-gray-100", "f3f4f6" },
    .{ "--color-gray-200", "e5e7eb" },
    .{ "--color-gray-300", "d1d5dc" },
    .{ "--color-gray-400", "99a1af" },
    .{ "--color-gray-50", "f9fafb" },
    .{ "--color-gray-500", "6a7282" },
    .{ "--color-gray-600", "4a5565" },
    .{ "--color-gray-700", "364153" },
    .{ "--color-gray-800", "1e2939" },
    .{ "--color-gray-900", "101828" },
    .{ "--color-gray-950", "030712" },
    .{ "--color-green-100", "dcfce7" },
    .{ "--color-green-200", "b9f8cf" },
    .{ "--color-green-300", "7bf1a8" },
    .{ "--color-green-400", "05df72" },
    .{ "--color-green-50", "f0fdf4" },
    .{ "--color-green-500", "00c758" },
    .{ "--color-green-600", "00a544" },
    .{ "--color-green-700", "008138" },
    .{ "--color-green-800", "016630" },
    .{ "--color-green-900", "0d542b" },
    .{ "--color-green-950", "032e15" },
    .{ "--color-indigo-100", "e0e7ff" },
    .{ "--color-indigo-200", "c7d2ff" },
    .{ "--color-indigo-300", "a4b3ff" },
    .{ "--color-indigo-400", "7d87ff" },
    .{ "--color-indigo-50", "eef2ff" },
    .{ "--color-indigo-500", "625fff" },
    .{ "--color-indigo-600", "4f39f6" },
    .{ "--color-indigo-700", "432dd7" },
    .{ "--color-indigo-800", "372aac" },
    .{ "--color-indigo-900", "312c85" },
    .{ "--color-indigo-950", "1e1a4d" },
    .{ "--color-lime-100", "ecfcca" },
    .{ "--color-lime-200", "d8f999" },
    .{ "--color-lime-300", "bbf451" },
    .{ "--color-lime-400", "9de500" },
    .{ "--color-lime-50", "f7fee7" },
    .{ "--color-lime-500", "80cd00" },
    .{ "--color-lime-600", "62a400" },
    .{ "--color-lime-700", "4b7d00" },
    .{ "--color-lime-800", "3d6300" },
    .{ "--color-lime-900", "35530e" },
    .{ "--color-lime-950", "192e03" },
    .{ "--color-mauve-100", "f3f1f3" },
    .{ "--color-mauve-200", "e7e4e7" },
    .{ "--color-mauve-300", "d7d0d7" },
    .{ "--color-mauve-400", "a89ea9" },
    .{ "--color-mauve-50", "fafafa" },
    .{ "--color-mauve-500", "79697b" },
    .{ "--color-mauve-600", "594c5b" },
    .{ "--color-mauve-700", "463947" },
    .{ "--color-mauve-800", "2a212c" },
    .{ "--color-mauve-900", "1d161e" },
    .{ "--color-mauve-950", "0c090c" },
    .{ "--color-mist-100", "f1f3f3" },
    .{ "--color-mist-200", "e3e7e8" },
    .{ "--color-mist-300", "d0d6d8" },
    .{ "--color-mist-400", "9ca8ab" },
    .{ "--color-mist-50", "f9fbfb" },
    .{ "--color-mist-500", "67787c" },
    .{ "--color-mist-600", "4b585b" },
    .{ "--color-mist-700", "394447" },
    .{ "--color-mist-800", "22292b" },
    .{ "--color-mist-900", "161b1d" },
    .{ "--color-mist-950", "090b0c" },
    .{ "--color-neutral-100", "f5f5f5" },
    .{ "--color-neutral-200", "e5e5e5" },
    .{ "--color-neutral-300", "d4d4d4" },
    .{ "--color-neutral-400", "a1a1a1" },
    .{ "--color-neutral-50", "fafafa" },
    .{ "--color-neutral-500", "737373" },
    .{ "--color-neutral-600", "525252" },
    .{ "--color-neutral-700", "404040" },
    .{ "--color-neutral-800", "262626" },
    .{ "--color-neutral-900", "171717" },
    .{ "--color-neutral-950", "0a0a0a" },
    .{ "--color-olive-100", "f4f4f0" },
    .{ "--color-olive-200", "e8e8e3" },
    .{ "--color-olive-300", "d8d8d0" },
    .{ "--color-olive-400", "abab9c" },
    .{ "--color-olive-50", "fbfbf9" },
    .{ "--color-olive-500", "7c7c67" },
    .{ "--color-olive-600", "5b5b4b" },
    .{ "--color-olive-700", "474739" },
    .{ "--color-olive-800", "2b2b22" },
    .{ "--color-olive-900", "1d1d16" },
    .{ "--color-olive-950", "0c0c09" },
    .{ "--color-orange-100", "ffedd5" },
    .{ "--color-orange-200", "ffd7a8" },
    .{ "--color-orange-300", "ffb96d" },
    .{ "--color-orange-400", "ff8b1a" },
    .{ "--color-orange-50", "fff7ed" },
    .{ "--color-orange-500", "fe6e00" },
    .{ "--color-orange-600", "f05100" },
    .{ "--color-orange-700", "c53c00" },
    .{ "--color-orange-800", "9f2d00" },
    .{ "--color-orange-900", "7e2a0c" },
    .{ "--color-orange-950", "441306" },
    .{ "--color-pink-100", "fce7f3" },
    .{ "--color-pink-200", "fccee8" },
    .{ "--color-pink-300", "fda5d5" },
    .{ "--color-pink-400", "fb64b6" },
    .{ "--color-pink-50", "fdf2f8" },
    .{ "--color-pink-500", "f6339a" },
    .{ "--color-pink-600", "e30076" },
    .{ "--color-pink-700", "c4005c" },
    .{ "--color-pink-800", "a2004c" },
    .{ "--color-pink-900", "861043" },
    .{ "--color-pink-950", "510424" },
    .{ "--color-purple-100", "f3e8ff" },
    .{ "--color-purple-200", "e9d5ff" },
    .{ "--color-purple-300", "d9b3ff" },
    .{ "--color-purple-400", "c07eff" },
    .{ "--color-purple-50", "faf5ff" },
    .{ "--color-purple-500", "ac4bff" },
    .{ "--color-purple-600", "9810fa" },
    .{ "--color-purple-700", "8200da" },
    .{ "--color-purple-800", "6e11b0" },
    .{ "--color-purple-900", "59168b" },
    .{ "--color-purple-950", "3c0366" },
    .{ "--color-red-100", "ffe2e2" },
    .{ "--color-red-200", "ffcaca" },
    .{ "--color-red-300", "ffa3a3" },
    .{ "--color-red-400", "ff6568" },
    .{ "--color-red-50", "fef2f2" },
    .{ "--color-red-500", "fb2c36" },
    .{ "--color-red-600", "e40014" },
    .{ "--color-red-700", "bf000f" },
    .{ "--color-red-800", "9f0712" },
    .{ "--color-red-900", "82181a" },
    .{ "--color-red-950", "460809" },
    .{ "--color-rose-100", "ffe4e6" },
    .{ "--color-rose-200", "ffccd3" },
    .{ "--color-rose-300", "ffa2ae" },
    .{ "--color-rose-400", "ff667f" },
    .{ "--color-rose-50", "fff1f2" },
    .{ "--color-rose-500", "ff2357" },
    .{ "--color-rose-600", "e70044" },
    .{ "--color-rose-700", "c20039" },
    .{ "--color-rose-800", "a30037" },
    .{ "--color-rose-900", "8b0836" },
    .{ "--color-rose-950", "4d0218" },
    .{ "--color-sky-100", "dff2fe" },
    .{ "--color-sky-200", "b8e6fe" },
    .{ "--color-sky-300", "77d4ff" },
    .{ "--color-sky-400", "00bcfe" },
    .{ "--color-sky-50", "f0f9ff" },
    .{ "--color-sky-500", "00a5ef" },
    .{ "--color-sky-600", "0084cc" },
    .{ "--color-sky-700", "0069a4" },
    .{ "--color-sky-800", "005986" },
    .{ "--color-sky-900", "024a70" },
    .{ "--color-sky-950", "052f4a" },
    .{ "--color-slate-100", "f1f5f9" },
    .{ "--color-slate-200", "e2e8f0" },
    .{ "--color-slate-300", "cad5e2" },
    .{ "--color-slate-400", "90a1b9" },
    .{ "--color-slate-50", "f8fafc" },
    .{ "--color-slate-500", "62748e" },
    .{ "--color-slate-600", "45556c" },
    .{ "--color-slate-700", "314158" },
    .{ "--color-slate-800", "1d293d" },
    .{ "--color-slate-900", "0f172b" },
    .{ "--color-slate-950", "020618" },
    .{ "--color-stone-100", "f5f5f4" },
    .{ "--color-stone-200", "e7e5e4" },
    .{ "--color-stone-300", "d6d3d1" },
    .{ "--color-stone-400", "a6a09b" },
    .{ "--color-stone-50", "fafaf9" },
    .{ "--color-stone-500", "79716b" },
    .{ "--color-stone-600", "57534d" },
    .{ "--color-stone-700", "44403b" },
    .{ "--color-stone-800", "292524" },
    .{ "--color-stone-900", "1c1917" },
    .{ "--color-stone-950", "0c0a09" },
    .{ "--color-taupe-100", "f3f1f1" },
    .{ "--color-taupe-200", "e8e4e3" },
    .{ "--color-taupe-300", "d8d2d0" },
    .{ "--color-taupe-400", "aba09c" },
    .{ "--color-taupe-50", "fbfaf9" },
    .{ "--color-taupe-500", "7c6d67" },
    .{ "--color-taupe-600", "5b4f4b" },
    .{ "--color-taupe-700", "473c39" },
    .{ "--color-taupe-800", "2b2422" },
    .{ "--color-taupe-900", "1d1816" },
    .{ "--color-taupe-950", "0c0a09" },
    .{ "--color-teal-100", "cbfbf1" },
    .{ "--color-teal-200", "96f7e4" },
    .{ "--color-teal-300", "46ecd5" },
    .{ "--color-teal-400", "00d3bd" },
    .{ "--color-teal-50", "f0fdfa" },
    .{ "--color-teal-500", "00baa7" },
    .{ "--color-teal-600", "009588" },
    .{ "--color-teal-700", "00776e" },
    .{ "--color-teal-800", "005f5a" },
    .{ "--color-teal-900", "0b4f4a" },
    .{ "--color-teal-950", "022f2e" },
    .{ "--color-violet-100", "ede9fe" },
    .{ "--color-violet-200", "ddd6ff" },
    .{ "--color-violet-300", "c4b4ff" },
    .{ "--color-violet-400", "a685ff" },
    .{ "--color-violet-50", "f5f3ff" },
    .{ "--color-violet-500", "8d54ff" },
    .{ "--color-violet-600", "7f22fe" },
    .{ "--color-violet-700", "7008e7" },
    .{ "--color-violet-800", "5d0ec0" },
    .{ "--color-violet-900", "4d179a" },
    .{ "--color-violet-950", "2f0d68" },
    .{ "--color-white", "ffffff" },
    .{ "--color-yellow-100", "fef9c2" },
    .{ "--color-yellow-200", "fff085" },
    .{ "--color-yellow-300", "ffe02a" },
    .{ "--color-yellow-400", "fac800" },
    .{ "--color-yellow-50", "fefce8" },
    .{ "--color-yellow-500", "edb200" },
    .{ "--color-yellow-600", "cd8900" },
    .{ "--color-yellow-700", "a36100" },
    .{ "--color-yellow-800", "874b00" },
    .{ "--color-yellow-900", "733e0a" },
    .{ "--color-yellow-950", "432004" },
    .{ "--color-zinc-100", "f4f4f5" },
    .{ "--color-zinc-200", "e4e4e7" },
    .{ "--color-zinc-300", "d4d4d8" },
    .{ "--color-zinc-400", "9f9fa9" },
    .{ "--color-zinc-50", "fafafa" },
    .{ "--color-zinc-500", "71717b" },
    .{ "--color-zinc-600", "52525c" },
    .{ "--color-zinc-700", "3f3f46" },
    .{ "--color-zinc-800", "27272a" },
    .{ "--color-zinc-900", "18181b" },
    .{ "--color-zinc-950", "09090b" },
});

/// Convert an oklch() or hex color string with an alpha percentage
/// to a #RRGGBBAA hex8 string, doing the color-mix in oklab space.
///
/// Input: color = "oklch(62.3% 0.214 259.815)" or "#000" or "#fff"
///        alpha_percent = 50 (for /50)
/// Output: "#3080ff80"
pub fn resolveColorMix(alloc: Allocator, color_value: []const u8, alpha_percent: u8) ![]const u8 {
    return resolveColorMixWithKey(alloc, color_value, alpha_percent, null);
}

pub fn resolveColorMixWithKey(alloc: Allocator, color_value: []const u8, alpha_percent: u8, var_name: ?[]const u8) ![]const u8 {
    // First try the precomputed lookup for exact TW parity
    if (var_name) |key| {
        if (precomputed_hex.get(key)) |hex6| {
            const r = hexByte(hex6[0..2]);
            const g = hexByte(hex6[2..4]);
            const b_val = hexByte(hex6[4..6]);
            const alpha_f: f64 = @as(f64, @floatFromInt(alpha_percent)) / 100.0;
            const ab: u8 = @intFromFloat(@round(alpha_f * 255.0));
            return formatHex(alloc, r, g, b_val, ab);
        }
    }
    // Parse the color to sRGB
    var r: f64 = 0;
    var g: f64 = 0;
    var b: f64 = 0;

    if (std.mem.startsWith(u8, color_value, "oklch(")) {
        const parsed = parseOklch(color_value) orelse return fallbackColorMix(alloc, color_value, alpha_percent);
        const rgb = oklchToSrgb(parsed[0], parsed[1], parsed[2]);
        r = rgb[0];
        g = rgb[1];
        b = rgb[2];
    } else if (color_value[0] == '#') {
        const parsed = parseHex(color_value) orelse return fallbackColorMix(alloc, color_value, alpha_percent);
        r = parsed[0];
        g = parsed[1];
        b = parsed[2];
    } else {
        return fallbackColorMix(alloc, color_value, alpha_percent);
    }

    // Clamp to [0, 1]
    r = @max(0, @min(1, r));
    g = @max(0, @min(1, g));
    b = @max(0, @min(1, b));

    // Convert to hex bytes
    const rb: u8 = @intFromFloat(@round(r * 255.0));
    const gb: u8 = @intFromFloat(@round(g * 255.0));
    const bb: u8 = @intFromFloat(@round(b * 255.0));

    // Alpha: percentage of 255
    const alpha_f: f64 = @as(f64, @floatFromInt(alpha_percent)) / 100.0;
    const ab: u8 = @intFromFloat(@round(alpha_f * 255.0));

    return formatHex(alloc, rb, gb, bb, ab);
}

fn fallbackColorMix(alloc: Allocator, color_value: []const u8, alpha_percent: u8) ![]const u8 {
    return std.fmt.allocPrint(alloc, "color-mix(in oklab,{s} {d}%,transparent)", .{ color_value, alpha_percent });
}

/// Parse "oklch(L% C H)" where L is 0-100%, C is 0-0.4+, H is 0-360
fn parseOklch(s: []const u8) ?[3]f64 {
    // Strip "oklch(" and ")"
    if (!std.mem.startsWith(u8, s, "oklch(")) return null;
    if (s[s.len - 1] != ')') return null;
    const inner = std.mem.trim(u8, s[6 .. s.len - 1], " ");

    // Split on spaces
    var parts: [3][]const u8 = undefined;
    var count: usize = 0;
    var iter = std.mem.tokenizeAny(u8, inner, " ");
    while (iter.next()) |part| {
        if (count < 3) {
            parts[count] = part;
            count += 1;
        }
    }
    if (count != 3) return null;

    // Parse L (strip % if present)
    var l_str = parts[0];
    if (l_str.len > 0 and l_str[l_str.len - 1] == '%') {
        l_str = l_str[0 .. l_str.len - 1];
    }
    const l = std.fmt.parseFloat(f64, l_str) catch return null;
    const c = std.fmt.parseFloat(f64, parts[1]) catch return null;
    const h = std.fmt.parseFloat(f64, parts[2]) catch return null;

    // L is in percentage (0-100), convert to 0-1
    return .{ l / 100.0, c, h };
}

/// Parse hex color "#RGB", "#RRGGBB", "#RGBA", "#RRGGBBAA"
fn parseHex(s: []const u8) ?[3]f64 {
    if (s.len < 2 or s[0] != '#') return null;
    const hex = s[1..];

    if (hex.len == 3) {
        // #RGB -> expand to RRGGBB
        const r = hexDigit(hex[0]) orelse return null;
        const g = hexDigit(hex[1]) orelse return null;
        const b = hexDigit(hex[2]) orelse return null;
        return .{
            @as(f64, @floatFromInt(r * 17)) / 255.0,
            @as(f64, @floatFromInt(g * 17)) / 255.0,
            @as(f64, @floatFromInt(b * 17)) / 255.0,
        };
    }

    if (hex.len == 6 or hex.len == 8) {
        const r = (hexDigit(hex[0]) orelse return null) * 16 + (hexDigit(hex[1]) orelse return null);
        const g = (hexDigit(hex[2]) orelse return null) * 16 + (hexDigit(hex[3]) orelse return null);
        const b = (hexDigit(hex[4]) orelse return null) * 16 + (hexDigit(hex[5]) orelse return null);
        return .{
            @as(f64, @floatFromInt(r)) / 255.0,
            @as(f64, @floatFromInt(g)) / 255.0,
            @as(f64, @floatFromInt(b)) / 255.0,
        };
    }

    return null;
}

fn hexDigit(c: u8) ?u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => null,
    };
}

fn hexByte(s: []const u8) u8 {
    return (hexDigit(s[0]) orelse 0) * 16 + (hexDigit(s[1]) orelse 0);
}

/// Format RGBA as hex, using shorthand #RGBA when possible (each channel is a doubled digit).
fn formatHex(alloc: Allocator, r: u8, g: u8, b: u8, a: u8) ![]const u8 {
    // Check if shorthand is possible: each byte must be a doubled nibble (0x00, 0x11, 0x22, ..., 0xff)
    const can_short = (r >> 4 == (r & 0xf)) and (g >> 4 == (g & 0xf)) and
        (b >> 4 == (b & 0xf)) and (a >> 4 == (a & 0xf));
    if (can_short) {
        return std.fmt.allocPrint(alloc, "#{x}{x}{x}{x}", .{ r & 0xf, g & 0xf, b & 0xf, a & 0xf });
    }
    return std.fmt.allocPrint(alloc, "#{x:0>2}{x:0>2}{x:0>2}{x:0>2}", .{ r, g, b, a });
}

/// Convert oklch (L, C, h) to sRGB (r, g, b) where all values are 0-1.
/// L: lightness 0-1, C: chroma 0-~0.4, h: hue in degrees 0-360.
fn oklchToSrgb(l: f64, c: f64, h_deg: f64) [3]f64 {
    // oklch -> oklab
    const h_rad = h_deg * std.math.pi / 180.0;
    const a = c * @cos(h_rad);
    const b = c * @sin(h_rad);

    // oklab -> linear sRGB via LMS
    // Step 1: oklab -> LMS (cube root space)
    const l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    const m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    const s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    // Step 2: Undo cube root
    const l3 = l_ * l_ * l_;
    const m3 = m_ * m_ * m_;
    const s3 = s_ * s_ * s_;

    // Step 3: LMS -> linear sRGB
    const r_lin = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    const g_lin = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    const b_lin = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    // Step 4: Linear sRGB -> sRGB (gamma)
    return .{
        linearToSrgb(r_lin),
        linearToSrgb(g_lin),
        linearToSrgb(b_lin),
    };
}

fn linearToSrgb(x: f64) f64 {
    if (x <= 0.0031308) {
        return 12.92 * x;
    }
    return 1.055 * std.math.pow(f64, x, 1.0 / 2.4) - 0.055;
}

// ─── Tests ─────────────────────────────────────────────────────────────────

test "parseOklch: valid" {
    const result = parseOklch("oklch(62.3% 0.214 259.815)");
    try std.testing.expect(result != null);
    try std.testing.expectApproxEqAbs(result.?[0], 0.623, 0.001);
    try std.testing.expectApproxEqAbs(result.?[1], 0.214, 0.001);
    try std.testing.expectApproxEqAbs(result.?[2], 259.815, 0.001);
}

test "parseHex: #000" {
    const result = parseHex("#000");
    try std.testing.expect(result != null);
    try std.testing.expectApproxEqAbs(result.?[0], 0.0, 0.001);
    try std.testing.expectApproxEqAbs(result.?[1], 0.0, 0.001);
    try std.testing.expectApproxEqAbs(result.?[2], 0.0, 0.001);
}

test "parseHex: #fff" {
    const result = parseHex("#fff");
    try std.testing.expect(result != null);
    try std.testing.expectApproxEqAbs(result.?[0], 1.0, 0.001);
    try std.testing.expectApproxEqAbs(result.?[1], 1.0, 0.001);
    try std.testing.expectApproxEqAbs(result.?[2], 1.0, 0.001);
}

test "oklchToSrgb: black" {
    const rgb = oklchToSrgb(0, 0, 0);
    try std.testing.expectApproxEqAbs(rgb[0], 0.0, 0.01);
    try std.testing.expectApproxEqAbs(rgb[1], 0.0, 0.01);
    try std.testing.expectApproxEqAbs(rgb[2], 0.0, 0.01);
}

test "oklchToSrgb: white" {
    const rgb = oklchToSrgb(1, 0, 0);
    try std.testing.expectApproxEqAbs(rgb[0], 1.0, 0.01);
    try std.testing.expectApproxEqAbs(rgb[1], 1.0, 0.01);
    try std.testing.expectApproxEqAbs(rgb[2], 1.0, 0.01);
}

test "resolveColorMix: black at 50%" {
    const alloc = std.testing.allocator;
    const result = try resolveColorMix(alloc, "#000", 50);
    defer alloc.free(result);
    try std.testing.expectEqualStrings("#00000080", result);
}

test "resolveColorMix: white at 80%" {
    const alloc = std.testing.allocator;
    const result = try resolveColorMix(alloc, "#fff", 80);
    defer alloc.free(result);
    try std.testing.expectEqualStrings("#fffc", result);
}

test "resolveColorMix: blue-500 at 50%" {
    const alloc = std.testing.allocator;
    // oklch(62.3% 0.214 259.815) ≈ rgb(48, 128, 255) ≈ #3080ff
    const result = try resolveColorMix(alloc, "oklch(62.3% 0.214 259.815)", 50);
    defer alloc.free(result);
    // Should be #3080ff80 (approximately)
    // The exact value depends on the oklch->srgb conversion precision
    try std.testing.expect(result.len == 9); // #RRGGBBAA
    try std.testing.expect(result[0] == '#');
    // Alpha byte should be 0x80 (128)
    try std.testing.expectEqualStrings("80", result[7..9]);
}
