#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="$SCRIPT_DIR/results"
ZIG_BIN="$PROJECT_DIR/zig-out/bin/bench_zig"
GENERATE="$SCRIPT_DIR/generate_pages.py"
ROUNDS=10

mkdir -p "$RESULTS_DIR"

echo "════════════════════════════════════════════════════════════"
echo "  Tailwind CSS Benchmark: Zig vs Official CLI"
echo "  $ROUNDS rounds, each with fresh 100-150 HTML pages"
echo "════════════════════════════════════════════════════════════"
echo ""

# ─── Step 1: Build Zig binary ──────────────────────────────────────────────
echo "[1/4] Building Zig compiler (ReleaseFast)..."
cd "$PROJECT_DIR"
zig build -Doptimize=ReleaseFast 2>/dev/null
echo "   Done"
echo ""

# ─── Step 2: Set up Tailwind CLI ───────────────────────────────────────────
echo "[2/4] Setting up Tailwind CLI workspace..."
TW_WORKDIR="$RESULTS_DIR/tw_workdir"
mkdir -p "$TW_WORKDIR"
echo '@import "tailwindcss";' > "$TW_WORKDIR/input.css"
if [ ! -d "$TW_WORKDIR/node_modules/tailwindcss" ]; then
    cd "$TW_WORKDIR"
    npm init -y > /dev/null 2>&1
    npm install tailwindcss@latest > /dev/null 2>&1
    cd "$PROJECT_DIR"
fi
echo "   Done"
echo ""

# ─── Step 3: Run benchmark rounds ──────────────────────────────────────────
echo "[3/4] Running $ROUNDS benchmark rounds..."
echo ""

ZIG_ALL_MS=()
TW_ALL_MS=()
ZIG_ALL_RSS=()
TW_ALL_RSS=()
ALL_CANDIDATES=()
ALL_PAGES=()

for round in $(seq 1 $ROUNDS); do
    # Random page count between 100-150
    NUM_PAGES=$(( RANDOM % 51 + 100 ))
    SEED=$(( round * 1000 + RANDOM ))

    ROUND_DIR="$RESULTS_DIR/round_${round}"
    PAGES_DIR="$ROUND_DIR/pages"
    CANDIDATES_FILE="$ROUND_DIR/candidates.txt"
    mkdir -p "$ROUND_DIR"

    # Generate fresh pages
    python3 "$GENERATE" --seed "$SEED" --pages "$NUM_PAGES" --output "$PAGES_DIR" > /dev/null

    # Extract candidates
    cat "$PAGES_DIR"/*.html \
      | grep -oE 'class="[^"]*"' \
      | sed 's/class="//;s/"$//' \
      | tr ' ' '\n' \
      | sort -u \
      | grep -v '^$' \
      > "$CANDIDATES_FILE"

    TOTAL_CANDIDATES=$(wc -l < "$CANDIDATES_FILE" | tr -d ' ')
    ALL_CANDIDATES+=("$TOTAL_CANDIDATES")
    ALL_PAGES+=("$NUM_PAGES")

    # ─── Benchmark Zig ─────────────────────────────────────────────────
    ZIG_TIME_OUTPUT=$( { /usr/bin/time -l "$ZIG_BIN" --time "$CANDIDATES_FILE" > "$ROUND_DIR/zig_output.css" ; } 2>&1 )
    ZIG_MS=$(echo "$ZIG_TIME_OUTPUT" | grep '"elapsed_ms"' | sed 's/.*"elapsed_ms":\([0-9.]*\).*/\1/')
    ZIG_RSS=$(echo "$ZIG_TIME_OUTPUT" | grep "maximum resident" | awk '{print $1}')
    ZIG_CSS_SIZE=$(wc -c < "$ROUND_DIR/zig_output.css" | tr -d ' ')

    ZIG_ALL_MS+=("$ZIG_MS")
    ZIG_ALL_RSS+=("$ZIG_RSS")

    # ─── Benchmark Tailwind CLI ────────────────────────────────────────
    # Point TW at this round's pages
    ln -sfn "$PAGES_DIR" "$TW_WORKDIR/pages"

    TW_TIME_OUTPUT=$( { /usr/bin/time -l tailwindcss --cwd "$TW_WORKDIR" -i "$TW_WORKDIR/input.css" -o "$ROUND_DIR/tw_output.css" --minify ; } 2>&1 )
    TW_REAL=$(echo "$TW_TIME_OUTPUT" | grep "real" | awk '{print $1}')
    TW_MS=$(echo "$TW_REAL * 1000" | bc | sed 's/\..*//')
    TW_RSS=$(echo "$TW_TIME_OUTPUT" | grep "maximum resident" | awk '{print $1}')
    TW_CSS_SIZE=$(wc -c < "$ROUND_DIR/tw_output.css" | tr -d ' ')

    TW_ALL_MS+=("$TW_MS")
    TW_ALL_RSS+=("$TW_RSS")

    # Print round results
    ZIG_RSS_MB=$(echo "scale=1; $ZIG_RSS / 1048576" | bc)
    TW_RSS_MB=$(echo "scale=1; $TW_RSS / 1048576" | bc)
    ROUND_SPEEDUP=$(echo "scale=1; $TW_MS / $ZIG_MS" | bc 2>/dev/null || echo "?")

    printf "  Round %2d: %3d pages, %4d classes │ Zig: %6s ms (%4s MB) │ TW: %4s ms (%5s MB) │ %sx faster\n" \
        "$round" "$NUM_PAGES" "$TOTAL_CANDIDATES" "$ZIG_MS" "$ZIG_RSS_MB" "$TW_MS" "$TW_RSS_MB" "$ROUND_SPEEDUP"

    # Clean up pages to save disk
    rm -rf "$PAGES_DIR"
