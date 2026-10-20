defmodule LogProcessor.StatsServerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias LogProcessor.StatsServer

  test "counts progress messages and can be reset" do
    StatsServer.reset()

    capture_io(fn ->
      StatsServer.chunk_done(1)
      StatsServer.chunk_done(2)
      send(self(), {:total, StatsServer.total()})
    end)

    assert_received {:total, 2}
    assert StatsServer.reset() == :ok
    assert StatsServer.total() == 0
  end
end