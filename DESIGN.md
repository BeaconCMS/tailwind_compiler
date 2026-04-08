# TailwindCompiler — Remaining Work

## Current State

9,092 lines of Zig. 526 static utilities, 62 functional resolvers, 50+ variants.
Generates 425 unique selectors for the DockYard homepage. Production Tailwind CLI
generates 1,282 selectors for the full site. We're at ~33% selector coverage against
the full site, but much higher for the homepage specifically since most missing
selectors are from pages that haven't been loaded yet.

The 886 missing selectors break down as:

- **116 custom CSS classes** (not Tailwind — `.alert`, `.btn`, `.link-*`, `.form-*`, `.highlight`, `.phx-*`, `.featured-*`) — these come from Beacon's custom stylesheets and are passed through as `custom_css`. Not a compiler issue.
- **770 Tailwind utility classes** the compiler doesn't generate, broken down below.

## Missing Tailwind Utilities

### 1. Missing Static Utilities

These are fixed class→declaration mappings we don't have yet:

```
antialiased          → -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale
blur                 → filter: blur(8px)
filter               → (legacy, no-op in v4)
transform            → (legacy, no-op in v4)
border-collapse      → border-collapse: collapse  (HAVE IT — may be extraction issue)
border-solid         → border-style: solid  (HAVE IT — may be extraction issue)
border-none          → border-style: none  (HAVE IT — may be extraction issue)
capitalize           → text-transform: capitalize
lowercase            → text-transform: lowercase
normal-case          → text-transform: none
truncate             → overflow: hidden; text-overflow: ellipsis; white-space: nowrap
isolate              → isolation: isolate
static               → position: static
contents             → display: contents
list-item            → display: list-item
list-decimal         → list-style-type: decimal
collapse             → visibility: collapse
cursor-pointer       → cursor: pointer
resize               → resize: both
object-contain       → object-fit: contain
bg-center            → background-position: center
bg-cover             → background-size: cover
bg-gradient-to-br    → background-image: linear-gradient(to bottom right, ...)
place-content-center → place-content: center
outline              → outline-style: solid
outline-none         → outline: 2px solid transparent; outline-offset: 2px
invert               → filter: invert(100%)
grayscale            → filter: grayscale(100%)
ring                 → box-shadow ring (3px default)
shadow               → box-shadow (default shadow)
transition-colors    → transition-property: color, background-color, border-color, ...
tracking-normal      → letter-spacing: 0em
leading-normal       → line-height: 1.5 (HAVE as theme var — may not resolve)
leading-5            → line-height: 1.25rem
decoration-clone     → box-decoration-break: clone
overflow-x-auto      → overflow-x: auto
overflow-x-scroll    → overflow-x: scroll
```

**Status:** Most of these ARE in our static map (526 entries). The issue is likely
that the **candidate extractor** isn't finding them in templates, OR the templates
containing them haven't been loaded yet (lazy loading — only requested pages get
their candidates extracted).

### 2. Missing Color Values

163 missing color-related selectors. Our theme has the colors defined but many
specific shade+utility combinations aren't being generated:

```
bg-blue-400, bg-cyan-200, bg-dy-green, bg-dy-purple, bg-gray-500,
bg-green-400, bg-green-500, bg-indigo-200, bg-indigo-400, bg-lime-100,
bg-orange-200, bg-pink-200, bg-red-400, bg-red-500, bg-slate-100,
bg-slate-400, bg-slate-800, bg-yellow-300, bg-white/10
```

**Root cause:** These appear on non-homepage pages that haven't been loaded.
The candidate extractor only runs on pages that have been requested. Since we
only loaded the homepage, these colors from other pages are missing.

**Fix:** This is a Beacon integration issue, not a compiler issue. Beacon needs
to extract candidates from ALL published pages at boot time (or at least at first
CSS compile time), not just the ones that have been requested.

### 3. Missing Arbitrary Values (47 selectors)

