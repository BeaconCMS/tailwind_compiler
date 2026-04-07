# Tailwind Compiler

A Tailwind CSS v4-compatible compiler written in Zig. Accepts a list of CSS class candidate strings and returns minified production CSS. Everything happens in memory — no filesystem scanning, no external processes, no CLI.

Designed as the CSS compilation engine for [Beacon CMS](https://github.com/BeaconCMS/beacon), callable from Elixir as a NIF via [Zigler](https://github.com/E-xyza/zigler).

## Performance

Benchmarked against the official Tailwind CLI v4.2.2 — 10 rounds, each with 100–150 freshly generated HTML pages and ~3,000 unique Tailwind classes (Apple M4):

| Metric | Zig Compiler | Tailwind CLI v4 | Difference |
|--------|-------------|-----------------|------------|
| Avg compile time | **1.48 ms** | 171 ms | **116x faster** |
| Range | 1.43 – 1.58 ms | 160 – 200 ms | |
| Peak memory | **4.4 MB** | 131 MB | **30x less** |

Zero output differences — every candidate produces byte-identical CSS to the official Tailwind CLI.

## Elixir Usage

Add to your `mix.exs`:

```elixir
def deps do
  [{:tailwind_compiler, github: "BeaconCMS/tailwind_compiler"}]
end
```

Then:

```elixir
TailwindCompiler.compile(["flex", "p-4", "hover:bg-blue-500/50", "sm:text-lg"])
#=> {:ok, ".flex{display:flex}.p-4{padding:calc(var(--spacing)*4)}..."}

# Without preflight (base CSS reset)
TailwindCompiler.compile(["flex", "hidden"], preflight: false)

# With theme overrides
TailwindCompiler.compile(["p-4"], theme: ~s({"spacing":"0.5rem"}))

# Bang variant (raises on error)
css = TailwindCompiler.compile!(["flex", "p-4"])
```

The NIF runs on a dirty CPU scheduler. For a typical site (~3,000 candidates), expect ~1.5ms latency.

## Zig Usage

```zig
const tailwind = @import("tailwind_compiler");

const candidates = [_][]const u8{ "flex", "p-4", "hover:bg-blue-500/50", "sm:text-lg" };
const css = try tailwind.compile(allocator, &candidates, null, false);
```

### Zig API

```zig
pub fn compile(
    alloc: std.mem.Allocator,
    candidates: []const []const u8,  // Tailwind class names
    theme_json: ?[]const u8,         // Optional JSON theme overrides
    include_preflight: bool,         // Include base CSS reset
) ![]const u8
```

## Building

Requires [Zig 0.15.2](https://ziglang.org/download/) and [Elixir 1.17+](https://elixir-lang.org/install.html).

```bash
# Elixir
mix deps.get
mix compile
mix test

# Zig standalone
zig build test
zig build run
zig build -Doptimize=ReleaseFast
```

## Feature Coverage

### Static Utilities (~350)
Display, position, visibility, isolation, box-sizing, float, clear, overflow, overscroll, object-fit, pointer-events, resize, user-select, touch-action, cursor, appearance, flex direction/wrap/grow/shrink, grid flow, justify/align/place content/items/self (including safe alignment), text alignment/decoration/transform/overflow/wrap, whitespace, word-break, hyphens, font style/variant/smoothing, list style, vertical-align, background attachment/clip/origin/repeat/size/position, border style/collapse, outline, mix/bg blend mode, table layout, caption side, transitions, will-change, contain, forced-color-adjust, sr-only, field-sizing, scroll behavior/snap, break-after/before/inside, box-decoration, content-visibility, color-scheme, font-stretch, transform-style, backface-visibility, and more.

### Functional Utilities (~85 roots)
- **Spacing**: `p-*`, `m-*`, `gap-*`, `inset-*`, `top/right/bottom/left-*`, `scroll-m*`, `scroll-p*`, `basis-*`
- **Sizing**: `w-*`, `h-*`, `min-w/h-*`, `max-w/h-*`, `size-*`
- **Colors**: `bg-*`, `text-*`, `border-*`, `accent-*`, `caret-*`, `fill-*`, `stroke-*`, `outline-color-*`, `decoration-*`, `shadow-color-*`, `divide-*`, `placeholder-*` — all with opacity modifier support (`bg-red-500/50` pre-resolved to `#hex`)
- **Typography**: `text-sm/lg/xl` (font-size + line-height), `font-sans/bold` (family + weight), `leading-*`, `tracking-*`, `font-weight-*`
- **Borders**: `border-*` (width + color), `border-x/y/s/e/t/r/b/l-*`, `rounded-*` (all corners), `divide-x/y-*`
- **Effects**: `shadow-*`, `inset-shadow-*`, `text-shadow-*`, `ring-*`, `inset-ring-*`, `ring-offset-*`, `opacity-*` — composable `box-shadow` system
- **Filters**: `blur-*`, `brightness-*`, `contrast-*`, `grayscale`, `hue-rotate-*`, `invert`, `saturate-*`, `sepia` + all `backdrop-*` — composable `filter`/`backdrop-filter`
- **Transforms**: `rotate-*`, `scale-*`, `translate-x/y-*`, `skew-x/y-*` — composable custom properties
- **Grid**: `cols-*`/`grid-cols-*`, `rows-*`/`grid-rows-*`, `col-span-*`, `col-start/end-*`, `row-span-*`, `row-start/end-*`, `auto-cols/rows-*`
- **Gradients**: `bg-linear-to-*`/`bg-gradient-to-*`, `bg-radial-*`, `bg-conic-*`, `from-*`, `via-*`, `to-*` — composable stops
- **Layout**: `aspect-*`, `columns-*`, `perspective-*`, `origin-*`, `container` (responsive max-widths)
- **Transitions**: `duration-*`, `delay-*`, `ease-*`, `animate-*`
- **Misc**: `z-*`, `order-*`, `line-clamp-*`, `content-*`, `list-*`, `outline-offset-*`, `underline-offset-*`, `grow-*`, `shrink-*`, `mask-image-*`, `border-spacing-*`

### Variants (77+)
- **Pseudo-classes**: `hover` (with `@media(hover:hover)`), `focus`, `focus-visible`, `focus-within`, `active`, `visited`, `target`, `first`, `last`, `only`, `odd`, `even`, `disabled`, `enabled`, `checked`, `required`, `valid`, `invalid`, `placeholder-shown`, `autofill`, `read-only`, `open`, `inert`, and more
- **Pseudo-elements**: `before`, `after` (with `content` injection), `marker`, `selection`, `placeholder`, `file`, `backdrop`, `first-letter`, `first-line`
- **Media**: `dark`, `print`, `motion-safe/reduce`, `contrast-more/less`, `portrait`, `landscape`, `forced-colors`, `inverted-colors`, `pointer-*`, `noscript`
- **Responsive**: `sm`, `md`, `lg`, `xl`, `2xl`, `max-*`, `min-*`
- **Container**: `@sm`, `@md`, `@lg`, `@xl`, `@min-*`, `@max-*`
- **Compound**: `group-*`, `peer-*`, `has-*`, `not-*`, `in-*` (including `group-aria-*`, `group-data-*`)
- **Functional**: `aria-*`, `data-*`, `supports-*`, `nth-*`, `nth-last-*`, `nth-of-type-*`, `nth-last-of-type-*`
- **Other**: `ltr`, `rtl`, `starting`, `*`, `**`, arbitrary `[&>svg]`

### Infrastructure
- Composable `@property` declarations for shadow, ring, translate, scale, gradient, filter, backdrop-filter, font-variant-numeric, border-spacing
- `@keyframes` for built-in animations (spin, ping, pulse, bounce)
- `@layer theme` with tree-shaken CSS variables (only emits what's used)
- `@layer base` with Tailwind v4 preflight
- CSS.escape() spec-compliant selector escaping
- Pre-computed oklch→sRGB color conversion (288-color lookup table from LightningCSS)
- Arena allocator — one bulk deallocation per compile call
- Arbitrary values: `bg-[#0088cc]`, `w-[calc(100%-2rem)]`, `[color:red]`
- Theme function shorthand: `bg-(--my-color)` → `var(--my-color)`
- Negative utilities: `-mt-4`, `-rotate-12`, `-translate-y-2`
- Important modifier: `flex!` → `!important`
- Fraction values: `w-1/2` → `50%`

## Benchmark

```bash
# Run 10-round benchmark (requires: npm i -g @tailwindcss/cli)
bash benchmark/run_benchmark.sh

# View results
open benchmark/results/report.html
```

Each round generates 100–150 fresh HTML pages with a unique random seed, extracts candidates, and times both compilers.

## Architecture

```
lib/
  tailwind_compiler.ex       Elixir public API
  tailwind_compiler/nif.ex   Zigler NIF wrapper (dirty CPU scheduler)

src/
  root.zig            Zig public API: compile()
  compiler.zig        Context, dedup, sort, container responsive, @property/@keyframes
  candidate.zig       Bracket-aware parser, findRoots, modifiers, arbitrary values
  utilities.zig       ~350 static + ~85 functional utility handlers
  variants.zig        77+ variant definitions, ordering, and application
  emitter.zig         CSS.escape(), minified output, @layer/@property/@keyframes
  color.zig           oklch→sRGB conversion, hex8 formatting, 288-color lookup
  theme.zig           JSON parsing, variable resolution, usage tracking
  default_theme.zig   Complete Tailwind v4 default theme (colors, spacing, etc.)

test/
  tailwind_compiler_test.exs   12 ExUnit tests

benchmark/
  run_benchmark.sh        10-round benchmark runner
  generate_pages.py       Parametric HTML page generator
  bench_zig.zig           Zig benchmark binary with μs-precision timing
  results/report.html     Interactive results dashboard
```

## License

MIT
