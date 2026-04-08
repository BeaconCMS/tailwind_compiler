/// Default Tailwind CSS v4 theme values.
/// All values from the canonical theme.css @theme block.

pub const ThemeEntry = struct {
    key: []const u8,
    value: []const u8,
};

// ─── Colors ────────────────────────────────────────────────────────────────

pub const colors = [_]ThemeEntry{
    // Black & White
    .{ .key = "--color-black", .value = "#000" },
    .{ .key = "--color-white", .value = "#fff" },
    // Red
    .{ .key = "--color-red-50", .value = "oklch(97.1% 0.013 17.38)" },
    .{ .key = "--color-red-100", .value = "oklch(93.6% 0.032 17.717)" },
    .{ .key = "--color-red-200", .value = "oklch(88.5% 0.062 18.334)" },
    .{ .key = "--color-red-300", .value = "oklch(80.8% 0.114 19.571)" },
    .{ .key = "--color-red-400", .value = "oklch(70.4% 0.191 22.216)" },
    .{ .key = "--color-red-500", .value = "oklch(63.7% 0.237 25.331)" },
    .{ .key = "--color-red-600", .value = "oklch(57.7% 0.245 27.325)" },
    .{ .key = "--color-red-700", .value = "oklch(50.5% 0.213 27.518)" },
    .{ .key = "--color-red-800", .value = "oklch(44.4% 0.177 26.899)" },
    .{ .key = "--color-red-900", .value = "oklch(39.6% 0.141 25.723)" },
    .{ .key = "--color-red-950", .value = "oklch(25.8% 0.092 26.042)" },
    // Orange
    .{ .key = "--color-orange-50", .value = "oklch(98% 0.016 73.684)" },
    .{ .key = "--color-orange-100", .value = "oklch(95.4% 0.038 75.164)" },
    .{ .key = "--color-orange-200", .value = "oklch(90.1% 0.076 70.697)" },
    .{ .key = "--color-orange-300", .value = "oklch(83.7% 0.128 66.29)" },
    .{ .key = "--color-orange-400", .value = "oklch(75% 0.183 55.934)" },
    .{ .key = "--color-orange-500", .value = "oklch(70.5% 0.213 47.604)" },
    .{ .key = "--color-orange-600", .value = "oklch(64.6% 0.222 41.116)" },
    .{ .key = "--color-orange-700", .value = "oklch(55.3% 0.195 38.402)" },
    .{ .key = "--color-orange-800", .value = "oklch(47% 0.157 37.304)" },
    .{ .key = "--color-orange-900", .value = "oklch(40.8% 0.123 38.172)" },
    .{ .key = "--color-orange-950", .value = "oklch(26.6% 0.079 36.259)" },
    // Amber
    .{ .key = "--color-amber-50", .value = "oklch(98.7% 0.022 95.277)" },
    .{ .key = "--color-amber-100", .value = "oklch(96.2% 0.059 95.617)" },
    .{ .key = "--color-amber-200", .value = "oklch(92.4% 0.12 95.746)" },
    .{ .key = "--color-amber-300", .value = "oklch(87.9% 0.169 91.605)" },
    .{ .key = "--color-amber-400", .value = "oklch(82.8% 0.189 84.429)" },
    .{ .key = "--color-amber-500", .value = "oklch(76.9% 0.188 70.08)" },
    .{ .key = "--color-amber-600", .value = "oklch(66.6% 0.179 58.318)" },
    .{ .key = "--color-amber-700", .value = "oklch(55.5% 0.163 48.998)" },
    .{ .key = "--color-amber-800", .value = "oklch(47.3% 0.137 46.201)" },
    .{ .key = "--color-amber-900", .value = "oklch(41.4% 0.112 45.904)" },
    .{ .key = "--color-amber-950", .value = "oklch(27.9% 0.077 45.635)" },
    // Yellow
    .{ .key = "--color-yellow-50", .value = "oklch(98.7% 0.026 102.212)" },
    .{ .key = "--color-yellow-100", .value = "oklch(97.3% 0.071 103.193)" },
    .{ .key = "--color-yellow-200", .value = "oklch(94.5% 0.129 101.54)" },
    .{ .key = "--color-yellow-300", .value = "oklch(90.5% 0.182 98.111)" },
    .{ .key = "--color-yellow-400", .value = "oklch(85.2% 0.199 91.936)" },
    .{ .key = "--color-yellow-500", .value = "oklch(79.5% 0.184 86.047)" },
    .{ .key = "--color-yellow-600", .value = "oklch(68.1% 0.162 75.834)" },
    .{ .key = "--color-yellow-700", .value = "oklch(55.4% 0.135 66.442)" },
    .{ .key = "--color-yellow-800", .value = "oklch(47.6% 0.114 61.907)" },
    .{ .key = "--color-yellow-900", .value = "oklch(42.1% 0.095 57.708)" },
    .{ .key = "--color-yellow-950", .value = "oklch(28.6% 0.066 53.813)" },
    // Lime
    .{ .key = "--color-lime-50", .value = "oklch(98.6% 0.031 120.757)" },
    .{ .key = "--color-lime-100", .value = "oklch(96.7% 0.067 122.328)" },
    .{ .key = "--color-lime-200", .value = "oklch(93.8% 0.127 124.321)" },
    .{ .key = "--color-lime-300", .value = "oklch(89.7% 0.196 126.665)" },
    .{ .key = "--color-lime-400", .value = "oklch(84.1% 0.238 128.85)" },
    .{ .key = "--color-lime-500", .value = "oklch(76.8% 0.233 130.85)" },
    .{ .key = "--color-lime-600", .value = "oklch(64.8% 0.2 131.684)" },
    .{ .key = "--color-lime-700", .value = "oklch(53.2% 0.157 131.589)" },
    .{ .key = "--color-lime-800", .value = "oklch(45.3% 0.124 130.933)" },
    .{ .key = "--color-lime-900", .value = "oklch(40.5% 0.101 131.063)" },
    .{ .key = "--color-lime-950", .value = "oklch(27.4% 0.072 132.109)" },
    // Green
    .{ .key = "--color-green-50", .value = "oklch(98.2% 0.018 155.826)" },
    .{ .key = "--color-green-100", .value = "oklch(96.2% 0.044 156.743)" },
    .{ .key = "--color-green-200", .value = "oklch(92.5% 0.084 155.995)" },
    .{ .key = "--color-green-300", .value = "oklch(87.1% 0.15 154.449)" },
    .{ .key = "--color-green-400", .value = "oklch(79.2% 0.209 151.711)" },
    .{ .key = "--color-green-500", .value = "oklch(72.3% 0.219 149.579)" },
    .{ .key = "--color-green-600", .value = "oklch(62.7% 0.194 149.214)" },
    .{ .key = "--color-green-700", .value = "oklch(52.7% 0.154 150.069)" },
    .{ .key = "--color-green-800", .value = "oklch(44.8% 0.119 151.328)" },
    .{ .key = "--color-green-900", .value = "oklch(39.3% 0.095 152.535)" },
    .{ .key = "--color-green-950", .value = "oklch(26.6% 0.065 152.934)" },
    // Emerald
    .{ .key = "--color-emerald-50", .value = "oklch(97.9% 0.021 166.113)" },
    .{ .key = "--color-emerald-100", .value = "oklch(95% 0.052 163.051)" },
    .{ .key = "--color-emerald-200", .value = "oklch(90.5% 0.093 164.15)" },
    .{ .key = "--color-emerald-300", .value = "oklch(84.5% 0.143 164.978)" },
    .{ .key = "--color-emerald-400", .value = "oklch(76.5% 0.177 163.223)" },
    .{ .key = "--color-emerald-500", .value = "oklch(69.6% 0.17 162.48)" },
    .{ .key = "--color-emerald-600", .value = "oklch(59.6% 0.145 163.225)" },
    .{ .key = "--color-emerald-700", .value = "oklch(50.8% 0.118 165.612)" },
    .{ .key = "--color-emerald-800", .value = "oklch(43.2% 0.095 166.913)" },
    .{ .key = "--color-emerald-900", .value = "oklch(37.8% 0.077 168.94)" },
    .{ .key = "--color-emerald-950", .value = "oklch(26.2% 0.051 172.552)" },
    // Teal
    .{ .key = "--color-teal-50", .value = "oklch(98.4% 0.014 180.72)" },
    .{ .key = "--color-teal-100", .value = "oklch(95.3% 0.051 180.801)" },
    .{ .key = "--color-teal-200", .value = "oklch(91% 0.096 180.426)" },
    .{ .key = "--color-teal-300", .value = "oklch(85.5% 0.138 181.071)" },
    .{ .key = "--color-teal-400", .value = "oklch(77.7% 0.152 181.912)" },
    .{ .key = "--color-teal-500", .value = "oklch(70.4% 0.14 182.503)" },
    .{ .key = "--color-teal-600", .value = "oklch(60% 0.118 184.704)" },
    .{ .key = "--color-teal-700", .value = "oklch(51.1% 0.096 186.391)" },
    .{ .key = "--color-teal-800", .value = "oklch(43.7% 0.078 188.216)" },
    .{ .key = "--color-teal-900", .value = "oklch(38.6% 0.063 188.416)" },
    .{ .key = "--color-teal-950", .value = "oklch(27.7% 0.046 192.524)" },
    // Cyan
    .{ .key = "--color-cyan-50", .value = "oklch(98.4% 0.019 200.873)" },
    .{ .key = "--color-cyan-100", .value = "oklch(95.6% 0.045 203.388)" },
    .{ .key = "--color-cyan-200", .value = "oklch(91.7% 0.08 205.041)" },
    .{ .key = "--color-cyan-300", .value = "oklch(86.5% 0.127 207.078)" },
    .{ .key = "--color-cyan-400", .value = "oklch(78.9% 0.154 211.53)" },
    .{ .key = "--color-cyan-500", .value = "oklch(71.5% 0.143 215.221)" },
    .{ .key = "--color-cyan-600", .value = "oklch(60.9% 0.126 221.723)" },
    .{ .key = "--color-cyan-700", .value = "oklch(52% 0.105 223.128)" },
    .{ .key = "--color-cyan-800", .value = "oklch(45% 0.085 224.283)" },
    .{ .key = "--color-cyan-900", .value = "oklch(39.8% 0.07 227.392)" },
    .{ .key = "--color-cyan-950", .value = "oklch(30.2% 0.056 229.695)" },
    // Sky
    .{ .key = "--color-sky-50", .value = "oklch(97.7% 0.013 236.62)" },
    .{ .key = "--color-sky-100", .value = "oklch(95.1% 0.026 236.824)" },
    .{ .key = "--color-sky-200", .value = "oklch(90.1% 0.058 230.902)" },
    .{ .key = "--color-sky-300", .value = "oklch(82.8% 0.111 230.318)" },
    .{ .key = "--color-sky-400", .value = "oklch(74.6% 0.16 232.661)" },
    .{ .key = "--color-sky-500", .value = "oklch(68.5% 0.169 237.323)" },
    .{ .key = "--color-sky-600", .value = "oklch(58.8% 0.158 241.966)" },
    .{ .key = "--color-sky-700", .value = "oklch(50% 0.134 242.749)" },
    .{ .key = "--color-sky-800", .value = "oklch(44.3% 0.11 240.79)" },
    .{ .key = "--color-sky-900", .value = "oklch(39.1% 0.09 240.876)" },
    .{ .key = "--color-sky-950", .value = "oklch(29.3% 0.066 243.157)" },
    // Blue
    .{ .key = "--color-blue-50", .value = "oklch(97% 0.014 254.604)" },
    .{ .key = "--color-blue-100", .value = "oklch(93.2% 0.032 255.585)" },
    .{ .key = "--color-blue-200", .value = "oklch(88.2% 0.059 254.128)" },
    .{ .key = "--color-blue-300", .value = "oklch(80.9% 0.105 251.813)" },
    .{ .key = "--color-blue-400", .value = "oklch(70.7% 0.165 254.624)" },
    .{ .key = "--color-blue-500", .value = "oklch(62.3% 0.214 259.815)" },
    .{ .key = "--color-blue-600", .value = "oklch(54.6% 0.245 262.881)" },
    .{ .key = "--color-blue-700", .value = "oklch(48.8% 0.243 264.376)" },
    .{ .key = "--color-blue-800", .value = "oklch(42.4% 0.199 265.638)" },
    .{ .key = "--color-blue-900", .value = "oklch(37.9% 0.146 265.522)" },
    .{ .key = "--color-blue-950", .value = "oklch(28.2% 0.091 267.935)" },
    // Indigo
    .{ .key = "--color-indigo-50", .value = "oklch(96.2% 0.018 272.314)" },
    .{ .key = "--color-indigo-100", .value = "oklch(93% 0.034 272.788)" },
    .{ .key = "--color-indigo-200", .value = "oklch(87% 0.065 274.039)" },
    .{ .key = "--color-indigo-300", .value = "oklch(78.5% 0.115 274.713)" },
    .{ .key = "--color-indigo-400", .value = "oklch(67.3% 0.182 276.935)" },
    .{ .key = "--color-indigo-500", .value = "oklch(58.5% 0.233 277.117)" },
    .{ .key = "--color-indigo-600", .value = "oklch(51.1% 0.262 276.966)" },
    .{ .key = "--color-indigo-700", .value = "oklch(45.7% 0.24 277.023)" },
    .{ .key = "--color-indigo-800", .value = "oklch(39.8% 0.195 277.366)" },
    .{ .key = "--color-indigo-900", .value = "oklch(35.9% 0.144 278.697)" },
    .{ .key = "--color-indigo-950", .value = "oklch(25.7% 0.09 281.288)" },
    // Violet
    .{ .key = "--color-violet-50", .value = "oklch(96.9% 0.016 293.756)" },
    .{ .key = "--color-violet-100", .value = "oklch(94.3% 0.029 294.588)" },
    .{ .key = "--color-violet-200", .value = "oklch(89.4% 0.057 293.283)" },
    .{ .key = "--color-violet-300", .value = "oklch(81.1% 0.111 293.571)" },
    .{ .key = "--color-violet-400", .value = "oklch(70.2% 0.183 293.541)" },
    .{ .key = "--color-violet-500", .value = "oklch(60.6% 0.25 292.717)" },
    .{ .key = "--color-violet-600", .value = "oklch(54.1% 0.281 293.009)" },
    .{ .key = "--color-violet-700", .value = "oklch(49.1% 0.27 292.581)" },
    .{ .key = "--color-violet-800", .value = "oklch(43.2% 0.232 292.759)" },
    .{ .key = "--color-violet-900", .value = "oklch(38% 0.189 293.745)" },
    .{ .key = "--color-violet-950", .value = "oklch(28.3% 0.141 291.089)" },
    // Purple
    .{ .key = "--color-purple-50", .value = "oklch(97.7% 0.014 308.299)" },
    .{ .key = "--color-purple-100", .value = "oklch(94.6% 0.033 307.174)" },
    .{ .key = "--color-purple-200", .value = "oklch(90.2% 0.063 306.703)" },
    .{ .key = "--color-purple-300", .value = "oklch(82.7% 0.119 306.383)" },
    .{ .key = "--color-purple-400", .value = "oklch(71.4% 0.203 305.504)" },
    .{ .key = "--color-purple-500", .value = "oklch(62.7% 0.265 303.9)" },
    .{ .key = "--color-purple-600", .value = "oklch(55.8% 0.288 302.321)" },
    .{ .key = "--color-purple-700", .value = "oklch(49.6% 0.265 301.924)" },
    .{ .key = "--color-purple-800", .value = "oklch(43.8% 0.218 303.724)" },
    .{ .key = "--color-purple-900", .value = "oklch(38.1% 0.176 304.987)" },
    .{ .key = "--color-purple-950", .value = "oklch(29.1% 0.149 302.717)" },
    // Fuchsia
    .{ .key = "--color-fuchsia-50", .value = "oklch(97.7% 0.017 320.058)" },
    .{ .key = "--color-fuchsia-100", .value = "oklch(95.2% 0.037 318.852)" },
    .{ .key = "--color-fuchsia-200", .value = "oklch(90.3% 0.076 319.62)" },
    .{ .key = "--color-fuchsia-300", .value = "oklch(83.3% 0.145 321.434)" },
    .{ .key = "--color-fuchsia-400", .value = "oklch(74% 0.238 322.16)" },
    .{ .key = "--color-fuchsia-500", .value = "oklch(66.7% 0.295 322.15)" },
    .{ .key = "--color-fuchsia-600", .value = "oklch(59.1% 0.293 322.896)" },
    .{ .key = "--color-fuchsia-700", .value = "oklch(51.8% 0.253 323.949)" },
    .{ .key = "--color-fuchsia-800", .value = "oklch(45.2% 0.211 324.591)" },
    .{ .key = "--color-fuchsia-900", .value = "oklch(40.1% 0.17 325.612)" },
    .{ .key = "--color-fuchsia-950", .value = "oklch(29.3% 0.136 325.661)" },
    // Pink
    .{ .key = "--color-pink-50", .value = "oklch(97.1% 0.014 343.198)" },
    .{ .key = "--color-pink-100", .value = "oklch(94.8% 0.028 342.258)" },
    .{ .key = "--color-pink-200", .value = "oklch(89.9% 0.061 343.231)" },
    .{ .key = "--color-pink-300", .value = "oklch(82.3% 0.12 346.018)" },
    .{ .key = "--color-pink-400", .value = "oklch(71.8% 0.202 349.761)" },
    .{ .key = "--color-pink-500", .value = "oklch(65.6% 0.241 354.308)" },
    .{ .key = "--color-pink-600", .value = "oklch(59.2% 0.249 0.584)" },
    .{ .key = "--color-pink-700", .value = "oklch(52.5% 0.223 3.958)" },
    .{ .key = "--color-pink-800", .value = "oklch(45.9% 0.187 3.815)" },
    .{ .key = "--color-pink-900", .value = "oklch(40.8% 0.153 2.432)" },
    .{ .key = "--color-pink-950", .value = "oklch(28.4% 0.109 3.907)" },
    // Rose
    .{ .key = "--color-rose-50", .value = "oklch(96.9% 0.015 12.422)" },
    .{ .key = "--color-rose-100", .value = "oklch(94.1% 0.03 12.58)" },
    .{ .key = "--color-rose-200", .value = "oklch(89.2% 0.058 10.001)" },
    .{ .key = "--color-rose-300", .value = "oklch(81% 0.117 11.638)" },
    .{ .key = "--color-rose-400", .value = "oklch(71.2% 0.194 13.428)" },
    .{ .key = "--color-rose-500", .value = "oklch(64.5% 0.246 16.439)" },
    .{ .key = "--color-rose-600", .value = "oklch(58.6% 0.253 17.585)" },
    .{ .key = "--color-rose-700", .value = "oklch(51.4% 0.222 16.935)" },
    .{ .key = "--color-rose-800", .value = "oklch(45.5% 0.188 13.697)" },
    .{ .key = "--color-rose-900", .value = "oklch(41% 0.159 10.272)" },
    .{ .key = "--color-rose-950", .value = "oklch(27.1% 0.105 12.094)" },
    // Slate
    .{ .key = "--color-slate-50", .value = "oklch(98.4% 0.003 247.858)" },
    .{ .key = "--color-slate-100", .value = "oklch(96.8% 0.007 247.896)" },
    .{ .key = "--color-slate-200", .value = "oklch(92.9% 0.013 255.508)" },
    .{ .key = "--color-slate-300", .value = "oklch(86.9% 0.022 252.894)" },
    .{ .key = "--color-slate-400", .value = "oklch(70.4% 0.04 256.788)" },
    .{ .key = "--color-slate-500", .value = "oklch(55.4% 0.046 257.417)" },
    .{ .key = "--color-slate-600", .value = "oklch(44.6% 0.043 257.281)" },
    .{ .key = "--color-slate-700", .value = "oklch(37.2% 0.044 257.287)" },
    .{ .key = "--color-slate-800", .value = "oklch(27.9% 0.041 260.031)" },
    .{ .key = "--color-slate-900", .value = "oklch(20.8% 0.042 265.755)" },
    .{ .key = "--color-slate-950", .value = "oklch(12.9% 0.042 264.695)" },
    // Gray
    .{ .key = "--color-gray-50", .value = "oklch(98.5% 0.002 247.839)" },
    .{ .key = "--color-gray-100", .value = "oklch(96.7% 0.003 264.542)" },
    .{ .key = "--color-gray-200", .value = "oklch(92.8% 0.006 264.531)" },
    .{ .key = "--color-gray-300", .value = "oklch(87.2% 0.01 258.338)" },
    .{ .key = "--color-gray-400", .value = "oklch(70.7% 0.022 261.325)" },
    .{ .key = "--color-gray-500", .value = "oklch(55.1% 0.027 264.364)" },
    .{ .key = "--color-gray-600", .value = "oklch(44.6% 0.03 256.802)" },
    .{ .key = "--color-gray-700", .value = "oklch(37.3% 0.034 259.733)" },
    .{ .key = "--color-gray-800", .value = "oklch(27.8% 0.033 256.848)" },
    .{ .key = "--color-gray-900", .value = "oklch(21% 0.034 264.665)" },
    .{ .key = "--color-gray-950", .value = "oklch(13% 0.028 261.692)" },
    // Zinc
    .{ .key = "--color-zinc-50", .value = "oklch(98.5% 0 0)" },
    .{ .key = "--color-zinc-100", .value = "oklch(96.7% 0.001 286.375)" },
    .{ .key = "--color-zinc-200", .value = "oklch(92% 0.004 286.32)" },
    .{ .key = "--color-zinc-300", .value = "oklch(87.1% 0.006 286.286)" },
    .{ .key = "--color-zinc-400", .value = "oklch(70.5% 0.015 286.067)" },
    .{ .key = "--color-zinc-500", .value = "oklch(55.2% 0.016 285.938)" },
    .{ .key = "--color-zinc-600", .value = "oklch(44.2% 0.017 285.786)" },
    .{ .key = "--color-zinc-700", .value = "oklch(37% 0.013 285.805)" },
    .{ .key = "--color-zinc-800", .value = "oklch(27.4% 0.006 286.033)" },
    .{ .key = "--color-zinc-900", .value = "oklch(21% 0.006 285.885)" },
    .{ .key = "--color-zinc-950", .value = "oklch(14.1% 0.005 285.823)" },
    // Neutral
    .{ .key = "--color-neutral-50", .value = "oklch(98.5% 0 0)" },
    .{ .key = "--color-neutral-100", .value = "oklch(97% 0 0)" },
    .{ .key = "--color-neutral-200", .value = "oklch(92.2% 0 0)" },
    .{ .key = "--color-neutral-300", .value = "oklch(87% 0 0)" },
    .{ .key = "--color-neutral-400", .value = "oklch(70.8% 0 0)" },
    .{ .key = "--color-neutral-500", .value = "oklch(55.6% 0 0)" },
    .{ .key = "--color-neutral-600", .value = "oklch(43.9% 0 0)" },
    .{ .key = "--color-neutral-700", .value = "oklch(37.1% 0 0)" },
    .{ .key = "--color-neutral-800", .value = "oklch(26.9% 0 0)" },
    .{ .key = "--color-neutral-900", .value = "oklch(20.5% 0 0)" },
    .{ .key = "--color-neutral-950", .value = "oklch(14.5% 0 0)" },
    // Stone
    .{ .key = "--color-stone-50", .value = "oklch(98.5% 0.001 106.423)" },
    .{ .key = "--color-stone-100", .value = "oklch(97% 0.001 106.424)" },
    .{ .key = "--color-stone-200", .value = "oklch(92.3% 0.003 48.717)" },
    .{ .key = "--color-stone-300", .value = "oklch(86.9% 0.005 56.366)" },
    .{ .key = "--color-stone-400", .value = "oklch(70.9% 0.01 56.259)" },
    .{ .key = "--color-stone-500", .value = "oklch(55.3% 0.013 58.071)" },
    .{ .key = "--color-stone-600", .value = "oklch(44.4% 0.011 73.639)" },
    .{ .key = "--color-stone-700", .value = "oklch(37.4% 0.01 67.558)" },
    .{ .key = "--color-stone-800", .value = "oklch(26.8% 0.007 34.298)" },
    .{ .key = "--color-stone-900", .value = "oklch(21.6% 0.006 56.043)" },
    .{ .key = "--color-stone-950", .value = "oklch(14.7% 0.004 49.25)" },
    // Mauve
    .{ .key = "--color-mauve-50", .value = "oklch(98.5% 0 0)" },
    .{ .key = "--color-mauve-100", .value = "oklch(96% 0.003 325.6)" },
    .{ .key = "--color-mauve-200", .value = "oklch(92.2% 0.005 325.62)" },
    .{ .key = "--color-mauve-300", .value = "oklch(86.5% 0.012 325.68)" },
    .{ .key = "--color-mauve-400", .value = "oklch(71.1% 0.019 323.02)" },
    .{ .key = "--color-mauve-500", .value = "oklch(54.2% 0.034 322.5)" },
    .{ .key = "--color-mauve-600", .value = "oklch(43.5% 0.029 321.78)" },
    .{ .key = "--color-mauve-700", .value = "oklch(36.4% 0.029 323.89)" },
    .{ .key = "--color-mauve-800", .value = "oklch(26.3% 0.024 320.12)" },
    .{ .key = "--color-mauve-900", .value = "oklch(21.2% 0.019 322.12)" },
    .{ .key = "--color-mauve-950", .value = "oklch(14.5% 0.008 326)" },
    // Olive
    .{ .key = "--color-olive-50", .value = "oklch(98.8% 0.003 106.5)" },
    .{ .key = "--color-olive-100", .value = "oklch(96.6% 0.005 106.5)" },
    .{ .key = "--color-olive-200", .value = "oklch(93% 0.007 106.5)" },
    .{ .key = "--color-olive-300", .value = "oklch(88% 0.011 106.6)" },
    .{ .key = "--color-olive-400", .value = "oklch(73.7% 0.021 106.9)" },
    .{ .key = "--color-olive-500", .value = "oklch(58% 0.031 107.3)" },
    .{ .key = "--color-olive-600", .value = "oklch(46.6% 0.025 107.3)" },
    .{ .key = "--color-olive-700", .value = "oklch(39.4% 0.023 107.4)" },
    .{ .key = "--color-olive-800", .value = "oklch(28.6% 0.016 107.4)" },
    .{ .key = "--color-olive-900", .value = "oklch(22.8% 0.013 107.4)" },
    .{ .key = "--color-olive-950", .value = "oklch(15.3% 0.006 107.1)" },
    // Mist
    .{ .key = "--color-mist-50", .value = "oklch(98.7% 0.002 197.1)" },
    .{ .key = "--color-mist-100", .value = "oklch(96.3% 0.002 197.1)" },
    .{ .key = "--color-mist-200", .value = "oklch(92.5% 0.005 214.3)" },
    .{ .key = "--color-mist-300", .value = "oklch(87.2% 0.007 219.6)" },
    .{ .key = "--color-mist-400", .value = "oklch(72.3% 0.014 214.4)" },
    .{ .key = "--color-mist-500", .value = "oklch(56% 0.021 213.5)" },
    .{ .key = "--color-mist-600", .value = "oklch(45% 0.017 213.2)" },
    .{ .key = "--color-mist-700", .value = "oklch(37.8% 0.015 216)" },
    .{ .key = "--color-mist-800", .value = "oklch(27.5% 0.011 216.9)" },
    .{ .key = "--color-mist-900", .value = "oklch(21.8% 0.008 223.9)" },
    .{ .key = "--color-mist-950", .value = "oklch(14.8% 0.004 228.8)" },
    // Taupe
    .{ .key = "--color-taupe-50", .value = "oklch(98.6% 0.002 67.8)" },
    .{ .key = "--color-taupe-100", .value = "oklch(96% 0.002 17.2)" },
    .{ .key = "--color-taupe-200", .value = "oklch(92.2% 0.005 34.3)" },
    .{ .key = "--color-taupe-300", .value = "oklch(86.8% 0.007 39.5)" },
    .{ .key = "--color-taupe-400", .value = "oklch(71.4% 0.014 41.2)" },
    .{ .key = "--color-taupe-500", .value = "oklch(54.7% 0.021 43.1)" },
    .{ .key = "--color-taupe-600", .value = "oklch(43.8% 0.017 39.3)" },
    .{ .key = "--color-taupe-700", .value = "oklch(36.7% 0.016 35.7)" },
    .{ .key = "--color-taupe-800", .value = "oklch(26.8% 0.011 36.5)" },
    .{ .key = "--color-taupe-900", .value = "oklch(21.4% 0.009 43.1)" },
    .{ .key = "--color-taupe-950", .value = "oklch(14.7% 0.004 49.3)" },
};

