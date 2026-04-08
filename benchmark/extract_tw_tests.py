#!/usr/bin/env python3
"""
Extract positive candidate→CSS test cases from Tailwind CSS v4 test suite.
Only extracts candidates from assertions that expect non-empty CSS output.
"""
import re
import json

def extract_positive_cases(filepath):
    """Extract test cases where TW expects actual CSS output (not empty string)."""
    with open(filepath) as f:
        content = f.read()

    cases = []

    # Pattern: run([candidates]).toMatchInlineSnapshot(`"CSS..."`)
    # These are the POSITIVE test cases - they expect real CSS output
    pattern = re.compile(
        r"run\(\[([^\]]+)\]\)\s*\)?\s*\.toMatchInlineSnapshot\(\s*`\s*\n(.*?)\s*`\s*\)",
        re.DOTALL
    )

    for m in pattern.finditer(content):
        candidates_raw = m.group(1)
        css_snapshot = m.group(2).strip()

        # Skip empty snapshots
        if not css_snapshot or css_snapshot == '""' or len(css_snapshot.strip('" \n')) < 5:
            continue

        candidates = re.findall(r"'([^']*)'", candidates_raw)
        if not candidates:
            candidates = re.findall(r'"([^"]*)"', candidates_raw)

        if candidates:
            # Clean the CSS: remove outer quotes, unescape
            css = css_snapshot.strip('"').replace('\\n', '\n').strip()
            cases.append({
                'candidates': candidates,
                'css': css,
            })

    # Also match compileCss pattern
    pattern2 = re.compile(
        r"compileCss\([^,]+,\s*\[([^\]]+)\]\)\s*\)?\s*\.toMatchInlineSnapshot\(\s*`\s*\n(.*?)\s*`\s*\)",
        re.DOTALL
    )

    for m in pattern2.finditer(content):
        candidates_raw = m.group(1)
        css_snapshot = m.group(2).strip()
        if not css_snapshot or len(css_snapshot.strip('" \n')) < 5:
            continue
        candidates = re.findall(r"'([^']*)'", candidates_raw)
        if candidates:
            css = css_snapshot.strip('"').replace('\\n', '\n').strip()
            cases.append({'candidates': candidates, 'css': css})

    return cases


def main():
    tw_dir = "/tmp/tailwindcss-v4/packages/tailwindcss/src"

    print("Extracting POSITIVE test cases from Tailwind CSS v4 test suite...")

    util_cases = extract_positive_cases(f"{tw_dir}/utilities.test.ts")
    variant_cases = extract_positive_cases(f"{tw_dir}/variants.test.ts")

    print(f"  utilities.test.ts: {len(util_cases)} positive test cases")
    print(f"  variants.test.ts: {len(variant_cases)} positive test cases")

    all_cases = util_cases + variant_cases
    all_candidates = set()
    for case in all_cases:
        for c in case['candidates']:
            all_candidates.add(c)

    print(f"  Total unique positive candidates: {len(all_candidates)}")

    with open("benchmark/results/tw_test_candidates.txt", 'w') as f:
        for c in sorted(all_candidates):
            f.write(c + '\n')

    with open("benchmark/results/tw_test_cases.json", 'w') as f:
        json.dump(all_cases, f, indent=2)

    print(f"  Written to benchmark/results/tw_test_candidates.txt")
    print(f"  Full cases: benchmark/results/tw_test_cases.json")


if __name__ == "__main__":
    main()
