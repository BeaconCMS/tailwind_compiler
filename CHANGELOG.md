# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [0.0.7] - 2026-04-18

### Added

- WASM binary included in release artifacts and downloadable via `TailwindCompiler.wasm_path/0`
- Automatic WASM install during `mix compile` when `TAILWIND_COMPILER_WASM=true` is set
- Explicit `@layer` order declarations for correct CSS cascade priority
- `@supports` fallback block in `@layer properties` for older browsers
- CSS nesting for all pseudo-class, aria, data, and compound variants (matching official Tailwind v4 output)
- `has-[:checked]` variant with proper `&:has(*:is(:checked))` wrapping
- Named group variants (`group-hover/mega`) with correct selectors
- `@media (hover: hover)` guard on `group-hover` and `hover` variants
- `selection:` variant descendant propagation (`& *::selection`)
- Shadow DOM support via `:root, :host` in theme layer

### Changed

- `theme()` opacity now uses `color-mix(in oklab, ...)` instead of `oklch(... / opacity)`
- `theme()` inline resolution no longer pollutes the theme layer with unused variables
- Shadow arbitrary values with `theme()` colors now wrapped in `var(--tw-shadow-color, ...)`
- `divide-x` uses logical properties (`border-inline-*`) instead of physical
- Opacity values use percentage notation (`30%` not `.3`)
- Duration values use `ms` notation (`300ms` not `.3s`)
- `text-transparent` uses `transparent` keyword instead of `#0000`
- `bg-clip-text` no longer emits `-webkit-` prefix
- `aspect-square` outputs `1 / 1` instead of `1`
- `leading-none` outputs literal `1` instead of `var(--leading-none)`
- Spaces added after commas in `color-mix()`, `var()`, and `@supports` values

## [0.0.6] - 2026-04-15

### Added

- `plugin_css` option for importing Tailwind plugin CSS (e.g., DaisyUI, @tailwindcss/forms). Parses `--color-*` variable definitions from `:root` and `[data-theme]` blocks, registers them as theme colors for utility generation (`bg-*`, `text-*`, `border-*`), and includes all plugin CSS in output.

## [0.0.5] - 2026-04-11

### Added

- Windows x86_64 precompiled NIF binary support
- Windows platform detection and `.dll` NIF loading

### Fixed

- Zigler Windows NIF compilation by providing missing `erl_nif_win.h` headers

## [0.0.4] - 2026-04-10

### Fixed

- Underscore-to-space conversion in arbitrary variant selectors

### Changed

- Added peak RSS memory comparison to benchmark
- Added pure Zig compile vs Tailwind v4 JS compile API benchmark
- Updated release process documentation and README installation section

## [0.0.3] - 2025-05-22

### Added

- Initial public release
- Tailwind CSS v4-compatible compiler written in Zig
- Elixir NIF integration via Zigler
- Precompiled NIF binaries for x86_64-linux, aarch64-linux, and aarch64-macos
- ~565 static utilities, ~85 functional utility roots, 77+ variants
- JSON theme overrides, custom CSS passthrough, preflight toggle
- Arena allocator for efficient memory management

[0.0.7]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.7
[0.0.6]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.6
[0.0.5]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.5
[0.0.4]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.4
[0.0.3]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.3
