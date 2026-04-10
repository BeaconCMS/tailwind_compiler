candidates_file = "benchmark/class_inventory.txt"
candidates = candidates_file |> File.read!() |> String.split("\n", trim: true)
rounds = String.to_integer(System.get_env("BENCH_ROUNDS") || "10")

# Build the standalone Zig benchmark binary
IO.puts("Building Zig benchmark binary...")

{_, 0} =
  System.cmd("zig", ["build", "-Doptimize=ReleaseFast"],
    stderr_to_stdout: true,
    cd: File.cwd!()
  )

zig_bin = Path.join([File.cwd!(), "zig-out", "bin", "bench_zig"])

IO.puts("")
IO.puts("=" |> String.duplicate(60))
IO.puts("Zig Compiler (pure, no NIF overhead)")
IO.puts("=" |> String.duplicate(60))
IO.puts("Candidates: #{length(candidates)}")
IO.puts("Rounds:     #{rounds}")
IO.puts("")

# Run the Zig binary for each round, capturing timing from stderr
zig_times =
  for round <- 1..rounds do
    timing_file = Path.join(System.tmp_dir!(), "bench_zig_timing_#{round}.json")

    {_output, 0} =
      System.shell(
        "#{zig_bin} --time #{candidates_file} > /dev/null 2> #{timing_file}",
        stderr_to_stdout: true
      )

    timing_json = File.read!(timing_file) |> String.trim()
    File.rm(timing_file)

    timing = Jason.decode!(timing_json)
    elapsed_ms = timing["elapsed_ms"]
    IO.puts("  Round #{String.pad_leading(to_string(round), 2)}: #{elapsed_ms} ms")
    elapsed_ms
  end

zig_sorted = Enum.sort(zig_times)
zig_avg = Enum.sum(zig_times) / length(zig_times)
zig_median = Enum.at(zig_sorted, div(length(zig_sorted), 2))
zig_min = List.first(zig_sorted)
zig_max = List.last(zig_sorted)

# Get output size from one run
{css, 0} = System.cmd(zig_bin, [candidates_file])
zig_output_bytes = byte_size(css)

IO.puts("")
IO.puts("Results")
IO.puts("-------")
IO.puts("  Average: #{Float.round(zig_avg, 3)} ms")
IO.puts("  Median:  #{Float.round(zig_median, 3)} ms")
IO.puts("  Min:     #{Float.round(zig_min, 3)} ms")
IO.puts("  Max:     #{Float.round(zig_max, 3)} ms")
IO.puts("  Output:  #{zig_output_bytes} bytes")

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
    System.cmd("node", [tw_benchmark, candidates_file],
      env: [{"BENCH_ROUNDS", to_string(rounds)}],
      stderr_to_stdout: true
    )

  if exit_code == 0 do
    output
    |> String.split("\n")
    |> Enum.reject(&String.starts_with?(&1, "JSON:"))
    |> Enum.join("\n")
    |> IO.puts()

    json_line = output |> String.split("\n") |> Enum.find(&String.starts_with?(&1, "JSON:"))

    if json_line do
      tw_data = json_line |> String.trim_leading("JSON:") |> Jason.decode!()
      tw_avg = tw_data["avg"]

      IO.puts("")
      IO.puts("=" |> String.duplicate(60))
      IO.puts("Comparison (compile-only, same candidates)")
      IO.puts("=" |> String.duplicate(60))
      IO.puts("")
      IO.puts("  Zig avg:      #{Float.round(zig_avg, 3)} ms")
      IO.puts("  TW v4 avg:    #{Float.round(tw_avg, 2)} ms")
      IO.puts("  Speedup:      #{Float.round(tw_avg / zig_avg, 1)}x faster")
      IO.puts("  Zig output:   #{zig_output_bytes} bytes")
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
