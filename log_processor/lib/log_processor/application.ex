defmodule LogProcessor.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [LogProcessor.StatsServer]
    Supervisor.start_link(children, strategy: :one_for_one, name: LogProcessor.Supervisor)
  end
end