// ─── Breakpoints ───────────────────────────────────────────────────────────

pub const breakpoints = [_]ThemeEntry{
    .{ .key = "sm", .value = "40rem" },
    .{ .key = "md", .value = "48rem" },
    .{ .key = "lg", .value = "64rem" },
    .{ .key = "xl", .value = "80rem" },
    .{ .key = "2xl", .value = "96rem" },
};

// ─── Container Sizes ───────────────────────────────────────────────────────

pub const container_sizes = [_]ThemeEntry{
    .{ .key = "3xs", .value = "16rem" },
    .{ .key = "2xs", .value = "18rem" },
    .{ .key = "xs", .value = "20rem" },
    .{ .key = "sm", .value = "24rem" },
    .{ .key = "md", .value = "28rem" },
    .{ .key = "lg", .value = "32rem" },
    .{ .key = "xl", .value = "36rem" },
    .{ .key = "2xl", .value = "42rem" },
    .{ .key = "3xl", .value = "48rem" },
    .{ .key = "4xl", .value = "56rem" },
    .{ .key = "5xl", .value = "64rem" },
    .{ .key = "6xl", .value = "72rem" },
    .{ .key = "7xl", .value = "80rem" },
};

// ─── Font Families ─────────────────────────────────────────────────────────

pub const font_families = [_]ThemeEntry{
    .{ .key = "--font-sans", .value = "ui-sans-serif, system-ui, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'" },
    .{ .key = "--font-serif", .value = "ui-serif, Georgia, Cambria, 'Times New Roman', Times, serif" },
    .{ .key = "--font-mono", .value = "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace" },
};