```
bg-[#00a8e8]
from-[#0077b6]
from-[#00a8e8]
to-[#0077b6]
to-[#00a8e8]
z-[-1]
max-w-[1464px]
max-w-[200px]
max-w-[250px]
max-w-[300px]
max-w-[calc(100%_+_2rem)]
min-h-[100dvh]
lg:h-[43px]
lg:w-[56px]
md:h-[72px]
md:w-[72px]
md:w-[90%]
xl:max-w-[calc(100%_+_2.5rem)]
xl:-bottom-[53px]
mb-[1.625rem]
md:my-[60px]
md:max-w-[810px]
md:right-[5%]
md:right-[calc(5%_+_1rem)]
p-[0.5]
2xl:max-w-[calc(100%_+_5rem)]
2xl:rounded-2.5xl
[text-shadow:_0.4px_0_0_#2D49D7]
lg:[text-shadow:_0.6px_0_0_#2D49D7]
w-[25%]
w-[50%]
```

**Root cause:** Two issues:
1. Many are on non-homepage pages (extraction issue)
2. Some arbitrary value formats may not be handled by the Zig compiler's
   candidate parser (particularly `_` as space replacement: `calc(100%_+_2rem)`)

**Fix in compiler:** Ensure the candidate parser handles `_` → space conversion
inside arbitrary values. Tailwind v4 uses `_` as a space stand-in inside `[]`.

### 4. Missing Custom Theme Utilities

```
aspect-blog            → aspect-ratio: 36 / 13 (from theme)
grid-rows-blog         → grid-template-rows: repeat(3, auto) (from theme)
grid-rows-featured-*   → grid-template-rows from theme
grid-cols-blog         → grid-template-columns from theme
grid-cols-intro        → grid-template-columns from theme
grid-cols-cta          → grid-template-columns from theme
max-w-720              → max-width: 45rem (from theme)
max-w-1360             → max-width: 85rem (from theme)
max-w-sm               → max-width: 24rem (default theme)
max-w-screen-lg        → max-width: 64rem (from breakpoints)
scroll-mt-21           → scroll-margin-top from theme spacing
rounded-2.5xl          → border-radius from theme
rounded-4xl            → border-radius from theme
tracking-widestXl      → letter-spacing: 0.3em (from theme)
text-eyebrow           → font-size from theme
w-0.5                  → width: 0.125rem (decimal spacing)
shadow-featured-*      → box-shadow from theme
transition-link        → transition-property from theme
```

**Root cause:** The Zig compiler's functional utility resolvers look up values in
the theme, but the theme variable naming may not match. For example:

- `aspect-blog` looks for `--aspect-blog` ✓ (theme has it)
- `grid-cols-blog` looks for `--grid-template-columns-blog` but theme key might
  not match the prefix the resolver uses
- `max-w-720` looks for `--max-width-720` but theme stores it differently

**Fix in compiler:** Audit each functional resolver's theme namespace against
what `theme.parseJson` actually stores. Ensure the prefixes match.

### 5. Missing Responsive/Variant Combinations

Many responsive variants of utilities we DO have are missing. For example we
generate `.flex` but not `.lg:flex`, `.md:flex`, `.sm:flex`, `.xl:flex`.

**Root cause:** The candidates `lg:flex`, `md:flex`, etc. aren't being extracted
because they appear in templates of pages that haven't been loaded yet.

**This is NOT a compiler issue.** The compiler correctly generates responsive
variants when given the candidates. The extractor just isn't seeing them.

### 6. Complex Variant Selectors

Some selectors use advanced Tailwind features:

```
lg:[&>.career-perk]:text-base>.career-perk
lg:[&>li]:leading-loose>li
xl:[&>li]:leading-loose>li
md:[&>.work-snapshot:nth-child(odd)]:border-gray-200>.work-snapshot:nth-child(odd)
first-of-type:lg:leading-loose:first-of-type
first-of-type:lg:mb-6:first-of-type
xl:active:ring-offset-[12px]:active
xl:focus-within:ring-offset-[12px]:focus-within
xl:hover:ring-offset-[16px]:hover
block!
```

**Root cause:** These use arbitrary variant selectors `[&>...]` which the Zig
compiler may not fully support yet. Also `block!` uses the trailing `!` for
important (Tailwind v4 syntax) — need to verify this is handled.

**Fix in compiler:**
- Support `[&>...]` arbitrary variant selectors
- Verify trailing `!` important flag works (we support leading `!`)
- Support stacked variants with first-of-type, last-child, etc.

## Root Cause Summary