done

echo ""

# ─── Step 4: Compute aggregate stats and generate JSON ─────────────────────
echo "[4/4] Generating results..."

ZIG_AVG_MS=$(printf '%s\n' "${ZIG_ALL_MS[@]}" | awk '{sum+=$1} END {printf "%.3f", sum/NR}')
ZIG_MIN_MS=$(printf '%s\n' "${ZIG_ALL_MS[@]}" | sort -n | head -1)
ZIG_MAX_MS=$(printf '%s\n' "${ZIG_ALL_MS[@]}" | sort -n | tail -1)
ZIG_MEDIAN_MS=$(printf '%s\n' "${ZIG_ALL_MS[@]}" | sort -n | awk -v n=$ROUNDS 'NR==int((n+1)/2){print}')

TW_AVG_MS=$(printf '%s\n' "${TW_ALL_MS[@]}" | awk '{sum+=$1} END {printf "%.3f", sum/NR}')
TW_MIN_MS=$(printf '%s\n' "${TW_ALL_MS[@]}" | sort -n | head -1)
TW_MAX_MS=$(printf '%s\n' "${TW_ALL_MS[@]}" | sort -n | tail -1)
TW_MEDIAN_MS=$(printf '%s\n' "${TW_ALL_MS[@]}" | sort -n | awk -v n=$ROUNDS 'NR==int((n+1)/2){print}')

AVG_CANDIDATES=$(printf '%s\n' "${ALL_CANDIDATES[@]}" | awk '{sum+=$1} END {printf "%d", sum/NR}')
AVG_PAGES=$(printf '%s\n' "${ALL_PAGES[@]}" | awk '{sum+=$1} END {printf "%d", sum/NR}')

ZIG_AVG_RSS=$(printf '%s\n' "${ZIG_ALL_RSS[@]}" | awk '{sum+=$1} END {printf "%d", sum/NR}')
TW_AVG_RSS=$(printf '%s\n' "${TW_ALL_RSS[@]}" | awk '{sum+=$1} END {printf "%d", sum/NR}')
ZIG_RSS_MB=$(echo "scale=2; $ZIG_AVG_RSS / 1048576" | bc)
TW_RSS_MB=$(echo "scale=2; $TW_AVG_RSS / 1048576" | bc)

