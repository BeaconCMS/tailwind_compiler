#!/usr/bin/env python3
"""
Extract ALL test cases from Tailwind CSS v4 test suite into JSON.

Reads these test files:
  - utilities.test.ts (29,982 lines)
  - variants.test.ts (2,651 lines)
  - candidate.test.ts (2,141 lines)
  - important.test.ts (131 lines)
  - sort.test.ts (129 lines)

Outputs: benchmark/results/tw_all_tests.json
"""

import json
import os
import re
import sys
from pathlib import Path

TAILWIND_SRC = "/tmp/tailwindcss-v4/packages/tailwindcss/src"

TEST_FILES = [
    "utilities.test.ts",
    "variants.test.ts",
    "candidate.test.ts",
    "important.test.ts",
    "sort.test.ts",
]

SCRIPT_DIR = Path(__file__).parent
OUTPUT_FILE = SCRIPT_DIR / "results" / "tw_all_tests.json"


def read_file(filename):
    path = os.path.join(TAILWIND_SRC, filename)
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def find_matching_backtick(text, start):
    """Find the closing backtick for a template literal starting at `start`.
    `start` should point to the character AFTER the opening backtick.
    Handles nested ${...} template expressions."""
    i = start
    depth = 0
    while i < len(text):
        ch = text[i]
        if ch == '\\':
            i += 2
            continue
        if ch == '`' and depth == 0:
            return i
        if ch == '$' and i + 1 < len(text) and text[i + 1] == '{':
            depth += 1
            i += 2
            continue
        if ch == '}' and depth > 0:
            depth -= 1
            i += 1
            continue
        i += 1
    return -1


def find_matching_paren(text, start, open_ch='(', close_ch=')'):
    """Find the matching closing delimiter starting at `start`.
    `start` should point to the opening delimiter.
    Handles strings, template literals, and comments."""
    depth = 0
    i = start
    in_string = None
    while i < len(text):
        ch = text[i]
        # Handle escape sequences in strings
        if ch == '\\' and in_string:
            i += 2
            continue
        # Handle single-line comments (only outside strings)
        if ch == '/' and in_string is None and i + 1 < len(text) and text[i + 1] == '/':
            # Skip to end of line
            newline = text.find('\n', i)
            if newline >= 0:
                i = newline + 1
            else:
                i = len(text)
            continue
        # Handle multi-line comments (only outside strings)
        if ch == '/' and in_string is None and i + 1 < len(text) and text[i + 1] == '*':
            end_comment = text.find('*/', i + 2)
            if end_comment >= 0:
                i = end_comment + 2
            else:
                i = len(text)
            continue
        # Template literal handling
        if ch == '`':
            if in_string == '`':
                in_string = None
                i += 1
                continue
            elif in_string is None:
                in_string = '`'
                i += 1
                continue
        # Single/double quote handling
        if ch in ('"', "'"):
            if in_string is None:
                in_string = ch
                i += 1
                continue
            elif ch == in_string:
                in_string = None
                i += 1
                continue
        if in_string:
            i += 1
            continue
        if ch == open_ch:
            depth += 1
        elif ch == close_ch:
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def extract_string_array(text):
    """Extract an array of strings from text like ['a', 'b', "c"]."""
    results = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch in ("'", '"'):
            end = i + 1
            while end < len(text):
                if text[end] == '\\':
                    end += 2
                    continue
                if text[end] == ch:
                    break
                end += 1
            results.append(text[i + 1:end])
            i = end + 1
        elif ch == '`':
            end = find_matching_backtick(text, i + 1)
            if end >= 0:
                results.append(text[i + 1:end])
                i = end + 1
            else:
                i += 1
        else:
            i += 1
    return results


