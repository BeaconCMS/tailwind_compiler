# Beacon CSS Compiler — Zig NIF Design Document

## Overview

A Tailwind v4-compatible CSS compiler written in Zig, callable from Elixir as a NIF via Zigler. It accepts a list of CSS class candidate strings (extracted in Elixir) and returns minified production CSS. Everything happens in memory — no filesystem, no external processes, no CLI.

```elixir
candidates = ["flex", "p-4", "hover:bg-blue-500/50", "sm:text-lg", "w-[calc(100%-2rem)]"]
theme = %{spacing: "0.25rem", colors: %{"blue-500" => "oklch(62.3% 0.214 259.815)"}}

css = Beacon.CSS.compile(candidates, theme)
# => ".flex{display:flex}.p-4{padding:calc(var(--spacing)*4)}..."
```

## Architecture

```
Elixir (BEAM)                          Zig (NIF)
─────────────                          ─────────

1. Extract candidates
   from templates
   (regex, at publish time)
        │
        ▼
2. Diff against known set
   (MapSet, skip if empty)
        │
        ▼
3. Call NIF with full       ──────►  4. Parse each candidate
   candidate list + theme               │
                                         ├─ Split variants (hover:sm:)
                                         ├─ Identify utility root (bg, p, text)
                                         ├─ Resolve value (blue-500, 4, [calc(...)])
                                         ├─ Look up utility → CSS declarations
                                         ├─ Apply variants (selectors, media queries)
                                         ├─ Deduplicate
                                         │
                                       5. Emit CSS
                                         ├─ @layer theme   (CSS custom properties)
                                         ├─ @layer base    (preflight/reset)
                                         ├─ @layer utilities (generated rules)
                                         │
                                       6. Minify in-place
                                         ├─ No whitespace (generated tight)
                                         ├─ Short colors (#fff not #ffffff)
                                         ├─ Strip zero units (0 not 0px)
                                         │
                            ◄──────  7. Return CSS binary to BEAM
```

## NIF Interface

### Zigler module

```elixir
defmodule Beacon.CSS.Native do
  use Zig, otp_app: :beacon, nifs: [compile: [:dirty_cpu]]

  ~Z"""
  const std = @import("std");
  const compiler = @import("compiler.zig");

  /// Accepts a list of candidate strings and a theme config binary.
  /// Returns minified CSS as a binary.
  pub fn compile(candidates: [][]const u8, theme_json: []const u8) ![]const u8 {
      var arena = std.heap.ArenaAllocator.init(beam.allocator);
      defer arena.deinit();
      const alloc = arena.allocator();

      const theme = compiler.Theme.parse(alloc, theme_json);
      var ctx = compiler.Context.init(alloc, theme);

      for (candidates) |candidate| {
          ctx.process(candidate);
      }

      return ctx.emit();
  }
  """
end
```

### Elixir wrapper

```elixir
defmodule Beacon.CSS do
  def compile(candidates, theme \\ %{}) when is_list(candidates) do
    theme_json = Jason.encode!(theme)
    Beacon.CSS.Native.compile(candidates, theme_json)
  end
end
```

The NIF runs on a dirty CPU scheduler. For a typical site (~500 candidates), expected latency is sub-10ms. The arena allocator means zero individual frees — one bulk deallocation when the NIF returns.

## Candidate Parser

Each candidate string like `hover:sm:bg-blue-500/50` is parsed into:

```
Candidate {
    variants: ["hover", "sm"],
    important: false,          // leading !
    utility: "bg",             // root
    value: .{ .named = "blue-500" },  // or .arbitrary for [...]
    modifier: .{ .named = "50" },     // after /
}
```

### Parsing rules

1. Split on `:` from left — each segment before the last is a variant
2. Check for leading `!` — sets important flag
3. The last segment is the utility + value
4. Find the utility root by matching against the registry (try longest prefix first: `bg-blue-500` → `bg-blue` → `bg`)
5. Split on `/` for modifier (opacity, line-height)
6. Detect arbitrary values: `[...]` brackets, or `(...)` for theme function shorthand

### Arbitrary values

- `text-[#ff0000]` → arbitrary color, used as-is
- `w-[calc(100%-2rem)]` → arbitrary length, used as-is
- `bg-[color:var(--my-color)]` → explicit type hint before `:`
- `p-(--my-spacing)` → theme function, emits `var(--my-spacing)`

## Utility Registry

The registry maps utility roots to CSS declaration generators. Organized by category:

### Data structure

```zig
const UtilityDef = struct {
    properties: []const []const u8,     // CSS properties to set
    theme_keys: []const []const u8,     // theme namespaces to resolve from
    value_type: enum { spacing, color, keyword, length, any },
    supports_negative: bool,
    supports_modifier: bool,            // opacity modifier for colors
    static_values: ?[]const StaticValue, // e.g., "auto", "full", "screen"
};
```