// ─── Font Sizes ────────────────────────────────────────────────────────────

pub const font_sizes = [_]ThemeEntry{
    .{ .key = "--text-xs", .value = "0.75rem" },
    .{ .key = "--text-xs--line-height", .value = "1rem" },
    .{ .key = "--text-sm", .value = "0.875rem" },
    .{ .key = "--text-sm--line-height", .value = "1.25rem" },
    .{ .key = "--text-base", .value = "1rem" },
    .{ .key = "--text-base--line-height", .value = "1.5rem" },
    .{ .key = "--text-lg", .value = "1.125rem" },
    .{ .key = "--text-lg--line-height", .value = "1.75rem" },
    .{ .key = "--text-xl", .value = "1.25rem" },
    .{ .key = "--text-xl--line-height", .value = "1.75rem" },
    .{ .key = "--text-2xl", .value = "1.5rem" },
    .{ .key = "--text-2xl--line-height", .value = "2rem" },
    .{ .key = "--text-3xl", .value = "1.875rem" },
    .{ .key = "--text-3xl--line-height", .value = "2.25rem" },
    .{ .key = "--text-4xl", .value = "2.25rem" },
    .{ .key = "--text-4xl--line-height", .value = "2.5rem" },
    .{ .key = "--text-5xl", .value = "3rem" },
    .{ .key = "--text-5xl--line-height", .value = "1" },
    .{ .key = "--text-6xl", .value = "3.75rem" },
    .{ .key = "--text-6xl--line-height", .value = "1" },
    .{ .key = "--text-7xl", .value = "4.5rem" },
    .{ .key = "--text-7xl--line-height", .value = "1" },
    .{ .key = "--text-8xl", .value = "6rem" },
    .{ .key = "--text-8xl--line-height", .value = "1" },
    .{ .key = "--text-9xl", .value = "8rem" },
    .{ .key = "--text-9xl--line-height", .value = "1" },
};

