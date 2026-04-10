import { compile } from "tailwindcss";
import { optimize } from "@tailwindcss/node";
import { readFileSync } from "fs";
import { resolve, dirname } from "path";
import { createRequire } from "module";

const require = createRequire(import.meta.url);
const rounds = parseInt(process.env.BENCH_ROUNDS || "10", 10);
const candidatesFile = process.argv[2] || "benchmark/class_inventory.txt";

const candidates = readFileSync(candidatesFile, "utf-8")
  .split("\n")
  .filter((line) => line.trim().length > 0);

// Load theme CSS inline to avoid any filesystem resolution during compile
const themeCssPath = require.resolve("tailwindcss/theme.css");
const themeCss = readFileSync(themeCssPath, "utf-8");

const inputCss = `
@layer theme, base, components, utilities;
@layer theme {
  ${themeCss}
}
@layer utilities { @tailwind utilities; }
`;

// Initialize compiler (one-time setup, excluded from timing)
const compiler = await compile(inputCss);

// Warmup
let css = compiler.build(candidates);
const { code: minifiedCss } = optimize(css, { minify: true });

console.log(`Tailwind CSS v4 Benchmark (compile API)`);
console.log(`========================================`);
console.log(`Candidates: ${candidates.length}`);
console.log(`Rounds:     ${rounds}`);
console.log(``);

const times = [];

for (let i = 1; i <= rounds; i++) {
  // Reset the compiler each round so build() does real work (not cached)
  const freshCompiler = await compile(inputCss);

  const start = performance.now();
  const result = freshCompiler.build(candidates);
  const elapsed = performance.now() - start;

  times.push(elapsed);
  console.log(`  Round ${String(i).padStart(2)}: ${elapsed.toFixed(2)} ms`);
}

times.sort((a, b) => a - b);
const avg = times.reduce((a, b) => a + b, 0) / times.length;
const median = times[Math.floor(times.length / 2)];

console.log(``);
console.log(`Results`);
console.log(`-------`);
console.log(`  Average: ${avg.toFixed(2)} ms`);
console.log(`  Median:  ${median.toFixed(2)} ms`);
console.log(`  Min:     ${times[0].toFixed(2)} ms`);
console.log(`  Max:     ${times[times.length - 1].toFixed(2)} ms`);
console.log(`  Output:  ${minifiedCss.length} bytes (minified)`);

// Output JSON for the Elixir benchmark to consume
console.log(``);
console.log(`JSON:${JSON.stringify({ avg, median, min: times[0], max: times[times.length - 1], output_bytes: minifiedCss.length })}`);