### Categories and scale

| Category | Utility roots | Example |
|----------|--------------|---------|
| Layout | ~25 | `block`, `flex`, `grid`, `absolute`, `z-*` |
| Flexbox/Grid | ~20 | `basis-*`, `grow-*`, `cols-*`, `gap-*` |
| Spacing | ~16 | `p-*`, `px-*`, `m-*`, `mt-*`, `space-x-*` |
| Sizing | ~12 | `w-*`, `h-*`, `min-w-*`, `max-h-*`, `size-*` |
| Typography | ~15 | `text-*`, `font-*`, `leading-*`, `tracking-*` |
| Backgrounds | ~10 | `bg-*`, `bg-linear-*`, `bg-radial-*` |
| Borders | ~15 | `border-*`, `rounded-*`, `ring-*`, `outline-*`, `divide-*` |
| Effects | ~10 | `shadow-*`, `opacity-*`, `blur-*`, `brightness-*` |
| Transforms | ~8 | `rotate-*`, `scale-*`, `translate-*` |
| Transitions | ~5 | `transition-*`, `duration-*`, `delay-*`, `ease-*` |
| Colors | ~12 roots | `bg-*`, `text-*`, `border-*`, `accent-*`, `fill-*`, `stroke-*` |
| Interactivity | ~8 | `cursor-*`, `select-*`, `scroll-*`, `snap-*` |

**Total: ~400 static utilities + ~70 functional utility roots**

### Implementation approach