// ─── Font Weights ──────────────────────────────────────────────────────────

pub const font_weights = [_]ThemeEntry{
    .{ .key = "--font-weight-thin", .value = "100" },
    .{ .key = "--font-weight-extralight", .value = "200" },
    .{ .key = "--font-weight-light", .value = "300" },
    .{ .key = "--font-weight-normal", .value = "400" },
    .{ .key = "--font-weight-medium", .value = "500" },
    .{ .key = "--font-weight-semibold", .value = "600" },
    .{ .key = "--font-weight-bold", .value = "700" },
    .{ .key = "--font-weight-extrabold", .value = "800" },
    .{ .key = "--font-weight-black", .value = "900" },
};

// ─── Letter Spacing ────────────────────────────────────────────────────────

pub const letter_spacings = [_]ThemeEntry{
    .{ .key = "--tracking-tighter", .value = "-0.05em" },
    .{ .key = "--tracking-tight", .value = "-0.025em" },
    .{ .key = "--tracking-normal", .value = "0em" },
    .{ .key = "--tracking-wide", .value = "0.025em" },
    .{ .key = "--tracking-wider", .value = "0.05em" },
    .{ .key = "--tracking-widest", .value = "0.1em" },
};

// ─── Line Heights ──────────────────────────────────────────────────────────

