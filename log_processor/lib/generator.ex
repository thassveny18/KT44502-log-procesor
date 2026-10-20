defmodule LogProcessor.Generator do 
  @moduledoc "Creates sample log lines. The same seed always gives the same lines."

  @levels ["INFO", "WARN", "ERROR"] 
  @messages ["Database timeout", "User login", "Disk almost full", "Payment failed", "Cache miss"]

  @spec generate(non_neg_integer(), integer()) :: [String.t()] 
  def generate(count, seed) do 
    # The random state is passed along explicitly, so nothing is mutated. 
    state = :rand.seed_s(:exsss, {seed, seed, seed})

    {lines, _final_state} =
      Enum.map_reduce(1..count//1, state, fn i, st ->
        {level_idx, st} = :rand.uniform_s(length(@levels), st)
        {msg_idx, st} = :rand.uniform_s(length(@messages), st)
        level = Enum.at(@levels, level_idx - 1)
        message = Enum.at(@messages, msg_idx - 1)
        {format_line(i, level, message), st}
      end)

    lines
  end

  defp format_line(i, level, message) do 
    h = pad(rem(div(i, 3600), 24)) 
    m = pad(rem(div(i, 60), 60)) 
    s = pad(rem(i, 60)) 
    "2026-10-18 #{h}:#{m}:#{s} #{level} #{message}" 
  end

  defp pad(n) do 
    n |> Integer.to_string() |> String.pad_leading(2, "0") 
  end
end