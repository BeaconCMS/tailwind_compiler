candidates =
  "benchmark/class_inventory.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

rounds = String.to_integer(System.get_env("BENCH_ROUNDS") || "10")
preflight = System.get_env("BENCH_PREFLIGHT") != nil

IO.puts("Tailwind Compiler Benchmark")
IO.puts("===========================")
IO.puts("Candidates: #{length(candidates)}")
IO.puts("Rounds:     #{rounds}")
IO.puts("Preflight:  #{preflight}")
IO.puts("")

# Warmup round (ensures NIF is loaded, caches are warm)
{warmup_us, css} = :timer.tc(fn -> TailwindCompiler.compile!(candidates, preflight: preflight) end)
IO.puts("Warmup:     #{Float.round(warmup_us / 1000.0, 2)} ms (#{byte_size(css)} bytes CSS)")
IO.puts("")

# Benchmark rounds
times_us =
  for round <- 1..rounds do
    {time_us, _css} = :timer.tc(fn -> TailwindCompiler.compile!(candidates, preflight: preflight) end)
    IO.puts("  Round #{String.pad_leading(to_string(round), 2)}: #{Float.round(time_us / 1000.0, 2)} ms")
    time_us
  end

times_ms = Enum.map(times_us, &(&1 / 1000.0))
sorted = Enum.sort(times_ms)

avg = Enum.sum(times_ms) / length(times_ms)
min = List.first(sorted)
max = List.last(sorted)
median = Enum.at(sorted, div(length(sorted), 2))

IO.puts("")
IO.puts("Results")
IO.puts("-------")
IO.puts("  Average: #{Float.round(avg, 2)} ms")
IO.puts("  Median:  #{Float.round(median, 2)} ms")
IO.puts("  Min:     #{Float.round(min, 2)} ms")
IO.puts("  Max:     #{Float.round(max, 2)} ms")
IO.puts("  Output:  #{byte_size(css)} bytes")