pub const line_heights = [_]ThemeEntry{
    .{ .key = "--leading-tight", .value = "1.25" },
    .{ .key = "--leading-snug", .value = "1.375" },
    .{ .key = "--leading-normal", .value = "1.5" },
    .{ .key = "--leading-relaxed", .value = "1.625" },
    .{ .key = "--leading-loose", .value = "2" },
};

// ─── Border Radius ─────────────────────────────────────────────────────────

pub const border_radii = [_]ThemeEntry{
    .{ .key = "--radius-xs", .value = "0.125rem" },
    .{ .key = "--radius-sm", .value = "0.25rem" },
    .{ .key = "--radius-md", .value = "0.375rem" },
    .{ .key = "--radius-lg", .value = "0.5rem" },
    .{ .key = "--radius-xl", .value = "0.75rem" },
    .{ .key = "--radius-2xl", .value = "1rem" },
    .{ .key = "--radius-3xl", .value = "1.5rem" },
    .{ .key = "--radius-4xl", .value = "2rem" },
};

// ─── Shadows ───────────────────────────────────────────────────────────────

pub const shadows = [_]ThemeEntry{
    .{ .key = "--shadow-2xs", .value = "0 1px rgb(0 0 0 / 0.05)" },
    .{ .key = "--shadow-xs", .value = "0 1px 2px 0 rgb(0 0 0 / 0.05)" },
    .{ .key = "--shadow-sm", .value = "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)" },
    .{ .key = "--shadow-md", .value = "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)" },
    .{ .key = "--shadow-lg", .value = "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)" },
    .{ .key = "--shadow-xl", .value = "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)" },
    .{ .key = "--shadow-2xl", .value = "0 25px 50px -12px rgb(0 0 0 / 0.25)" },
};

