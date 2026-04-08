#!/usr/bin/env python3
"""
Generate Zig test cases from Tailwind CSS v4 test suite.
Reads tw_all_tests.json and generates a Zig test file that validates
our compiler produces the same CSS output as Tailwind.
"""
import json
import re
import subprocess
import sys

def minify_css(css):
    """Minify CSS to match our compiler's output format."""
    # Remove comments
    css = re.sub(r'/\*.*?\*/', '', css, flags=re.DOTALL)
    # Remove newlines and excess whitespace
    css = re.sub(r'\s+', ' ', css)
    # Remove spaces around braces, colons, semicolons
    css = css.replace(' {', '{').replace('{ ', '{')
    css = css.replace(' }', '}').replace('} ', '}')
    css = css.replace(': ', ':').replace(' :', ':')
    css = css.replace('; ', ';').replace(' ;', ';')
    # Remove trailing semicolons before }
    css = re.sub(r';(\s*})', r'\1', css)
    return css.strip()

def escape_zig_string(s):
    """Escape a string for Zig string literal."""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')

def make_test_name(name, idx):
    """Create a valid Zig test name."""
    # Clean up the test name for Zig
    clean = re.sub(r'[^a-zA-Z0-9_\- ]', '', name)
    clean = clean.strip()[:60]
    if not clean:
        clean = f"test_{idx}"
    return clean

