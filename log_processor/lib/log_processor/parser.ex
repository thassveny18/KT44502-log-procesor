defmodule LogProcessor.Parser do
  @moduledoc """
  Temporary mock parser to extract levels and messages from string lines
  so Member 2 can test Analyzer and Merger logic.
  """

  def parse(line) do
    cond do
      String.contains?(line, "INFO") -> 
        %{level: :info, message: extract_message(line, "INFO ")}
      String.contains?(line, "WARN") -> 
        %{level: :warn, message: extract_message(line, "WARN ")}
      String.contains?(line, "ERROR") -> 
        %{level: :error, message: extract_message(line, "ERROR ")}
      true -> 
        %{level: :unknown, message: line}
    end
  end

  defp extract_message(line, level_string) do
    [_timestamp, message] = String.split(line, level_string, parts: 2)
    message
  end
end