def extract_snapshot_content(text, pos):
    """Extract the content of toMatchInlineSnapshot(`...`) starting
    after the opening paren of toMatchInlineSnapshot(.
    `pos` is right after the '(' of toMatchInlineSnapshot(."""
    # Find the opening backtick
    bt_start = text.find('`', pos)
    if bt_start < 0:
        return None, pos

    bt_end = find_matching_backtick(text, bt_start + 1)
    if bt_end < 0:
        return None, pos

    raw = text[bt_start + 1:bt_end]

    # Dedent the snapshot content
    lines = raw.split('\n')

    # Remove leading/trailing empty lines
    while lines and lines[0].strip() == '':
        lines.pop(0)
    while lines and lines[-1].strip() == '':
        lines.pop()

    if not lines:
        return "", bt_end + 1

    # Find minimum indentation (excluding empty lines)
    min_indent = float('inf')
    for line in lines:
        if line.strip():
            stripped = len(line) - len(line.lstrip())
            min_indent = min(min_indent, stripped)

    if min_indent == float('inf'):
        min_indent = 0

    dedented = '\n'.join(line[min_indent:] if len(line) >= min_indent else line for line in lines)

    # Remove surrounding double quotes if the entire snapshot is a quoted string
    stripped = dedented.strip()
    if stripped.startswith('"') and stripped.endswith('"'):
        stripped = stripped[1:-1]
        dedented = stripped

    return dedented, bt_end + 1


def find_all_test_positions(text):
    """Find all test/it/describe block positions using regex, returning tuples
    of (kind, match_obj, line_start_pos)."""
    results = []

    # Match test(), it(), test.skip(), test.todo(), test.each(), describe()
    # We search for the keyword at any position (not just line start) because
    # tests inside describe blocks are indented.
    pattern = re.compile(
        r'(?:^|\n)([ \t]*)'
        r'(test\.each|test\.skip|test\.todo|test|it\.each|it\.skip|it\.todo|it|describe)'
        r'\s*(\(|\[)',
        re.MULTILINE
    )

    for m in pattern.finditer(text):
        indent = m.group(1)
        kind = m.group(2)
        delim = m.group(3)
        # Position of the keyword
        keyword_start = m.start(2)
        results.append((kind, keyword_start, indent))

    return results


def find_test_blocks(text, filename):
    """Find all test/it blocks and their content."""
    blocks = []
    positions = find_all_test_positions(text)

    # Track describe blocks for nesting context
    describe_stack = []

    i = 0
    while i < len(positions):
        kind, keyword_start, indent = positions[i]

        if kind == 'describe':
            # Find describe name
            paren_pos = text.find('(', keyword_start)
            if paren_pos < 0:
                i += 1
                continue

            # Get name
            name_start = None
            for qi in range(paren_pos + 1, min(paren_pos + 100, len(text))):
                if text[qi] in ("'", '"', '`'):
                    name_start = qi
                    break
            if name_start is None:
                i += 1
                continue

            quote_ch = text[name_start]
            name_end_q = text.index(quote_ch, name_start + 1)
            desc_name = text[name_start + 1:name_end_q]

            # Find the opening brace of the describe callback
            brace_pos = text.find('{', name_end_q)
            if brace_pos >= 0:
                end_brace = find_matching_paren(text, brace_pos, '{', '}')
                if end_brace >= 0:
                    describe_stack.append((desc_name, keyword_start, end_brace))

            i += 1
            continue

        if kind in ('test.each', 'it.each'):
            # test.each([...])('name', fn) or test.each(table)('name', fn)
            paren_or_bracket = text.find('(', keyword_start)
            if paren_or_bracket < 0:
                i += 1
                continue

            # Find end of .each(...)
            each_paren_end = find_matching_paren(text, paren_or_bracket)
            if each_paren_end < 0:
                i += 1
                continue

            each_data = text[paren_or_bracket + 1:each_paren_end]

            # Now find ('name', fn)
            next_paren = text.find('(', each_paren_end + 1)
            if next_paren < 0 or next_paren > each_paren_end + 10:
                i += 1
                continue

            # Get test name
            test_name = "<test.each>"
            for qi in range(next_paren + 1, min(next_paren + 100, len(text))):
                if text[qi] in ("'", '"', '`'):
                    quote_ch = text[qi]
                    end_q = text.index(quote_ch, qi + 1)
                    test_name = text[qi + 1:end_q]
                    break

            # Find the full function body
            fn_paren_end = find_matching_paren(text, next_paren)
            if fn_paren_end < 0:
                i += 1
                continue

            body = text[next_paren:fn_paren_end + 1]

            # Get describe context
            desc_prefix = get_describe_prefix(describe_stack, keyword_start)

            blocks.append({
                "type": "test.each",
                "name": desc_prefix + test_name,
                "body": body,
                "each_data": each_data,
                "start": keyword_start,
                "end": fn_paren_end,
            })
            i += 1
            continue

        # Regular test/it block (possibly with .skip or .todo)
        is_skip = kind.endswith('.skip')
        is_todo = kind.endswith('.todo')
        base_kind = kind.split('.')[0]

        # Find the opening paren
        paren_pos = text.find('(', keyword_start)
        if paren_pos < 0:
            i += 1
            continue

        # Get test name - find the first string literal after (
        test_name = "<unnamed>"
        for qi in range(paren_pos + 1, min(paren_pos + 200, len(text))):
            if text[qi] in (' ', '\t', '\n'):
                continue
            if text[qi] in ("'", '"', '`'):
                quote_ch = text[qi]
                # Find the end of the name string
                end_q = qi + 1
                while end_q < len(text):
                    if text[end_q] == '\\':
                        end_q += 2
                        continue
                    if text[end_q] == quote_ch:
                        break
                    end_q += 1
                test_name = text[qi + 1:end_q]
                break
            break

        # Find the end of the test call
        paren_end = find_matching_paren(text, paren_pos)
        if paren_end < 0:
            i += 1
            continue

        body = text[paren_pos:paren_end + 1]

        # Get describe context
        desc_prefix = get_describe_prefix(describe_stack, keyword_start)

        block_type = "test"
        if is_skip:
            block_type = "test.skip"
        elif is_todo:
            block_type = "test.todo"

        blocks.append({
            "type": block_type,
            "name": desc_prefix + test_name,
            "body": body,
            "start": keyword_start,
            "end": paren_end,
        })
        i += 1

    # Clean up describe stack entries that may overlap
    return blocks


