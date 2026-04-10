candidates =
  "benchmark/class_inventory.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

rounds = String.to_integer(System.get_env("BENCH_ROUNDS") || "10")
preflight = System.get_env("BENCH_PREFLIGHT") != nil

IO.puts("=" |> String.duplicate(60))
IO.puts("Tailwind Compiler NIF (Zig)")
IO.puts("=" |> String.duplicate(60))
IO.puts("Candidates: #{length(candidates)}")
IO.puts("Rounds:     #{rounds}")
IO.puts("Preflight:  #{preflight}")
IO.puts("")

# Warmup round (ensures NIF is loaded)
{_warmup_us, css} = :timer.tc(fn -> TailwindCompiler.compile!(candidates, preflight: preflight) end)

# Benchmark rounds
nif_times_us =
  for round <- 1..rounds do
    {time_us, _css} = :timer.tc(fn -> TailwindCompiler.compile!(candidates, preflight: preflight) end)
    IO.puts("  Round #{String.pad_leading(to_string(round), 2)}: #{Float.round(time_us / 1000.0, 2)} ms")
    time_us
  end

nif_times = Enum.map(nif_times_us, &(&1 / 1000.0))
nif_sorted = Enum.sort(nif_times)

nif_avg = Enum.sum(nif_times) / length(nif_times)
nif_median = Enum.at(nif_sorted, div(length(nif_sorted), 2))
nif_min = List.first(nif_sorted)
nif_max = List.last(nif_sorted)

IO.puts("")
IO.puts("Results")
IO.puts("-------")
IO.puts("  Average: #{Float.round(nif_avg, 2)} ms")
IO.puts("  Median:  #{Float.round(nif_median, 2)} ms")
IO.puts("  Min:     #{Float.round(nif_min, 2)} ms")
IO.puts("  Max:     #{Float.round(nif_max, 2)} ms")
IO.puts("  Output:  #{byte_size(css)} bytes")

# Run Tailwind CSS v4 compile API benchmark if node_modules exists
tw_benchmark = Path.join("benchmark", "bench_tailwind.mjs")
node_modules = Path.join("benchmark", "node_modules")

if File.exists?(tw_benchmark) and File.dir?(node_modules) do
  IO.puts("")
  IO.puts("=" |> String.duplicate(60))
  IO.puts("Tailwind CSS v4 (JS compile API)")
  IO.puts("=" |> String.duplicate(60))
  IO.puts("")

  {output, exit_code} =
    System.cmd("node", [tw_benchmark, "benchmark/class_inventory.txt"],
      env: [{"BENCH_ROUNDS", to_string(rounds)}],
      stderr_to_stdout: true
    )

  if exit_code == 0 do
    # Print all lines except the JSON line
    output
    |> String.split("\n")
    |> Enum.reject(&String.starts_with?(&1, "JSON:"))
    |> Enum.join("\n")
    |> IO.puts()

    # Parse the JSON line for comparison
    json_line = output |> String.split("\n") |> Enum.find(&String.starts_with?(&1, "JSON:"))

    if json_line do
      tw_data = json_line |> String.trim_leading("JSON:") |> Jason.decode!()
      tw_avg = tw_data["avg"]

      IO.puts("")
      IO.puts("=" |> String.duplicate(60))
      IO.puts("Comparison (compile-only, same candidates)")
      IO.puts("=" |> String.duplicate(60))
      IO.puts("")
      IO.puts("  NIF avg:      #{Float.round(nif_avg, 2)} ms")
      IO.puts("  TW v4 avg:    #{Float.round(tw_avg, 2)} ms")
      IO.puts("  Speedup:      #{Float.round(tw_avg / nif_avg, 1)}x faster")
      IO.puts("  NIF output:   #{byte_size(css)} bytes")
      IO.puts("  TW v4 output: #{tw_data["output_bytes"]} bytes")
    end
  else
    IO.puts("Tailwind benchmark failed:")
    IO.puts(output)
  end
else
  IO.puts("")
  IO.puts("Skipping Tailwind CSS v4 comparison (run `npm install` in benchmark/)")
end
