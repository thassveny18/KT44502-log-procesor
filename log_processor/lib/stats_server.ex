defmodule LogProcessor.StatsServer do
  @moduledoc "Actor that owns the progress counter. Workers talk to it only by messages."
  use GenServer

  # Client API
  def start_link(_opts), do: GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  def chunk_done(chunk_id), do: GenServer.cast(__MODULE__, {:chunk_done, chunk_id})
  def total, do: GenServer.call(__MODULE__, :total)
  def reset, do: GenServer.call(__MODULE__, :reset)

  # Server callbacks: the state is a private integer, no shared memory
  @impl true
  def init(count), do: {:ok, count}

  @impl true
  def handle_cast({:chunk_done, chunk_id}, count) do
    new_count = count + 1
    IO.puts("  chunk ##{chunk_id} done (#{new_count} finished)")
    {:noreply, new_count}
  end

  @impl true
  def handle_call(:total, _from, count), do: {:reply, count, count}
  def handle_call(:reset, _from, _count), do: {:reply, :ok, 0}
end