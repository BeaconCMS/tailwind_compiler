#!/usr/bin/env python3
"""
Deep validation: for each candidate, extract the CSS declarations from both
Zig and Tailwind CLI output and compare them.
"""
import re
import json
import sys

def find_rule_for_selector(css, escaped_candidate):
    """Find the CSS rule for a given escaped candidate selector in minified CSS.
    Returns dict of property -> value, or None if not found.
    """
    # Build the selector pattern: .escaped_candidate{...} or .escaped_candidate:pseudo{...}
    # We need to find .SELECTOR{ and then extract until the matching }
    # The selector might be wrapped in @media{.SELECTOR{...}}

    # Escape the candidate for regex
    regex_safe = re.escape(escaped_candidate)

    # Pattern: find the selector anywhere, possibly preceded by @media...{
    # Look for .ESCAPED_CANDIDATE followed by optional pseudo then {
    pattern = re.compile(r'\.(' + regex_safe + r'(?:[^{]*?))\{([^{}]*)\}')

    results = {}
    for m in pattern.finditer(css):
        body = m.group(2)
        for decl in body.split(';'):
            decl = decl.strip()
            if ':' in decl:
                idx = decl.index(':')
                prop = decl[:idx].strip()
                val = decl[idx+1:].strip()
                if val.endswith('!important'):
                    val = val[:-10].strip()
                results[prop] = val

    return results if results else None

def escape_candidate(candidate):
    """Escape a candidate class name for CSS selector matching."""
    result = []
    for i, c in enumerate(candidate):
        special = set(':/.[]#!@%()=,\'">')
        if c in special:
            result.append('\\')
            result.append(c)
        elif i == 0 and c.isdigit():
            result.append(f'\\{ord(c):x} ')
        elif i == 1 and c.isdigit() and candidate[0] == '-':
            result.append(f'\\{ord(c):x} ')
        else:
            result.append(c)
    return ''.join(result)

def main():
    zig_css = open("benchmark/results/zig_output.css").read()
    tw_css = open("benchmark/results/tw_output.css").read()

    with open("benchmark/results/candidates.txt") as f:
        candidates = sorted(set(l.strip() for l in f if l.strip()))

    match = []
    different = []
    tw_only = []
    zig_only = []
    both_skip = []

    for candidate in candidates:
        esc = escape_candidate(candidate)

        zig_decls = find_rule_for_selector(zig_css, esc)
        tw_decls = find_rule_for_selector(tw_css, esc)

        if zig_decls is None and tw_decls is None:
            both_skip.append(candidate)
        elif zig_decls is not None and tw_decls is None:
            zig_only.append(candidate)
        elif zig_decls is None and tw_decls is not None:
            tw_only.append({"candidate": candidate, "tw_css": tw_decls})
        else:
            # Both have output - compare
            # Normalize values
            z = {k: v.strip().rstrip(';') for k, v in zig_decls.items()}
            t = {k: v.strip().rstrip(';') for k, v in tw_decls.items()}

            if z == t:
                match.append(candidate)
            else:
                different.append({
                    "candidate": candidate,
                    "zig": zig_decls,
                    "tw": tw_decls,
                })

    print(f"{'='*70}")
    print(f"DEEP VALIDATION REPORT")
    print(f"{'='*70}")
    print()
    print(f"Total candidates:     {len(candidates)}")
    print(f"Both skip (invalid):  {len(both_skip)}")
    print(f"Identical output:     {len(match)}")
    print(f"Different output:     {len(different)}")
    print(f"Zig only:             {len(zig_only)}")
    print(f"TW only (REAL GAPS):  {len(tw_only)}")

    # Categorize differences
    if different:
        categories = {
            "translate (transform vs translate property)": [],
            "negative rotate (calc vs direct)": [],
            "scale (scale vs --tw-scale)": [],
            "shadow (direct vs composable)": [],
            "ring (direct vs composable)": [],
            "gradient (stops composition)": [],
            "other value difference": [],
            "missing properties": [],
            "extra properties": [],
        }

        for d in different:
            zig = d["zig"]
            tw = d["tw"]
            cand = d["candidate"]

            if "translate" in str(zig) or "translate" in str(tw):
                categories["translate (transform vs translate property)"].append(d)
            elif "rotate" in cand and ("calc(" in str(zig.get("rotate", ""))):
                categories["negative rotate (calc vs direct)"].append(d)
            elif "scale" in cand:
                categories["scale (scale vs --tw-scale)"].append(d)
            elif "shadow" in cand and "box-shadow" in str(tw):
                categories["shadow (direct vs composable)"].append(d)
            elif "ring" in cand:
                categories["ring (direct vs composable)"].append(d)
            elif "from-" in cand or "via-" in cand or "to-" in cand:
                categories["gradient (stops composition)"].append(d)
            else:
                # Check what's actually different
                all_props = set(list(zig.keys()) + list(tw.keys()))
                has_missing = any(p not in zig for p in tw)
                has_extra = any(p not in tw for p in zig)

                if has_missing and has_extra:
                    categories["missing properties"].append(d)
                elif has_missing:
                    categories["missing properties"].append(d)
                elif has_extra:
                    categories["extra properties"].append(d)
                else:
                    categories["other value difference"].append(d)

        print(f"\n{'='*70}")
        print(f"DIFFERENCE BREAKDOWN ({len(different)} total)")
        print(f"{'='*70}")

        for cat, items in sorted(categories.items(), key=lambda x: -len(x[1])):
            if not items:
                continue
            print(f"\n  {cat}: {len(items)}")
            for d in items[:5]:
                print(f"    {d['candidate']}:")
                all_props = sorted(set(list(d['zig'].keys()) + list(d['tw'].keys())))
                for p in all_props:
                    zv = d['zig'].get(p, '---')
                    tv = d['tw'].get(p, '---')
                    if zv != tv:
                        print(f"      {p}: ZIG={zv}  TW={tv}")
            if len(items) > 5:
                print(f"    ... +{len(items)-5} more")

    if tw_only:
        print(f"\n{'='*70}")
        print(f"REAL GAPS: TW generates, Zig doesn't ({len(tw_only)})")
        print(f"{'='*70}")
        for item in tw_only[:30]:
            print(f"  {item['candidate']}: {item['tw_css']}")
        if len(tw_only) > 30:
            print(f"  ... +{len(tw_only)-30} more")

    if zig_only:
        print(f"\n{'='*70}")
        print(f"ZIG ONLY: Zig generates, TW doesn't ({len(zig_only)})")
        print(f"{'='*70}")
        for c in zig_only[:20]:
            print(f"  {c}")
        if len(zig_only) > 20:
            print(f"  ... +{len(zig_only)-20} more")

    # Save
    report = {
        "summary": {
            "total": len(candidates),
            "both_skip": len(both_skip),
            "match": len(match),
            "different": len(different),
            "zig_only": len(zig_only),
            "tw_only": len(tw_only),
        },
        "tw_only": tw_only,
        "different": different[:50],
    }
    with open("benchmark/results/validation_report.json", "w") as f:
        json.dump(report, f, indent=2)

    print(f"\nReport saved to benchmark/results/validation_report.json")

    # Exit code
    if tw_only:
        print(f"\n*** FAIL: {len(tw_only)} candidates generate CSS in TW but not Zig ***")
        sys.exit(1)
    else:
        print(f"\n*** PASS: Zero real gaps ***")

if __name__ == "__main__":
    main()