pub const inset_shadows = [_]ThemeEntry{
    .{ .key = "--inset-shadow-2xs", .value = "inset 0 1px rgb(0 0 0 / 0.05)" },
    .{ .key = "--inset-shadow-xs", .value = "inset 0 1px 1px rgb(0 0 0 / 0.05)" },
    .{ .key = "--inset-shadow-sm", .value = "inset 0 2px 4px rgb(0 0 0 / 0.05)" },
};

pub const drop_shadows = [_]ThemeEntry{
    .{ .key = "--drop-shadow", .value = "0 1px 2px rgb(0 0 0 / 0.1), 0 1px 1px rgb(0 0 0 / 0.06)" },
    .{ .key = "--drop-shadow-xs", .value = "0 1px 1px rgb(0 0 0 / 0.05)" },
    .{ .key = "--drop-shadow-sm", .value = "0 1px 2px rgb(0 0 0 / 0.15)" },
    .{ .key = "--drop-shadow-md", .value = "0 3px 3px rgb(0 0 0 / 0.12)" },
    .{ .key = "--drop-shadow-lg", .value = "0 4px 4px rgb(0 0 0 / 0.15)" },
    .{ .key = "--drop-shadow-xl", .value = "0 9px 7px rgb(0 0 0 / 0.1)" },
    .{ .key = "--drop-shadow-2xl", .value = "0 25px 25px rgb(0 0 0 / 0.15)" },
};