def get_describe_prefix(describe_stack, pos):
    """Get the describe context prefix for a position."""
    prefix = ""
    for desc_name, desc_start, desc_end in describe_stack:
        if desc_start < pos < desc_end:
            prefix = desc_name + " > "
    return prefix


def extract_assertions_from_body(body):
    """Extract positive (snapshot) and negative (toEqual('')) assertions from a test body."""
    positive = []
    negative = []

    pos = 0
    while pos < len(body):
        # Look for `expect(` calls
        expect_idx = body.find('expect(', pos)
        if expect_idx < 0:
            break

        # Find the closing paren of expect(...)
        expect_paren_start = expect_idx + 6
        expect_paren_end = find_matching_paren(body, expect_paren_start)
        if expect_paren_end < 0:
            pos = expect_idx + 7
            continue

        expect_content = body[expect_paren_start + 1:expect_paren_end]

        # After expect(...), look for the chained assertion
        # Skip whitespace and possible ')' from wrapping
        after = body[expect_paren_end + 1:].lstrip()

        # Handle .rejects.toThrowError / .rejects.toThrowErrorMatchingInlineSnapshot
        if after.startswith('.rejects'):
            # Error assertion - capture it
            throw_match = re.search(
                r'\.rejects\s*\.(toThrowError|toThrowErrorMatchingInlineSnapshot)\s*\(',
                after
            )
            if throw_match:
                method_name = throw_match.group(1)
                # Find the absolute position of the opening paren
                offset_to_after = expect_paren_end + 1 + (len(body[expect_paren_end + 1:]) - len(after))
                throw_paren_abs = offset_to_after + throw_match.end() - 1
                if throw_paren_abs >= 0:
                    throw_paren_end = find_matching_paren(body, throw_paren_abs)
                    if throw_paren_end >= 0:
                        error_pattern = body[throw_paren_abs + 1:throw_paren_end].strip()
                        positive.append({
                            "candidates": [],
                            "assertion": f"rejects.{method_name}({error_pattern})",
                            "expect_content": expect_content.strip()[:200],
                        })
                        pos = throw_paren_end + 1
                        continue

            pos = expect_paren_end + 1
            continue

        if after.startswith('.toMatchInlineSnapshot('):
            # Extract candidates from the expect content
            candidates = extract_candidates_from_expect(expect_content)
            css_config = extract_css_config_from_expect(expect_content)

            # Find the snapshot
            snapshot_call_start = body.find('.toMatchInlineSnapshot(', expect_paren_end)
            if snapshot_call_start >= 0:
                inner_start = snapshot_call_start + len('.toMatchInlineSnapshot(')
                css_content, snap_end = extract_snapshot_content(body, inner_start)
                if css_content is not None:
                    entry = {"candidates": candidates, "css": css_content}
                    if css_config:
                        entry["css_config"] = css_config
                    positive.append(entry)
                    pos = snap_end
                    continue

        elif after.startswith('.toEqual('):
            to_equal_start = body.find('.toEqual(', expect_paren_end)
            if to_equal_start >= 0:
                inner_paren_start = to_equal_start + 8
                inner_paren_end = find_matching_paren(body, inner_paren_start)
                if inner_paren_end >= 0:
                    equal_content = body[inner_paren_start + 1:inner_paren_end].strip()
                    candidates = extract_candidates_from_expect(expect_content)

                    if equal_content in ("''", '""', "``"):
                        # Negative test - expects empty string
                        if candidates:
                            negative.append({"candidates": candidates})
                    elif equal_content == '[]':
                        # Negative test - expects empty array
                        if candidates:
                            negative.append({"candidates": candidates})
                    else:
                        entry = {"candidates": candidates, "expected": equal_content}
                        positive.append(entry)
                    pos = inner_paren_end + 1
                    continue

        elif after.startswith('.toBe('):
            to_be_start = body.find('.toBe(', expect_paren_end)
            if to_be_start >= 0:
                inner_paren_start = to_be_start + 5
                inner_paren_end = find_matching_paren(body, inner_paren_start)
                if inner_paren_end >= 0:
                    be_content = body[inner_paren_start + 1:inner_paren_end].strip()
                    positive.append({
                        "candidates": [],
                        "assertion": f"toBe({be_content})",
                        "expect_content": expect_content.strip()[:200],
                    })
                    pos = inner_paren_end + 1
                    continue

        pos = expect_paren_end + 1

    return positive, negative


