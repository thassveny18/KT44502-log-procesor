defmodule LogProcessorTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias LogProcessor.{Generator, Analyzer}

  test "parallel result equals sequential result" do
    sequential = Generator.generate(5_000, 42) |> Analyzer.analyze_chunk()

    capture_io(fn ->
      {parallel, _time} = LogProcessor.run(5_000, 500, 4)
      send(self(), {:result, parallel})
    end)

    assert_received {:result, parallel}
    assert parallel == sequential
  end

  test "worker count does not change the answer" do
    capture_io(fn ->
      {r1, _} = LogProcessor.run(2_000, 200, 1)
      {r4, _} = LogProcessor.run(2_000, 200, 4)
      send(self(), {:both, r1, r4})
    end)

    assert_received {:both, r1, r4}
    assert r1 == r4
  end
end