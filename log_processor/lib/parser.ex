defmodule LogProcessor.Parser do
  @moduledoc "Parses one log line into a map. Pure function."

  @spec parse(String.t()) :: %{level: atom(), message: String.t()}
  def parse(line) do
    case String.split(line, " ", parts: 4) do
      [_date, _time, level, message] -> %{level: level_atom(level), message: message}
      _ -> %{level: :unknown, message: line}
    end
  end

  defp level_atom("INFO"), do: :info
  defp level_atom("WARN"), do: :warn
  defp level_atom("ERROR"), do: :error
  defp level_atom(_), do: :unknown
end