// ─── Blur ──────────────────────────────────────────────────────────────────

pub const blurs = [_]ThemeEntry{
    .{ .key = "--blur-xs", .value = "4px" },
    .{ .key = "--blur-sm", .value = "8px" },
    .{ .key = "--blur-md", .value = "12px" },
    .{ .key = "--blur-lg", .value = "16px" },
    .{ .key = "--blur-xl", .value = "24px" },
    .{ .key = "--blur-2xl", .value = "40px" },
    .{ .key = "--blur-3xl", .value = "64px" },
};

// ─── Easings ───────────────────────────────────────────────────────────────

pub const easings = [_]ThemeEntry{
    .{ .key = "--ease-in", .value = "cubic-bezier(0.4, 0, 1, 1)" },
    .{ .key = "--ease-out", .value = "cubic-bezier(0, 0, 0.2, 1)" },
    .{ .key = "--ease-in-out", .value = "cubic-bezier(0.4, 0, 0.2, 1)" },
};

// ─── Animations ────────────────────────────────────────────────────────────

pub const animations = [_]ThemeEntry{
    .{ .key = "--animate-spin", .value = "spin 1s linear infinite" },
    .{ .key = "--animate-ping", .value = "ping 1s cubic-bezier(0, 0, 0.2, 1) infinite" },
    .{ .key = "--animate-pulse", .value = "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite" },
    .{ .key = "--animate-bounce", .value = "bounce 1s infinite" },
};