SPEEDUP=$(echo "scale=1; $TW_AVG_MS / $ZIG_AVG_MS" | bc)
MEMORY_RATIO=$(echo "scale=1; $TW_AVG_RSS / $ZIG_AVG_RSS" | bc)

# Build JSON arrays
ZIG_TIMES_JSON=$(printf '%s\n' "${ZIG_ALL_MS[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
TW_TIMES_JSON=$(printf '%s\n' "${TW_ALL_MS[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
ZIG_RSS_JSON=$(printf '%s\n' "${ZIG_ALL_RSS[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
TW_RSS_JSON=$(printf '%s\n' "${TW_ALL_RSS[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
CANDIDATES_JSON=$(printf '%s\n' "${ALL_CANDIDATES[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')
PAGES_JSON=$(printf '%s\n' "${ALL_PAGES[@]}" | awk '{printf "%s%s", (NR>1?",":""), $1}')

cat > "$RESULTS_DIR/benchmark_results.json" << ENDJSON
{
  "metadata": {
    "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "platform": "$(uname -s) $(uname -m)",
    "rounds": $ROUNDS,
    "pages_per_round": [$PAGES_JSON],
    "candidates_per_round": [$CANDIDATES_JSON],
    "avg_pages": $AVG_PAGES,
    "avg_candidates": $AVG_CANDIDATES,
    "zig_version": "$(zig version)",
    "tailwind_version": "4.2.2",
    "cpu": "$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
  },
  "zig_compiler": {
    "times_ms": [$ZIG_TIMES_JSON],
    "avg_ms": $ZIG_AVG_MS,
    "min_ms": $ZIG_MIN_MS,
    "max_ms": $ZIG_MAX_MS,
    "median_ms": $ZIG_MEDIAN_MS,
    "rss_bytes_per_round": [$ZIG_RSS_JSON],
    "avg_rss_bytes": $ZIG_AVG_RSS,
    "avg_rss_mb": $ZIG_RSS_MB
  },
  "tailwind_cli": {
    "times_ms": [$TW_TIMES_JSON],
    "avg_ms": $TW_AVG_MS,
    "min_ms": $TW_MIN_MS,
    "max_ms": $TW_MAX_MS,
    "median_ms": $TW_MEDIAN_MS,
    "rss_bytes_per_round": [$TW_RSS_JSON],
    "avg_rss_bytes": $TW_AVG_RSS,
    "avg_rss_mb": $TW_RSS_MB
  },
  "comparison": {
    "speedup_factor": $SPEEDUP,
    "memory_ratio": $MEMORY_RATIO
  }
}
ENDJSON

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  RESULTS"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "  $ROUNDS rounds × ~${AVG_PAGES} pages × ~${AVG_CANDIDATES} classes"
echo ""
echo "  Zig Compiler"
echo "    Avg:    ${ZIG_AVG_MS} ms"
echo "    Range:  ${ZIG_MIN_MS} – ${ZIG_MAX_MS} ms"
echo "    Memory: ${ZIG_RSS_MB} MB"
echo ""
echo "  Tailwind CLI v4.2.2"
echo "    Avg:    ${TW_AVG_MS} ms"
echo "    Range:  ${TW_MIN_MS} – ${TW_MAX_MS} ms"
echo "    Memory: ${TW_RSS_MB} MB"
echo ""
echo "  Zig is ${SPEEDUP}x faster, ${MEMORY_RATIO}x less memory"
echo ""
echo "  → ${RESULTS_DIR}/benchmark_results.json"
echo "  → ${RESULTS_DIR}/report.html"
echo "════════════════════════════════════════════════════════════"

# Clean up round dirs
for round in $(seq 1 $ROUNDS); do
    rm -rf "$RESULTS_DIR/round_${round}"
done