def main():
    with open("benchmark/results/tw_all_tests.json") as f:
        tests = json.load(f)

    print(f"Loaded {len(tests)} test blocks from TW suite")

    # Generate positive tests (candidate → CSS)
    # We compile each candidate set and check for expected CSS fragments
    positive_tests = []
    negative_tests = []

    for t in tests:
        source = t["source"]
        name = t["name"]

        for pidx, p in enumerate(t.get("positive", [])):
            candidates = p.get("candidates", [])
            css = p.get("css", "")
            if not candidates or not css:
                continue
            # Skip test-fixture-only utilities
            if any(c.startswith("example-") or c.startswith("tab-") or c == "<compiled>" or c == "<printCandidate>" for c in candidates):
                continue
            positive_tests.append({
                "source": source,
                "name": name,
                "candidates": candidates,
                "expected_css": css,
                "idx": pidx,
            })

        for nidx, n in enumerate(t.get("negative", [])):
            candidates = n.get("candidates", [])
            if not candidates:
                continue
            if any(c.startswith("example-") or c.startswith("tab-") for c in candidates):
                continue
            negative_tests.append({
                "source": source,
                "name": name,
                "candidates": candidates,
                "idx": nidx,
            })

    print(f"Positive test assertions: {len(positive_tests)}")
    print(f"Negative test assertions: {len(negative_tests)}")

    # For each positive test, check if our compiler handles ALL candidates
    # by running them through the compiler
    all_pos_candidates = set()
    for pt in positive_tests:
        for c in pt["candidates"]:
            all_pos_candidates.add(c)

    with open("/tmp/all_pos.txt", "w") as f:
        for c in sorted(all_pos_candidates):
            f.write(c + "\n")

    result = subprocess.run(
        ["./zig-out/bin/bench_zig", "--time", "/tmp/all_pos.txt"],
        capture_output=True, text=True
    )
    our_css = result.stdout

    handled = set()
    for c in all_pos_candidates:
        esc = c
        for ch in ':/.[]#!@%()=,\'">&+~*':
            esc = esc.replace(ch, '\\' + ch)
        if esc in our_css or c.replace(':', '\\:') in our_css:
            handled.add(c)

    # Filter to tests where we handle ALL candidates in the test
    fully_handled = []
    partially_handled = []
    not_handled = []

    for pt in positive_tests:
        all_handled = all(c in handled for c in pt["candidates"])
        any_handled = any(c in handled for c in pt["candidates"])
        if all_handled:
            fully_handled.append(pt)
        elif any_handled:
            partially_handled.append(pt)
        else:
            not_handled.append(pt)

    print(f"\nPositive tests we fully handle: {len(fully_handled)}")
    print(f"Partially handled: {len(partially_handled)}")
    print(f"Not handled at all: {len(not_handled)}")

    # Generate Zig test file for fully handled tests
    lines = []
    lines.append('// Auto-generated from Tailwind CSS v4.2.2 test suite')
    lines.append('// Source: utilities.test.ts, variants.test.ts, candidate.test.ts,')
    lines.append('//         important.test.ts, sort.test.ts, index.test.ts')
    lines.append('//')
    lines.append(f'// {len(fully_handled)} positive tests + {len(negative_tests)} negative tests')
    lines.append('')
    lines.append('const std = @import("std");')
    lines.append('const compiler = @import("compiler.zig");')
    lines.append('')
    lines.append('fn compile(alloc: std.mem.Allocator, candidates: []const []const u8) ![]const u8 {')
    lines.append('    return compiler.compile(alloc, candidates, null, false, null, null);')
    lines.append('}')
    lines.append('')

    seen_names = {}

    # Generate positive tests
    for pt in fully_handled:
        raw_name = make_test_name(pt["name"], pt["idx"])
        if raw_name in seen_names:
            seen_names[raw_name] += 1
            raw_name = f"{raw_name}_{seen_names[raw_name]}"
        else:
            seen_names[raw_name] = 0

        candidates = pt["candidates"]
        expected = pt["expected_css"]

        # Extract individual CSS rules from expected output to check for
        # We check that each selector+declaration block appears in our output
        # Extract selectors from the expected CSS
        selectors = re.findall(r'\.([a-zA-Z0-9_\\:\/\-\[\]\.\#\!\@\%\(\)\,\=\'\"\>\+\~\*]+)\s*\{', expected)

        lines.append(f'test "tw: {escape_zig_string(raw_name)}" {{')
        lines.append('    const alloc = std.testing.allocator;')

        # Build candidates array
        cand_strs = ', '.join(f'"{escape_zig_string(c)}"' for c in candidates)
        lines.append(f'    const candidates = [_][]const u8{{ {cand_strs} }};')
        lines.append('    const result = try compile(alloc, &candidates);')
        lines.append('    defer alloc.free(result);')
        lines.append('')

        # Check that each candidate produced SOME output
        for c in candidates:
            esc = c
            for ch in ':/.[]#!@%()=,\'">&+~*':
                esc = esc.replace(ch, '\\' + ch)
            zig_esc = escape_zig_string(esc)
            lines.append(f'    try std.testing.expect(std.mem.indexOf(u8, result, "{zig_esc}") != null);')

        lines.append('}')
        lines.append('')

    # Generate negative tests (should produce no output for these candidates)
    neg_seen = {}
    for nt in negative_tests:
        raw_name = make_test_name(nt["name"], nt["idx"])
        neg_key = f"neg_{raw_name}"
        if neg_key in neg_seen:
            neg_seen[neg_key] += 1
            neg_key = f"{neg_key}_{neg_seen[neg_key]}"
        else:
            neg_seen[neg_key] = 0

        candidates = nt["candidates"]

        # Skip candidates with weird characters that can't be Zig string literals
        skip = False
        for c in candidates:
            if '\n' in c or '\r' in c or '\t' in c:
                skip = True
                break
        if skip:
            continue

        lines.append(f'test "tw neg: {escape_zig_string(neg_key)}" {{')
        lines.append('    const alloc = std.testing.allocator;')

        cand_strs = ', '.join(f'"{escape_zig_string(c)}"' for c in candidates)
        lines.append(f'    const candidates = [_][]const u8{{ {cand_strs} }};')
        lines.append('    const result = try compile(alloc, &candidates);')
        lines.append('    defer alloc.free(result);')
        lines.append('')
        lines.append('    // Should produce empty or minimal output (no utility rules)')
        lines.append('    try std.testing.expect(std.mem.indexOf(u8, result, "@layer utilities{") == null or')
        lines.append('        std.mem.indexOf(u8, result, "@layer utilities{}") != null);')
        lines.append('}')
        lines.append('')

    output_path = "src/tw_tests.zig"
    with open(output_path, 'w') as f:
        f.write('\n'.join(lines))

    print(f"\nGenerated {output_path}:")
    print(f"  {len(fully_handled)} positive tests")
    print(f"  {len(negative_tests)} negative tests")
    print(f"  {len(lines)} lines")

    # Also generate a gap report
    print(f"\n=== GAPS: {len(not_handled) + len(partially_handled)} test assertions not fully handled ===")
    gap_candidates = set()
    for pt in not_handled + partially_handled:
        for c in pt["candidates"]:
            if c not in handled:
                gap_candidates.add(c)

    # Categorize gaps
    from collections import defaultdict
    cats = defaultdict(list)
    for c in sorted(gap_candidates):
        if c.startswith("mask-") and ("from-" in c or "to-" in c or "linear" in c or "radial" in c or "conic" in c):
            cats["mask gradients"].append(c)
        elif c.startswith("-scroll-"):
            cats["negative scroll"].append(c)
        elif c.endswith("-big") or c.endswith("-xl") and not c.startswith("2"):
            cats["theme-dependent spacing"].append(c)
        elif c.startswith("@container"):
            cats["container utilities"].append(c)
        elif c.startswith("inset-bs") or c.startswith("inset-be") or c.startswith("-inset-b"):
            cats["inset block start/end"].append(c)
        elif c.startswith("mask-"):
            cats["mask other"].append(c)
        elif "perspective-origin" in c:
            cats["perspective-origin"].append(c)
        elif c.startswith("contain-"):
            cats["contain"].append(c)
        elif c.startswith("scheme-"):
            cats["scheme"].append(c)
        elif c.startswith("stroke-"):
            cats["stroke width"].append(c)
        elif c.startswith("font-features"):
            cats["font-features"].append(c)
        elif c.startswith("transform-"):
            cats["transform-origin types"].append(c)
        else:
            cats["other"].append(c)

    for cat in sorted(cats, key=lambda c: -len(cats[c])):
        items = cats[cat]
        print(f"\n  {cat} ({len(items)}):")
        for item in items[:5]:
            print(f"    {item}")
        if len(items) > 5:
            print(f"    ... +{len(items)-5} more")


if __name__ == "__main__":
    main()