Static utilities are a compile-time perfect hash map (Zig's `std.StaticStringMap`):

```zig
const static_utilities = std.StaticStringMap([]const Declaration).initComptime(.{
    .{ "block", &.{.{ "display", "block" }} },
    .{ "flex", &.{.{ "display", "flex" }} },
    .{ "grid", &.{.{ "display", "grid" }} },
    .{ "hidden", &.{.{ "display", "none" }} },
    .{ "absolute", &.{.{ "position", "absolute" }} },
    .{ "relative", &.{.{ "position", "relative" }} },
    .{ "sr-only", &.{
        .{ "position", "absolute" },
        .{ "width", "1px" },
        .{ "height", "1px" },
        .{ "padding", "0" },
        .{ "margin", "-1px" },
        .{ "overflow", "hidden" },
        .{ "clip", "rect(0,0,0,0)" },
        .{ "white-space", "nowrap" },
        .{ "border-width", "0" },
    }},
    // ... ~400 entries
});
```

Functional utilities use a prefix-match table with handler functions:

```zig
const FunctionalHandler = *const fn (
    alloc: Allocator,
    value: Value,
    modifier: ?Modifier,
    theme: *const Theme,
) []const Declaration;

const functional_utilities = std.StaticStringMap(FunctionalHandler).initComptime(.{
    .{ "bg", handleBg },
    .{ "text", handleText },
    .{ "p", handlePadding },
    .{ "m", handleMargin },
    // ... ~70 entries
});
```

### Spacing utilities

Spacing utilities (`p-*`, `m-*`, `gap-*`, `w-*`, `h-*`, `inset-*`, etc.) share a common pattern:

- Named value: resolve from `--spacing-{name}` theme key → `var(--spacing-{name})`
- Bare integer: multiply by base spacing → `calc(var(--spacing) * {n})`
- Fraction: compute percentage → `{a/b * 100}%`
- Special values: `auto`, `full` (100%), `screen` (100vw/100vh), `px` (1px)
- Arbitrary: use raw value

### Color utilities

Color utilities (`bg-*`, `text-*`, `border-*`, etc.) share:

- Named value: resolve from `--color-{name}` → `var(--color-{name})`
- With modifier (`/50`): wrap in `color-mix(in oklab, var(--color-{name}) 50%, transparent)`
- Special: `inherit`, `transparent`, `current` (currentColor)
- Arbitrary: use raw value, detect type if needed

## Variant System

### Data structure

```zig
const VariantDef = struct {
    kind: enum { selector, media, container, compound },
    order: u16,              // sort key for output ordering
    apply: ApplyFn,          // transforms the rule
};

const ApplyFn = *const fn (
    alloc: Allocator,
    rule: *Rule,
    value: ?[]const u8,      // for functional variants like aria-*
    theme: *const Theme,
) void;
```

### Variant categories

| Kind | Variants | Output wrapping |
|------|----------|----------------|
| Selector | `hover`, `focus`, `active`, `first`, `last`, `odd`, `even`, `disabled`, `checked`, etc. (~30) | `&:hover { ... }` |
| Selector (special) | `hover` | `@media (hover:hover){&:hover{...}}` |
| Media | `sm`, `md`, `lg`, `xl`, `2xl` | `@media (width>={breakpoint}){...}` |
| Media (preference) | `dark`, `print`, `motion-safe`, `motion-reduce`, `portrait`, `landscape`, `contrast-more` (~12) | `@media (prefers-color-scheme:dark){...}` |
| Container | `@sm`, `@md`, `@lg` | `@container (width>={size}){...}` |
| Compound | `group-*`, `peer-*`, `has-*`, `not-*`, `in-*` | Selector rewriting |
| Functional | `aria-*`, `data-*`, `supports-*`, `min-*`, `max-*` | `&[aria-{value}]` or `@supports` or `@media` |

### Application order

Variants are applied right-to-left on the candidate, but emitted in order of their `order` field. For `sm:hover:text-red-500`:

1. Parse: variants = `["sm", "hover"]`, utility = `text-red-500`
2. Generate utility declarations: `color: var(--color-red-500)`
3. Apply `hover` (rightmost first): wrap in `&:hover` + `@media (hover:hover)`
4. Apply `sm`: wrap in `@media (width>=40rem)`
5. Emit with sort key derived from variant orders

## Theme

### Input format

Theme is passed from Elixir as JSON:

```json
{
  "spacing": "0.25rem",
  "colors": {
    "red-500": "oklch(63.7% 0.237 25.331)",
    "blue-500": "oklch(62.3% 0.214 259.815)",
    "brand": "#3f3cbb"
  },
  "breakpoints": {
    "sm": "40rem",
    "md": "48rem",
    "lg": "64rem",
    "xl": "80rem",
    "2xl": "96rem"
  },
  "font-family": {
    "sans": "ui-sans-serif, system-ui, sans-serif",
    "mono": "ui-monospace, monospace"
  },
  "radius": {
    "sm": "0.25rem",
    "md": "0.375rem",
    "lg": "0.5rem"
  }
}
```

Beacon builds this JSON from the user's `@theme` CSS block at site configuration time. The Zig NIF doesn't parse CSS — it receives pre-extracted theme values.

### Default theme

The Zig compiler ships with Tailwind v4's complete default theme compiled in as `comptime` data. User theme values override or extend defaults.

### Resolution

```zig
fn resolve(theme: *const Theme, value: []const u8, namespaces: []const []const u8) ?[]const u8 {
    // Try each namespace in order
    for (namespaces) |ns| {
        // e.g., ns = "--color", value = "blue-500"
        // Look up "blue-500" in theme.colors
        if (theme.get(ns, value)) |resolved| {
            // Return as CSS variable reference: var(--color-blue-500)
            return fmt("var({s}-{s})", .{ ns, value });
        }
    }
    return null;
}
```

## CSS Output

### Structure

The compiler emits CSS in this order:

```css
@layer theme{:root{--color-red-500:oklch(63.7% 0.237 25.331);--spacing:0.25rem;...}}
@layer base{*,::after,::before{box-sizing:border-box;border:0 solid;...}...}
@layer utilities{.flex{display:flex}.p-4{padding:calc(var(--spacing)*4)}...}
```

### Theme layer

Only emit theme variables that are actually referenced by the generated utilities. Track which theme keys were accessed during utility resolution.

### Base layer

Tailwind's preflight is a fixed ~2KB CSS reset. Ship it as a comptime string constant. Only emit if the caller requests it (Beacon may have its own reset).

### Utilities layer

Emit utilities sorted by variant order, then by utility registration order within the same variant group. This ensures deterministic output.

### Minification

Since we generate the CSS, we emit it already minified:

- No whitespace between tokens (`.flex{display:flex}` not `.flex { display: flex; }`)
- No trailing semicolons in single-declaration rules
- Short hex colors where possible
- `0` not `0px` for zero lengths
- No comments

This is "free" minification — no parsing step needed, just tight formatting in the emitter.

## Selector Escaping

Tailwind class names containing special CSS characters must be escaped in selectors:

- `.` → `\.`
- `/` → `\/`
- `:` → `\:`
- `[` → `\[`
- `]` → `\]`
- `#` → `\#`
- `%` → `\%`

For `hover:bg-blue-500/50`, the selector is `.hover\:bg-blue-500\/50:hover`.

## Build & Distribution

### Zig package structure

```
native/beacon_css/
  build.zig
  build.zig.zon
  src/
    main.zig          # NIF entry point
    compiler.zig      # Core compiler context
    candidate.zig     # Candidate parser
    utilities.zig     # Utility registry + handlers
    variants.zig      # Variant registry + handlers
    theme.zig         # Theme parser + resolver
    emitter.zig       # CSS string builder (minified)
    preflight.zig     # Base reset CSS constant
    default_theme.zig # Default Tailwind v4 theme values
```

### Zigler config

```elixir
# mix.exs
{:zigler, "~> 0.15", runtime: false}

# Beacon.CSS.Native module
use Zig,
  otp_app: :beacon,
  nifs: [compile: [:dirty_cpu]],
  zig_code_path: "native/beacon_css/src/main.zig"
```

### Precompilation

Use Zigler's precompilation support to ship prebuilt binaries:
- `aarch64-macos` (Apple Silicon dev)
- `x86_64-linux-gnu` (Fly.io, most CI)
- `aarch64-linux-gnu` (ARM servers)
- `x86_64-linux-musl` (Alpine Docker)

Users without Zig installed get precompiled binaries. Contributors building from source need Zig 0.15.x.

## Performance Budget

| Operation | Target | Notes |
|-----------|--------|-------|
| Parse 500 candidates | < 1ms | String splitting, no allocation per candidate |
| Resolve utilities | < 2ms | Hash map lookups, string formatting |
| Apply variants | < 1ms | Selector/media query wrapping |
| Emit minified CSS | < 1ms | Single-pass string builder |
| **Total NIF call** | **< 5ms** | For typical site with ~500 unique classes |
| Large site (5000 candidates) | < 30ms | Linear scaling |

Arena allocator means: one `init` at entry, one `deinit` at exit. No per-object frees. GC-free.

## Integration with Beacon

### At publish time (Elixir)

```elixir
defmodule Beacon.CSS.CandidateExtractor do
  @candidate_regex ~r/(?:^|[\s"'`<>={}()|,;])([!a-z0-9\-\[\.][a-z0-9:\/\-\[\]._!#%]*)/

  def extract(template) when is_binary(template) do
    @candidate_regex
    |> Regex.scan(template, capture: :all_but_first)
    |> List.flatten()
    |> MapSet.new()
  end
end
```

### In RuntimeRenderer.publish_page

```elixir
def publish_page(site, page_id, attrs) do
  # ... existing IR publishing ...

  # Extract and store CSS candidates
  candidates = CandidateExtractor.extract(attrs.template)
  :ets.insert(@table, {{site, page_id, :css_candidates}, candidates})

  # Check if site CSS needs recompilation
  known = get_known_candidates(site)
  new = MapSet.difference(candidates, known)

  if MapSet.size(new) > 0 do
    updated = MapSet.union(known, new)
    :ets.insert(@table, {{site, :css_candidates}, updated})
    recompile_css(site, updated)
  end
end

defp recompile_css(site, candidates) do
  theme = load_theme(site)
  candidate_list = MapSet.to_list(candidates)
  css = Beacon.CSS.compile(candidate_list, theme)

  hash = :crypto.hash(:md5, css) |> Base.encode16(case: :lower)
  brotli = ExBrotli.compress(css)
  gzip = :zlib.gzip(css)

  :ets.insert(:beacon_assets, {{site, :css}, {hash, brotli, gzip}})
end
```

### Warming flow

When a request hits an un-cached page:

1. Serve the warming LiveView immediately (lightweight placeholder)
2. LiveView subscribes to `Beacon.PubSub` for the page
3. Background task: load page → extract candidates → diff → maybe recompile CSS → publish to ETS → broadcast
4. LiveView receives broadcast → re-renders with real page content
5. All concurrent requests to the same page share the single build via Beacon.Cache stampede protection

## Implementation Phases

### Phase 1: Static utilities only
- The ~400 static utilities (perfect hash map)
- Basic variant support (hover, focus, responsive breakpoints, dark)
- Default theme
- Minified output
- Zigler NIF integration
- **Covers ~60% of real-world usage**

### Phase 2: Functional utilities
- Spacing utilities (p-*, m-*, gap-*, w-*, h-*, etc.)
- Color utilities with opacity modifiers
- Typography utilities (text-*, font-*, leading-*, tracking-*)
- Border/radius/shadow utilities
- **Covers ~95% of real-world usage**

### Phase 3: Advanced features
- Arbitrary values (`text-[#ff0000]`, `w-[calc(100%-2rem)]`)
- All remaining variants (compound, functional, container queries)
- Custom theme support (user `@theme` overrides)
- `@property` declarations for composable utilities (shadow, transform, filter)
- **Covers ~100% of Tailwind v4 output**

### Phase 4: Optimization
- Precompiled NIF binaries for all targets
- Benchmark suite against Tailwind CLI output
- CSS output diff testing against Tailwind v4 for correctness
- Tree-shaking unused theme variables