def extract_candidates_from_expect(expect_content):
    """Extract candidate strings from an expect() content."""
    candidates = []

    # Pattern 1: run(['...', '...']) or run([...])
    run_match = re.search(r'run\s*\(\s*\[', expect_content)
    if run_match:
        bracket_start = expect_content.index('[', run_match.start())
        bracket_end = find_matching_paren(expect_content, bracket_start, '[', ']')
        if bracket_end >= 0:
            array_content = expect_content[bracket_start + 1:bracket_end]
            candidates = extract_string_array(array_content)
            return candidates

    # Pattern 1b: run('single-candidate', ...)
    run_single = re.search(r"run\s*\(\s*['\"]", expect_content)
    if run_single:
        after_run = expect_content[run_single.end() - 1:]
        quote_ch = after_run[0]
        try:
            end_q = after_run.index(quote_ch, 1)
            candidates = [after_run[1:end_q]]
            return candidates
        except ValueError:
            pass

    # Pattern 1c: run(variable, ...) - variable reference
    run_var = re.search(r'run\s*\(\s*(\w+)', expect_content)
    if run_var:
        var_name = run_var.group(1)
        if var_name not in ('await', 'async'):
            candidates = [f"${{{var_name}}}"]
            return candidates

    # Pattern 2: compileCss(..., [...])
    compile_match = re.search(r'compileCss\s*\(', expect_content)
    if compile_match:
        # Find array argument
        bracket_match = re.search(r',\s*\[', expect_content[compile_match.start():])
        if bracket_match:
            abs_start = compile_match.start() + bracket_match.start()
            bracket_start = expect_content.index('[', abs_start)
            bracket_end = find_matching_paren(expect_content, bracket_start, '[', ']')
            if bracket_end >= 0:
                array_content = expect_content[bracket_start + 1:bracket_end]
                candidates = extract_string_array(array_content)
                return candidates

    # Pattern 3: .build(['...']) or build(['...'])
    build_match = re.search(r'\.?build\s*\(\s*\[', expect_content)
    if build_match:
        bracket_start = expect_content.index('[', build_match.start())
        bracket_end = find_matching_paren(expect_content, bracket_start, '[', ']')
        if bracket_end >= 0:
            array_content = expect_content[bracket_start + 1:bracket_end]
            candidates = extract_string_array(array_content)
            return candidates

    # Pattern 4: optimizeCss(compiled).trim()
    if 'optimizeCss' in expect_content or 'compiled' in expect_content:
        return ["<compiled>"]

    # Pattern 5: sortClasses(input, ...)
    sort_match = re.search(r'sortClasses\s*\(\s*(\w+)', expect_content)
    if sort_match:
        return [f"${{{sort_match.group(1)}}}"]

    # Pattern 6: isValidStaticUtilityName(name) or similar
    valid_match = re.search(r'isValid\w+\(\s*(\w+)', expect_content)
    if valid_match:
        return [f"${{{valid_match.group(1)}}}"]

    # Pattern 7: designSystem.printCandidate(parsed)
    if 'printCandidate' in expect_content:
        return ["<printCandidate>"]

    # Pattern 8: compoundsForSelectors(...)
    if 'compoundsForSelectors' in expect_content:
        paren_s = expect_content.find('(')
        paren_e = find_matching_paren(expect_content, paren_s) if paren_s >= 0 else -1
        if paren_e >= 0:
            return [expect_content[paren_s + 1:paren_e].strip()]

    # Pattern 9: compiler.build(...)
    compiler_build = re.search(r'compiler\.build\s*\(\s*\[', expect_content)
    if compiler_build:
        bracket_start = expect_content.index('[', compiler_build.start())
        bracket_end = find_matching_paren(expect_content, bracket_start, '[', ']')
        if bracket_end >= 0:
            array_content = expect_content[bracket_start + 1:bracket_end]
            candidates = extract_string_array(array_content)
            return candidates

    # Pattern 10: output.trim() or similar -- variable-based
    if re.search(r'\w+\.trim\(\)', expect_content):
        return ["<compiled>"]

    return candidates