// ─── Perspective ───────────────────────────────────────────────────────────

pub const perspectives = [_]ThemeEntry{
    .{ .key = "--perspective-dramatic", .value = "100px" },
    .{ .key = "--perspective-near", .value = "300px" },
    .{ .key = "--perspective-normal", .value = "500px" },
    .{ .key = "--perspective-midrange", .value = "800px" },
    .{ .key = "--perspective-distant", .value = "1200px" },
};

// ─── Aspect Ratios ────────────────────────────────────────────────────────

pub const aspect_ratios = [_]ThemeEntry{
    .{ .key = "--aspect-video", .value = "16 / 9" },
};

// ─── Text Shadows ─────────────────────────────────────────────────────────

pub const text_shadows = [_]ThemeEntry{
    .{ .key = "--text-shadow-2xs", .value = "0px 1px 0px rgb(0 0 0 / 0.15)" },
    .{ .key = "--text-shadow-xs", .value = "0px 1px 1px rgb(0 0 0 / 0.2)" },
    .{ .key = "--text-shadow-sm", .value = "0px 1px 0px rgb(0 0 0 / 0.075), 0px 1px 1px rgb(0 0 0 / 0.075), 0px 2px 2px rgb(0 0 0 / 0.075)" },
    .{ .key = "--text-shadow-md", .value = "0px 1px 1px rgb(0 0 0 / 0.1), 0px 1px 2px rgb(0 0 0 / 0.1), 0px 2px 4px rgb(0 0 0 / 0.1)" },
    .{ .key = "--text-shadow-lg", .value = "0px 1px 2px rgb(0 0 0 / 0.1), 0px 3px 2px rgb(0 0 0 / 0.1), 0px 4px 8px rgb(0 0 0 / 0.1)" },
};

// ─── Defaults ─────────────────────────────────────────────────────────────

pub const defaults = [_]ThemeEntry{
    .{ .key = "--default-transition-duration", .value = "150ms" },
    .{ .key = "--default-transition-timing-function", .value = "cubic-bezier(0.4, 0, 0.2, 1)" },
};
