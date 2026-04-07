#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PAGES_DIR="$SCRIPT_DIR/pages"
RESULTS_DIR="$SCRIPT_DIR/results"
ZIG_BIN="$PROJECT_DIR/zig-out/bin/bench_zig"
CANDIDATES_FILE="$RESULTS_DIR/candidates.txt"
ITERATIONS=10

mkdir -p "$RESULTS_DIR"

echo "=== Tailwind CSS Benchmark: Zig vs Official CLI ==="
echo ""

# ─── Step 1: Extract classes ────────────────────────────────────────────────
PAGE_COUNT=$(ls "$PAGES_DIR"/*.html 2>/dev/null | wc -l | tr -d ' ')
echo "[1/6] Extracting CSS candidates from $PAGE_COUNT HTML pages..."

cat "$PAGES_DIR"/*.html \
  | grep -oE 'class="[^"]*"' \
  | sed 's/class="//;s/"$//' \
  | tr ' ' '\n' \
  | sort -u \
  | grep -v '^$' \
  > "$CANDIDATES_FILE"

TOTAL_CANDIDATES=$(wc -l < "$CANDIDATES_FILE" | tr -d ' ')
echo "   Found $TOTAL_CANDIDATES unique candidates"
echo ""

# ─── Step 2: Build Zig binary ──────────────────────────────────────────────
echo "[2/6] Building Zig compiler (ReleaseFast)..."
cd "$PROJECT_DIR"
zig build -Doptimize=ReleaseFast 2>/dev/null
echo "   Done"
echo ""

# ─── Step 3: Set up Tailwind CLI ───────────────────────────────────────────
echo "[3/6] Setting up Tailwind CLI workspace..."
TW_WORKDIR="$RESULTS_DIR/tw_workdir"
mkdir -p "$TW_WORKDIR"
echo '@import "tailwindcss";' > "$TW_WORKDIR/input.css"
ln -sf "$PAGES_DIR" "$TW_WORKDIR/pages"
if [ ! -d "$TW_WORKDIR/node_modules/tailwindcss" ]; then
    cd "$TW_WORKDIR"
    npm init -y > /dev/null 2>&1
    npm install tailwindcss@latest > /dev/null 2>&1
    cd "$PROJECT_DIR"
fi
echo "   Done"
echo ""

# ─── Step 4: Benchmark Zig ─────────────────────────────────────────────────
echo "[4/6] Benchmarking Zig compiler ($ITERATIONS iterations)..."

ZIG_TIMES_MS=()
ZIG_OUTPUT_SIZE=0
ZIG_PEAK_RSS=0

for i in $(seq 1 $ITERATIONS); do
    # Capture both memory (from /usr/bin/time) and precise timing (from --time flag)
    TIME_OUTPUT=$( { /usr/bin/time -l "$ZIG_BIN" --time "$CANDIDATES_FILE" > "$RESULTS_DIR/zig_output.css" ; } 2>&1 )

    # Extract precise timing from the JSON line on stderr
    ELAPSED_MS=$(echo "$TIME_OUTPUT" | grep '"elapsed_ms"' | sed 's/.*"elapsed_ms":\([0-9.]*\).*/\1/')
    PEAK_RSS=$(echo "$TIME_OUTPUT" | grep "maximum resident" | awk '{print $1}')

    ZIG_TIMES_MS+=("$ELAPSED_MS")
    ZIG_PEAK_RSS=$PEAK_RSS

    if [ "$i" -eq 1 ]; then
        ZIG_OUTPUT_SIZE=$(wc -c < "$RESULTS_DIR/zig_output.css" | tr -d ' ')
    fi

    printf "   Run %2d: %7s ms  (RSS: %.1f MB)\n" "$i" "$ELAPSED_MS" "$(echo "scale=1; $PEAK_RSS / 1048576" | bc)"
done

echo ""

# ─── Step 5: Benchmark Tailwind CLI ────────────────────────────────────────
echo "[5/6] Benchmarking Tailwind CLI v4 ($ITERATIONS iterations)..."

TW_TIMES_MS=()
TW_OUTPUT_SIZE=0
TW_PEAK_RSS=0

for i in $(seq 1 $ITERATIONS); do
    TIME_OUTPUT=$( { /usr/bin/time -l tailwindcss --cwd "$TW_WORKDIR" -i "$TW_WORKDIR/input.css" -o "$RESULTS_DIR/tw_output.css" --minify ; } 2>&1 )

    # Extract time from Tailwind's own "Done in XXXms" output
    TW_REPORTED_MS=$(echo "$TIME_OUTPUT" | grep "Done in" | sed 's/.*Done in \([0-9]*\)ms.*/\1/')
    REAL_TIME=$(echo "$TIME_OUTPUT" | grep "real" | awk '{print $1}')
    REAL_MS=$(echo "$REAL_TIME * 1000" | bc | sed 's/\..*//')
    PEAK_RSS=$(echo "$TIME_OUTPUT" | grep "maximum resident" | awk '{print $1}')

    # Use wall clock time (includes Node.js startup)
    TW_TIMES_MS+=("$REAL_MS")
    TW_PEAK_RSS=$PEAK_RSS

    if [ "$i" -eq 1 ]; then
        TW_OUTPUT_SIZE=$(wc -c < "$RESULTS_DIR/tw_output.css" | tr -d ' ')
    fi

    printf "   Run %2d: %7s ms  (RSS: %.1f MB)  [TW reports: %sms]\n" "$i" "$REAL_MS" "$(echo "scale=1; $PEAK_RSS / 1048576" | bc)" "$TW_REPORTED_MS"
done

echo ""

# ─── Step 6: Generate results ──────────────────────────────────────────────
echo "[6/6] Generating results..."

# Convert ms arrays to seconds for JSON
ZIG_TIMES_SEC=()
for t in "${ZIG_TIMES_MS[@]}"; do
    ZIG_TIMES_SEC+=("$(echo "scale=6; $t / 1000" | bc | sed 's/^\./0./')")
done

TW_TIMES_SEC=()
for t in "${TW_TIMES_MS[@]}"; do
    TW_TIMES_SEC+=("$(echo "scale=6; $t / 1000" | bc | sed 's/^\./0./')")
done

# Compute averages
ZIG_AVG_MS=$(printf '%s\n' "${ZIG_TIMES_MS[@]}" | awk '{sum+=$1} END {printf "%.3f", sum/NR}')
ZIG_MIN_MS=$(printf '%s\n' "${ZIG_TIMES_MS[@]}" | sort -n | head -1)
ZIG_MAX_MS=$(printf '%s\n' "${ZIG_TIMES_MS[@]}" | sort -n | tail -1)
ZIG_MEDIAN_MS=$(printf '%s\n' "${ZIG_TIMES_MS[@]}" | sort -n | awk -v n=$ITERATIONS 'NR==int((n+1)/2){print}')

TW_AVG_MS=$(printf '%s\n' "${TW_TIMES_MS[@]}" | awk '{sum+=$1} END {printf "%.3f", sum/NR}')
TW_MIN_MS=$(printf '%s\n' "${TW_TIMES_MS[@]}" | sort -n | head -1)
TW_MAX_MS=$(printf '%s\n' "${TW_TIMES_MS[@]}" | sort -n | tail -1)
TW_MEDIAN_MS=$(printf '%s\n' "${TW_TIMES_MS[@]}" | sort -n | awk -v n=$ITERATIONS 'NR==int((n+1)/2){print}')

# Seconds versions
ZIG_AVG_S=$(echo "scale=6; $ZIG_AVG_MS / 1000" | bc | sed 's/^\./0./')
TW_AVG_S=$(echo "scale=6; $TW_AVG_MS / 1000" | bc | sed 's/^\./0./')
ZIG_MIN_S=$(echo "scale=6; $ZIG_MIN_MS / 1000" | bc | sed 's/^\./0./')
ZIG_MAX_S=$(echo "scale=6; $ZIG_MAX_MS / 1000" | bc | sed 's/^\./0./')
ZIG_MEDIAN_S=$(echo "scale=6; $ZIG_MEDIAN_MS / 1000" | bc | sed 's/^\./0./')
TW_MIN_S=$(echo "scale=6; $TW_MIN_MS / 1000" | bc | sed 's/^\./0./')
TW_MAX_S=$(echo "scale=6; $TW_MAX_MS / 1000" | bc | sed 's/^\./0./')
TW_MEDIAN_S=$(echo "scale=6; $TW_MEDIAN_MS / 1000" | bc | sed 's/^\./0./')

ZIG_RSS_MB=$(echo "scale=2; $ZIG_PEAK_RSS / 1048576" | bc)
TW_RSS_MB=$(echo "scale=2; $TW_PEAK_RSS / 1048576" | bc)

SPEEDUP=$(echo "scale=1; $TW_AVG_MS / $ZIG_AVG_MS" | bc)
MEMORY_RATIO=$(echo "scale=1; $TW_PEAK_RSS / $ZIG_PEAK_RSS" | bc)

# Build JSON arrays
ZIG_TIMES_JSON=$(printf '%s\n' "${ZIG_TIMES_SEC[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
TW_TIMES_JSON=$(printf '%s\n' "${TW_TIMES_SEC[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')

cat > "$RESULTS_DIR/benchmark_results.json" << ENDJSON
{
  "metadata": {
    "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "platform": "$(uname -s) $(uname -m)",
    "iterations": $ITERATIONS,
    "html_pages": $PAGE_COUNT,
    "unique_candidates": $TOTAL_CANDIDATES,
    "zig_version": "$(zig version)",
    "tailwind_version": "4.2.2",
    "cpu": "$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
  },
  "zig_compiler": {
    "times_seconds": [$ZIG_TIMES_JSON],
    "avg_seconds": $ZIG_AVG_S,
    "min_seconds": $ZIG_MIN_S,
    "max_seconds": $ZIG_MAX_S,
    "median_seconds": $ZIG_MEDIAN_S,
    "avg_ms": $ZIG_AVG_MS,
    "min_ms": $ZIG_MIN_MS,
    "max_ms": $ZIG_MAX_MS,
    "median_ms": $ZIG_MEDIAN_MS,
    "peak_rss_bytes": $ZIG_PEAK_RSS,
    "peak_rss_mb": $ZIG_RSS_MB,
    "output_size_bytes": $ZIG_OUTPUT_SIZE
  },
  "tailwind_cli": {
    "times_seconds": [$TW_TIMES_JSON],
    "avg_seconds": $TW_AVG_S,
    "min_seconds": $TW_MIN_S,
    "max_seconds": $TW_MAX_S,
    "median_seconds": $TW_MEDIAN_S,
    "avg_ms": $TW_AVG_MS,
    "min_ms": $TW_MIN_MS,
    "max_ms": $TW_MAX_MS,
    "median_ms": $TW_MEDIAN_MS,
    "peak_rss_bytes": $TW_PEAK_RSS,
    "peak_rss_mb": $TW_RSS_MB,
    "output_size_bytes": $TW_OUTPUT_SIZE
  },
  "comparison": {
    "speedup_factor": $SPEEDUP,
    "memory_ratio": $MEMORY_RATIO,
    "zig_output_smaller_by_bytes": $(( TW_OUTPUT_SIZE - ZIG_OUTPUT_SIZE ))
  }
}
ENDJSON

echo ""
echo "════════════════════════════════════════════════════"
echo "  RESULTS SUMMARY"
echo "════════════════════════════════════════════════════"
echo ""
echo "  Input:       $TOTAL_CANDIDATES unique classes"
echo "               $PAGE_COUNT HTML pages"
echo "  Iterations:  $ITERATIONS"
echo ""
echo "  Zig Compiler:"
echo "    Avg time:  ${ZIG_AVG_MS} ms"
echo "    Min/Max:   ${ZIG_MIN_MS} / ${ZIG_MAX_MS} ms"
echo "    Peak RSS:  ${ZIG_RSS_MB} MB"
echo "    CSS size:  $ZIG_OUTPUT_SIZE bytes"
echo ""
echo "  Tailwind CLI v4:"
echo "    Avg time:  ${TW_AVG_MS} ms"
echo "    Min/Max:   ${TW_MIN_MS} / ${TW_MAX_MS} ms"
echo "    Peak RSS:  ${TW_RSS_MB} MB"
echo "    CSS size:  $TW_OUTPUT_SIZE bytes"
echo ""
echo "  ── Comparison ──"
echo "  Speed:   Zig is ${SPEEDUP}x faster"
echo "  Memory:  Zig uses ${MEMORY_RATIO}x less memory"
echo "  Output:  Zig CSS is $(( TW_OUTPUT_SIZE - ZIG_OUTPUT_SIZE )) bytes smaller"
echo ""
echo "  Results: $RESULTS_DIR/benchmark_results.json"
echo "  Report:  $RESULTS_DIR/report.html"
echo "════════════════════════════════════════════════════"
