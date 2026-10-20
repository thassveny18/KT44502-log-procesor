defmodule LogProcessor.Merger do
  @moduledoc "Combines two partial results into one. Pure function."

  @spec merge(map(), map()) :: map()
  def merge(a, b) do
    %{levels: sum(a.levels, b.levels), errors: sum(a.errors, b.errors)}
  end

  defp sum(x, y), do: Map.merge(x, y, fn _key, v1, v2 -> v1 + v2 end)
end