The missing selectors fall into two categories:

### A. Beacon extraction issue (majority — ~600 of 770)

Candidates from non-homepage pages aren't extracted because Beacon uses lazy
loading. Only the homepage template + layout + components are scanned. The
remaining ~900 pages' templates are never scanned for candidates.

**Fix in Beacon (not this repo):** At CSS compile time, scan ALL published page
templates for candidates, not just the ones loaded in ETS. The
`RuntimeCSS.collect_all_candidates` function already scans layouts and components
from the database — it should also scan all page templates from snapshots.

### B. Compiler gaps (~170 of 770)

Genuine missing functionality in the Zig compiler:

1. **Underscore-to-space in arbitrary values** (`calc(100%_+_2rem)` → `calc(100% + 2rem)`)
2. **Arbitrary variant selectors** (`[&>.career-perk]:text-base`)
3. **Theme prefix mismatches** for grid-template-*, max-width, aspect-ratio
4. **Some missing static utilities** (antialiased, blur, ring default, transition-colors)
5. **Decimal spacing values** (`w-0.5`, `p-4.5`, `mb-2.5`, `top-2.5`)
6. **Trailing `!` important** (`block!` — Tailwind v4 syntax)
7. **`min-[...]` arbitrary breakpoint variants** (`min-[400px]:gap-3`)
8. **`2xl:` responsive variant** (need to verify it's registered)

## Implementation Plan

### Phase 1: Fix Beacon extraction (Beacon repo)

Update `RuntimeCSS.collect_all_candidates` to scan ALL published page templates
from `beacon_page_snapshots`, not just pages loaded in ETS. This fixes ~600 of
the 770 missing selectors with zero compiler changes.

```elixir
# In collect_all_candidates, add:
page_template_candidates =
  Beacon.Content.list_published_pages_snapshot_data(site)
  |> Enum.reduce(MapSet.new(), fn page, acc ->
    template = Beacon.Lifecycle.Template.load_template(page)
    MapSet.union(acc, CandidateExtractor.extract(template))
  end)
```

### Phase 2: Fix compiler gaps (this repo)

#### 2a. Underscore-to-space in arbitrary values
In `candidate.zig`, when parsing arbitrary values inside `[...]`, replace `_`
with space. This is a Tailwind v4 convention.

#### 2b. Decimal spacing values
In the spacing resolver, handle values like `0.5`, `2.5`, `4.5` — multiply by
the spacing base. Currently the parser may reject these because they contain `.`.

#### 2c. Missing static utilities
Add to the static utility map:
- `antialiased`
- `subpixel-antialiased`
- `transition-colors`
- `ring` (default ring)
- `blur` (default blur)
- `filter` (legacy no-op)
- `transform` (legacy no-op)

#### 2d. Theme prefix alignment
Audit and fix the namespace mapping in `theme.zig`:
- `gridTemplateColumns` → `--grid-cols-*` or `--grid-template-columns-*`?
  Check what `resolveGridTemplate` in `utilities.zig` expects.
- `maxWidth` → `--max-width-*` or `--max-w-*`?
  Check what `resolveSpacing` with `max-w` root expects.
- Same for `aspectRatio`, `height`, `borderRadius`, `letterSpacing`

#### 2e. Arbitrary variant selectors
Support `[&>...]` syntax in `variants.zig`. When a variant starts with `[`,
it's an arbitrary selector that wraps the rule.

#### 2f. `min-[...]` breakpoints
Support `min-[400px]` as a variant that produces `@media (width>=400px)`.

#### 2g. Trailing `!` important
The Zig candidate parser supports leading `!` (`!flex`). Tailwind v4 also
supports trailing `!` (`flex!`). Verify and fix.

#### 2h. `2xl:` breakpoint
Verify `2xl` is registered as a breakpoint variant at 96rem.

### Phase 3: Validation

Build a test harness that:
1. Takes the DockYard production CSS selectors as the reference
2. Runs the compiler with all extracted candidates
3. Diffs the output selectors against the reference
4. Reports coverage percentage and specific gaps

Target: 100% of Tailwind utility selectors that appear in the production CSS
should be generated by the compiler. Custom CSS classes (`.alert`, `.btn`, etc.)
are handled by the `custom_css` passthrough and don't count.
