defmodule LogProcessor.Analyzer do
  @moduledoc "Analyzes a chunk of log lines. Pure: same input, same output."
  alias LogProcessor.Parser

  def empty, do: %{levels: %{}, errors: %{}}

  @spec analyze_chunk([String.t()]) :: %{levels: map(), errors: map()}
  def analyze_chunk(lines) do
    lines
    |> Enum.map(&Parser.parse/1)
    |> Enum.reduce(empty(), &count/2)
  end

  @spec top_errors(map(), pos_integer()) :: [{String.t(), non_neg_integer()}]
  def top_errors(%{errors: errors}, n) do
    errors
    |> Enum.sort_by(fn {message, count} -> {-count, message} end)
    |> Enum.take(n)
  end

  defp count(%{level: level, message: message}, acc) do
    acc = update_in(acc.levels, &bump(&1, level))

    case level do
      :error -> update_in(acc.errors, &bump(&1, message))
      _ -> acc
    end
  end

  defp bump(map, key), do: Map.update(map, key, 1, fn c -> c + 1 end)
end