def extract_css_config_from_expect(expect_content):
    """Extract the CSS config (theme, etc.) from compileCss calls."""
    compile_match = re.search(r'compileCss\s*\(', expect_content)
    if not compile_match:
        return None

    paren_start = expect_content.index('(', compile_match.start())
    after_paren = expect_content[paren_start + 1:].lstrip()

    # css`...` pattern
    css_tag = re.search(r'css\s*`', expect_content[compile_match.start():])
    if css_tag:
        bt_start_abs = compile_match.start() + css_tag.end() - 1
        bt_end = find_matching_backtick(expect_content, bt_start_abs + 1)
        if bt_end >= 0:
            raw_css = expect_content[bt_start_abs + 1:bt_end]
            return dedent_text(raw_css)

    # Simple string argument: '@tailwind utilities;'
    if after_paren and after_paren[0] in ("'", '"'):
        quote_ch = after_paren[0]
        abs_start = paren_start + 1 + (len(expect_content[paren_start + 1:]) - len(after_paren))
        try:
            end_q = expect_content.index(quote_ch, abs_start + 1)
            return expect_content[abs_start + 1:end_q]
        except ValueError:
            pass

    # Backtick without css tag
    if after_paren and after_paren[0] == '`':
        abs_start = paren_start + 1 + (len(expect_content[paren_start + 1:]) - len(after_paren))
        bt_end = find_matching_backtick(expect_content, abs_start + 1)
        if bt_end >= 0:
            return dedent_text(expect_content[abs_start + 1:bt_end])

    return None


def dedent_text(text):
    """Remove common leading whitespace from text."""
    lines = text.split('\n')
    while lines and lines[0].strip() == '':
        lines.pop(0)
    while lines and lines[-1].strip() == '':
        lines.pop()
    if not lines:
        return ""
    min_indent = float('inf')
    for line in lines:
        if line.strip():
            stripped = len(line) - len(line.lstrip())
            min_indent = min(min_indent, stripped)
    if min_indent == float('inf'):
        min_indent = 0
    return '\n'.join(line[min_indent:] if len(line) >= min_indent else line for line in lines)


def parse_each_data(each_data_str, body):
    """Parse the data from test.each([...]) calls."""
    entries = []
    items = extract_string_array(each_data_str)
    if items:
        for i in range(0, len(items) - 1, 2):
            entries.append({
                "candidates": [items[i]],
                "expected": items[i + 1] if i + 1 < len(items) else None,
            })
    return entries


