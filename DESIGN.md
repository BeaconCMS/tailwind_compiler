# TailwindCompiler — Zig NIF Design Document

## What This Is

A Tailwind CSS v4-compatible compiler written in Zig, callable from Elixir as a NIF via Zigler. It accepts a list of CSS class candidate strings and returns minified production CSS. Everything happens in memory — no filesystem, no external processes, no CLI binary.

```elixir
TailwindCompiler.compile(["flex", "p-4", "hover:bg-blue-500/50", "sm:text-lg"])
#=> {:ok, "@layer theme{:root{--color-blue-500:oklch(...)}}@layer utilities{.flex{display:flex}...}"}
```

## Why This Exists

Beacon CMS builds pages at runtime. It cannot pre-compile CSS at deploy time because content authors create pages dynamically. The previous approach shelled out to the Tailwind CLI binary — this caused:

- OOM kills on Fly.io (CLI + blocked requests exceeded 8GB)
- Hanging processes (Erlang ports can't signal EOF on stdin)
- Disk I/O in production (temp files, FIFOs)
- 30-second timeouts on first request while CSS compiled

This compiler eliminates all of that. CSS generation is a single NIF call on a dirty CPU scheduler, returning in <5ms for typical sites.

## Architecture

```
Elixir (BEAM)                              Zig (NIF, dirty CPU scheduler)
─────────────                              ────────────────────────────────

CandidateExtractor.extract(template)
  → MapSet of class candidates
  → deduplicate across all pages
  → MapSet.to_list()
        │
        ▼
TailwindCompiler.compile(candidates)  ──►  Arena allocator (one alloc, one free)
                                               │
                                           for each candidate:
                                               │
                                           1. Parse candidate string
                                              "hover:sm:bg-blue-500/50"
                                              → variants: [hover, sm]
                                              → root: bg
                                              → value: blue-500
                                              → modifier: 50
                                               │
                                           2. Look up utility
                                              → static: hash map (526 entries)
                                              → functional: 62 resolver functions
                                              → skip if unknown (no error)
                                               │
                                           3. Resolve value against theme
                                              → blue-500 → var(--color-blue-500)
                                              → 4 → calc(var(--spacing) * 4)
                                              → 1/2 → 50%
                                              → [#ff0000] → #ff0000
                                               │
                                           4. Apply variants
                                              → hover: selector + @media(hover:hover)
                                              → sm: @media(width>=40rem)
                                               │
                                           5. Emit minified CSS
                                              → already tight, no post-processing
                                               │
                                           arena.deinit() (all memory freed)
                            ◄──────────────────┘
                                           returns CSS binary to BEAM
```

## NIF Interface

### Elixir API

```elixir
TailwindCompiler.compile(candidates, opts \\ [])
```

**Arguments:**
- `candidates` — list of class name strings (`["flex", "p-4", "hover:bg-blue-500"]`)
- `opts` — keyword list:
  - `:theme` — JSON string with theme overrides (optional, default: nil = use defaults)
  - `:preflight` — include base CSS reset (optional, default: true)

**Returns:**
- `{:ok, css}` — minified CSS string
- `{:error, reason}` — error description

### NIF module

```elixir
defmodule TailwindCompiler.NIF do
  use Zig,
    otp_app: :tailwind_compiler,
    nifs: [compile: [:dirty_cpu]],
    leak_check: false

  # Zig function: compile(candidates, theme_json, preflight) -> []u8
end
```

The NIF runs on a dirty CPU scheduler. For 500 candidates, expected latency is <5ms. The arena allocator means zero individual frees — one bulk deallocation when the NIF returns.

### Error handling

The compiler skips candidates it can't parse rather than crashing:

```zig
for (candidates) |candidate| {
    ctx.process(candidate) catch continue;
}
```

This is essential because the Elixir candidate extractor is permissive — it may pass tokens that aren't valid Tailwind classes (e.g., SVG path fragments, HTML attribute values). The compiler ignores them.

## Current Implementation Status

### Source files (9,092 lines of Zig)

| File | Lines | Purpose |
|------|-------|---------|
| `utilities.zig` | 4,481 | Static + functional utility registry |
| `variants.zig` | 1,084 | Variant definitions + application |
| `candidate.zig` | 955 | Candidate string parser |
| `color.zig` | 552 | Color parsing + color-mix |
| `compiler.zig` | 547 | Core context, dedup, orchestration |
| `default_theme.zig` | 532 | Default Tailwind v4 theme values |
| `emitter.zig` | 468 | Minified CSS string builder |
| `theme.zig` | 274 | Theme data structure + JSON parser |
| `main.zig` | 164 | NIF entry point |
| `root.zig` | 35 | Module root |

### What's implemented

**Static utilities (526 entries):** display, position, visibility, overflow, float, clear, box-sizing, isolation, object-fit, flex direction/wrap, grid flow, justify, align, place, text alignment/decoration/transform/wrap, list style, border style, table layout, appearance, cursor (36 values), pointer-events, resize, scroll behavior, snap, touch action, user-select, will-change, sr-only, transitions, mix-blend, bg-blend, background properties, vertical-align, hyphens, break-before/after/inside, margin auto/0, padding 0, width/height keywords, shadow/opacity statics, filter statics, color-scheme, and more.

**Functional utilities (62 resolvers):**
- **Spacing:** p, px, py, ps, pe, pt, pr, pb, pl, m (all directions), gap, gap-x, gap-y, space-x, space-y, w, h, min-w, min-h, max-w, max-h, size, inset (all directions), top, right, bottom, left, basis, scroll-m (all), scroll-p (all), indent, border-spacing
- **Colors:** bg, text, border (all sides), ring, outline, accent, caret, fill, stroke, shadow color, divide color, decoration color, placeholder color
- **Typography:** text (size), font (family), font-weight, leading, tracking, decoration-thickness, underline-offset
- **Borders:** border (width, all sides), rounded (all corners), outline, outline-offset, ring, ring-offset, inset-ring, inset-shadow, divide
- **Effects:** shadow, opacity, drop-shadow, blur, brightness, contrast, saturate, grayscale, invert, sepia, hue-rotate, backdrop-blur, backdrop-brightness, backdrop-contrast, backdrop-saturate, backdrop-grayscale, backdrop-invert, backdrop-sepia, backdrop-opacity
- **Transforms:** rotate (all axes), scale (all axes), skew (x, y), translate (all axes), perspective, origin
- **Layout:** z-index, order, columns, grid-cols, grid-rows, grid-span, col-start, col-end, row-start, row-end, auto-cols, auto-rows, line-clamp, aspect
- **Transitions:** duration, delay, ease
- **Gradients:** bg-linear, bg-radial, bg-conic, from, via, to (gradient stops)
- **Other:** content, animate, list-style-type

**Variants (50+):**
- Pseudo-classes: hover, focus, focus-within, focus-visible, active, visited, target, enabled, disabled, checked, indeterminate, default, required, valid, invalid, placeholder-shown, autofill, read-only, empty, open, first, last, only, odd, even, first-of-type, last-of-type, only-of-type
- Pseudo-elements: before, after, placeholder, file, marker, selection, first-line, first-letter, backdrop, details-content
- Responsive: sm (40rem), md (48rem), lg (64rem), xl (80rem), 2xl (96rem)
- Preference: dark, print, motion-safe, motion-reduce, contrast-more, contrast-less, portrait, landscape, forced-colors
- Compound: group-*, peer-*, has-*, not-*, in-*
- Functional: aria-*, data-*, supports-*, min-*, max-*, @container variants
- Other: ltr, rtl, *, **

**Theme system:**
- Default Tailwind v4 theme (colors, spacing, breakpoints, fonts, etc.)
- JSON theme override support
- CSS custom property output (`var(--color-blue-500)`)
- Spacing multiplier (`calc(var(--spacing) * 4)`)
- Only used theme variables are emitted in `@layer theme`

**CSS output:**
- `@layer theme { :root { ... } }` — only referenced variables
- `@layer base { ... }` — Tailwind preflight (optional)
- `@layer utilities { ... }` — generated rules, sorted by variant order
- `@property` declarations for composable utilities (shadow, ring, translate)
- `@keyframes` for animate utilities
- Already minified (no whitespace, no trailing semicolons, no comments)

**Selector escaping:**
- `:` → `\:`
- `/` → `\/`
- `[` → `\[`
- `]` → `\]`
- `.` → `\.`
- `#` → `\#`
- `%` → `\%`
- `!` → `\!`

## What's Missing (Gap Analysis vs Tailwind v4)

### Critical gaps (cause visible broken styles)

**1. Custom theme colors**
DockYard's site uses `text-dy-red`, `bg-dy-blue`, etc. These are custom colors defined in their Tailwind config. The Zig compiler only knows the default Tailwind palette. Custom theme loading from the user's config is stubbed out (`load_theme_json` returns nil in Beacon).

**Fix:** The `tailwind_config` points to a JavaScript file. We need to either:
- Parse a subset of the JS config (extract color/spacing/font definitions)
- Define a JSON schema for Beacon theme config that users fill in instead of tailwind.config.js
- Accept a JSON theme file alongside or instead of the JS config

**2. Custom/plugin utilities**
Classes like `link-default--purple`, `cta:`, `grid-rows-blog` are custom utilities defined in the site's CSS or Tailwind plugins. The Zig compiler has no mechanism for user-defined utilities.

**Fix:** Accept additional static utility definitions as NIF input, or accept raw CSS to prepend/append to the output.

**3. Logical properties**
Tailwind v4 added logical property support: `inline`, `block`, `min-inline`, `max-block`, `inset-s`, `inset-e`, `mbs`, `mbe`, `pbs`, `pbe`. These are not implemented.

**Fix:** Add to spacing resolver — same pattern as physical properties but with logical CSS properties.

**4. Mask utilities**
Entirely missing: `mask-*`, `mask-clip-*`, `mask-origin-*`, `mask-mode-*`, `mask-type-*`, `mask-composite-*`.

**Fix:** ~20 static utilities + a few functional resolvers.

**5. Field sizing**
`field-sizing-content`, `field-sizing-fixed` — not implemented.

**Fix:** 2 static utilities.

**6. Missing static sizing keywords**
`svw`, `lvw`, `dvw`, `svh`, `lvh`, `dvh`, `lh` viewport/line-height units for w/h/min/max.

**Fix:** Add to sizing static values.

**7. `@starting-style` variant**
The `starting:` variant for CSS `@starting-style` — not implemented.

**Fix:** One new variant that wraps in `@starting-style { }`.

### Medium gaps (affect some layouts)

**8. Space between reverse**
`space-x-reverse`, `space-y-reverse` — not implemented. These use custom properties to reverse margin direction.

**9. Divide reverse**
`divide-x-reverse`, `divide-y-reverse` — same pattern as space reverse.

**10. Container queries**
`@sm:`, `@md:`, `@lg:` etc. — container query variants are partially implemented but may not cover all cases.

**11. Gradient positions**
`from-{percent}`, `via-{percent}`, `to-{percent}` — gradient stop positions. Currently only gradient stop colors are implemented.

**12. 3D transforms**
`translate-3d`, `scale-3d`, `rotate-x`, `rotate-y`, `rotate-z` — partially implemented.

**13. Touch action composition**
`touch-pan-x`, `touch-pan-y`, `touch-pinch-zoom` use custom properties for composition. Currently implemented as simple static values.

### Low priority gaps

**14. `columns` functional utility** — partially implemented
**15. `list-image` functional utility** — not implemented
**16. Scroll snap type composition** — uses `--tw-scroll-snap-strictness`
**17. `wrap-anywhere`, `wrap-break-word`, `wrap-normal`** — new in v4
**18. `caption-top`, `caption-bottom`** — table captions
**19. `inline-table`, `table-caption`** — uncommon display values

## Theme Architecture

### Current state

The default Tailwind v4 theme is compiled into `default_theme.zig` as `comptime` data. The theme struct supports:

```zig
const Theme = struct {
    colors: StringHashMap([]const u8),       // "red-500" → "oklch(63.7% 0.237 25.331)"
    spacing: ?[]const u8,                    // "0.25rem" (base multiplier)
    named_spacing: StringHashMap([]const u8), // "px" → "1px", "0.5" → "0.125rem"
    breakpoints: StringHashMap([]const u8),  // "sm" → "40rem"
    fonts: StringHashMap([]const u8),
    font_weights: StringHashMap([]const u8),
    // ... etc
};
```

### What's needed

Users configure themes via `@theme` in their CSS or `tailwind.config.js`. Beacon needs to extract these values and pass them as JSON to the NIF. The NIF already supports JSON theme parsing via `theme.parseJson()` — the gap is on the Beacon side (extracting theme values from the user's config).

**Proposed solution:**

Add a Beacon config option `theme_overrides` that accepts a JSON-compatible map:

```elixir
config :beacon, :my_site,
  theme: %{
    colors: %{
      "dy-red" => "#e74c3c",
      "dy-blue" => "#3498db"
    },
    spacing: "0.25rem",
    fonts: %{
      "heading" => "Cal Sans, sans-serif"
    }
  }
```

Beacon serializes this to JSON and passes it to the NIF. The NIF merges it with defaults.

## CSS Output Structure

```css
@property --tw-shadow{syntax:"*";inherits:false;initial-value:0 0 #0000}
@property --tw-shadow-color{syntax:"*";inherits:false}
@keyframes spin{to{transform:rotate(360deg)}}
@layer theme{:root{--color-red-500:oklch(63.7% 0.237 25.331);--spacing:0.25rem}}
@layer base{*,::after,::before{box-sizing:border-box;border:0 solid}...}
@layer utilities{
  .flex{display:flex}
  .p-4{padding:calc(var(--spacing)*4)}
  .bg-red-500{background-color:var(--color-red-500)}
  @media(hover:hover){.hover\:bg-blue-500:hover{background-color:var(--color-blue-500)}}
  @media(width>=40rem){.sm\:text-lg{font-size:var(--text-lg);line-height:var(--text-lg--line-height)}}
}
```

Only theme variables actually referenced by generated utilities are emitted in `@layer theme`. This is automatic — the theme tracks which keys were accessed during resolution.

## Testing Strategy

### Zig tests (run via `zig build test`)

Unit tests for each module:
- `candidate.zig` — parser tests for all input formats
- `utilities.zig` — lookup + resolver tests
- `variants.zig` — variant application tests
- `emitter.zig` — CSS output format tests
- `compiler.zig` — end-to-end integration tests

### Elixir tests (run via `mix test`)

12 tests covering:
- Basic compilation (static + functional utilities)
- Variant application (hover, dark, responsive)
- Deduplication
- Important flag
- Color utilities with opacity modifiers
- Spacing utilities (numeric, keyword, fraction)
- Arbitrary values
- Negative values
- Theme variable emission
- Preflight inclusion/exclusion
- Error resilience (bad input doesn't crash)

### Correctness validation (TODO)

Compare output against Tailwind v4 CLI for a large set of test candidates:
1. Generate candidates from a real site (DockYard's 2,800+ candidates)
2. Compile with both Tailwind CLI and this compiler
3. Parse both CSS outputs and diff rule-by-rule
4. Track coverage percentage

## Build & Distribution

### Development

```bash
# Run Zig tests
cd native/beacon_css  # or project root
zig build test

# Run Elixir tests
mix test

# Rebuild NIF after Zig changes
mix deps.compile tailwind_compiler --force
```

### Precompilation

Zigler supports precompiled NIFs. Targets:
- `aarch64-macos` (Apple Silicon dev)
- `x86_64-linux-gnu` (Fly.io, most CI)
- `aarch64-linux-gnu` (ARM servers)
- `x86_64-linux-musl` (Alpine Docker)

### Dependencies

- Zig 0.15.x (via Zigler, auto-installed)
- No C dependencies
- No system libraries
- No npm/Node.js

## Performance

| Operation | Time | Notes |
|-----------|------|-------|
| Parse 500 candidates | < 1ms | String splitting, hash map lookups |
| Resolve utilities | < 2ms | Theme resolution, string formatting |
| Apply variants | < 1ms | Selector/media query wrapping |
| Emit minified CSS | < 1ms | Single-pass string builder |
| **Total (500 candidates)** | **< 5ms** | Typical site |
| **Total (2,800 candidates)** | **< 15ms** | Large site (DockYard) |
| **Total (5,000 candidates)** | **< 30ms** | Very large site |

Arena allocator: one init, one deinit. No per-object frees. No GC.

## Integration with Beacon

Beacon extracts candidates from templates at publish time using a pure Elixir regex, stores them per-page in ETS, maintains a site-wide union, and only calls the NIF when new classes appear. The compiled CSS is cached in ETS (hot), S3 (warm/durable), and recompiled from scratch only when neither cache has it.

See the Beacon project's `DESIGN_ZIG_CSS_COMPILER.md` for the full integration architecture including the three-tier storage system and warming flow.

## Roadmap

### Phase 1: Core ✅
- Static utility registry (526 entries)
- Functional utility resolvers (62 handlers)
- Variant system (50+ variants)
- Candidate parser (full Tailwind grammar)
- Theme system with defaults
- Minified CSS emitter
- Zigler NIF integration
- Error resilience (skip bad candidates)

### Phase 2: Theme customization
- JSON theme override support (working in Zig, needs Beacon integration)
- Parse user's Tailwind config and extract theme values
- Custom color palettes
- Custom spacing scales
- Custom font stacks

### Phase 3: Full parity
- Logical properties (inline, block, mbs, mbe, pbs, pbe)
- Mask utilities
- Field sizing
- Container query variants
- 3D transforms
- Space/divide reverse
- Gradient stop positions
- All missing static sizing keywords

### Phase 4: Custom utilities
- Accept additional utility definitions from Beacon
- Support raw CSS passthrough (user stylesheets)
- Plugin-like extensibility

### Phase 5: Validation
- Side-by-side comparison with Tailwind CLI output
- Coverage percentage tracking
- Automated regression testing against real sites
