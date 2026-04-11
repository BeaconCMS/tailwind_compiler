# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

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

[0.0.5]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.5
[0.0.4]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.4
[0.0.3]: https://github.com/beaconcms/tailwind_compiler/releases/tag/v0.0.3