def process_test_file(filename):
    """Process a single test file and return all test cases."""
    text = read_file(filename)
    blocks = find_test_blocks(text, filename)
    results = []

    for block in blocks:
        positive, negative = extract_assertions_from_body(block["body"])

        # For test.each with no direct assertions, try to parse the each data
        if not positive and not negative:
            if block["type"] == "test.each" and block.get("each_data"):
                each_entries = parse_each_data(block["each_data"], block["body"])
                if each_entries:
                    results.append({
                        "source": filename,
                        "name": block["name"],
                        "type": block["type"],
                        "positive": each_entries,
                        "negative": [],
                    })
                    continue

        result = {
            "source": filename,
            "name": block["name"],
            "type": block["type"],
            "positive": positive,
            "negative": negative,
        }

        results.append(result)

    return results


def main():
    all_tests = []
    stats = {
        "total_tests": 0,
        "total_positive": 0,
        "total_negative": 0,
        "by_file": {},
    }

    for filename in TEST_FILES:
        filepath = os.path.join(TAILWIND_SRC, filename)
        if not os.path.exists(filepath):
            print(f"WARNING: {filepath} not found, skipping.")
            continue

        print(f"Processing {filename}...")
        tests = process_test_file(filename)

        file_stats = {
            "tests": len(tests),
            "positive_assertions": sum(len(t["positive"]) for t in tests),
            "negative_assertions": sum(len(t["negative"]) for t in tests),
        }
        stats["by_file"][filename] = file_stats
        stats["total_tests"] += file_stats["tests"]
        stats["total_positive"] += file_stats["positive_assertions"]
        stats["total_negative"] += file_stats["negative_assertions"]

        all_tests.extend(tests)

        print(f"  Found {file_stats['tests']} tests, "
              f"{file_stats['positive_assertions']} positive, "
              f"{file_stats['negative_assertions']} negative assertions")

    # Write output
    os.makedirs(OUTPUT_FILE.parent, exist_ok=True)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(all_tests, f, indent=2, ensure_ascii=False)

    print(f"\n{'=' * 60}")
    print(f"SUMMARY")
    print(f"{'=' * 60}")
    print(f"Output: {OUTPUT_FILE}")
    print(f"Total test blocks: {stats['total_tests']}")
    print(f"Total positive assertions: {stats['total_positive']}")
    print(f"Total negative assertions: {stats['total_negative']}")
    print(f"Total assertions: {stats['total_positive'] + stats['total_negative']}")
    print(f"\nBy file:")
    for fname, fstats in stats["by_file"].items():
        print(f"  {fname}: {fstats['tests']} tests, "
              f"{fstats['positive_assertions']} pos, "
              f"{fstats['negative_assertions']} neg")

    # Print expected vs actual for verification
    expected_counts = {
        "utilities.test.ts": 344,  # 342 test/it + 2 test.each
        "variants.test.ts": 92,   # 91 test/it + 1 test.each
        "candidate.test.ts": 75,  # 72 test/it + 3 test.each (includes 1 test.skip)
        "important.test.ts": 4,
        "sort.test.ts": 4,        # 2 test + 1 test.each + 1 test.skip
    }
    print(f"\nExpected vs Actual:")
    for fname, expected in expected_counts.items():
        actual = stats["by_file"].get(fname, {}).get("tests", 0)
        status = "OK" if actual >= expected else f"MISSING {expected - actual}"
        print(f"  {fname}: expected ~{expected}, got {actual} - {status}")

    # Print sample entries
    print(f"\n{'=' * 60}")
    print(f"SAMPLE ENTRIES (first 3)")
    print(f"{'=' * 60}")
    for entry in all_tests[:3]:
        print(f"\n  Test: {entry['source']} > {entry['name']}")
        if entry['positive']:
            p = entry['positive'][0]
            cands = p.get('candidates', [])
            css_preview = p.get('css', p.get('expected', ''))
            if isinstance(css_preview, str):
                css_preview = css_preview[:120] + '...' if len(css_preview) > 120 else css_preview
            print(f"    Positive: candidates={cands}")
            print(f"    CSS preview: {css_preview}")
        if entry['negative']:
            n = entry['negative'][0]
            print(f"    Negative: candidates={n.get('candidates', [])}")

    return stats


if __name__ == "__main__":
    main()
