defmodule LogProcessor do
  @moduledoc "Concurrent log processing pipeline."
  alias LogProcessor.{Generator, Analyzer, Merger, StatsServer}

  @doc "Returns {final_result, elapsed_microseconds}. `workers` limits parallelism."
  @spec run(pos_integer(), pos_integer(), pos_integer()) :: {map(), integer()}
  def run(total_lines, chunk_size, workers) do
    lines = Generator.generate(total_lines, 42)
    StatsServer.reset()

    {micros, result} =
      :timer.tc(fn ->
        lines
        |> Enum.chunk_every(chunk_size)
        |> Enum.with_index(1)
        |> Task.async_stream(
          fn {chunk, id} -> process_chunk(chunk, id) end,
          max_concurrency: workers,
          timeout: :infinity
        )
        |> Enum.map(fn {:ok, partial} -> partial end)
        |> Enum.reduce(Analyzer.empty(), fn partial, acc -> Merger.merge(acc, partial) end)
      end)

    {result, micros}
  end

  # Each worker computes a pure result, then reports progress by message.
  defp process_chunk(chunk, id) do
    result = Analyzer.analyze_chunk(chunk)
    StatsServer.chunk_done(id)
    result
  end

  @doc "Runs the pipeline with 1 worker and with all cores, and prints a comparison."
  def demo(total_lines \\ 1_000_000, chunk_size \\ 50_000) do
    cores = System.schedulers_online()
    IO.puts("Processing #{total_lines} lines in chunks of #{chunk_size}. Cores: #{cores}\n")

    results =
      for workers <- Enum.uniq([1, cores]) do
        IO.puts("--- workers = #{workers} ---")
        {result, micros} = run(total_lines, chunk_size, workers)
        IO.puts("Time: #{div(micros, 1000)} ms\n")
        {workers, result, micros}
      end

    {_, final, _} = List.last(results)
    IO.puts("Level counts: #{inspect(final.levels)}")
    IO.puts("Top errors:   #{inspect(Analyzer.top_errors(final, 3))}")
    IO.puts("Chunks reported to StatsServer: #{StatsServer.total()}")
  end
end