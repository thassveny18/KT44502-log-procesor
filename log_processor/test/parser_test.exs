defmodule LogProcessor.ParserTest do
  use ExUnit.Case, async: true
  alias LogProcessor.{Parser, Generator}

  test "parses a well-formed line" do
    assert Parser.parse("2026-10-18 11:30:00 ERROR Database timeout") ==
             %{level: :error, message: "Database timeout"}
  end

  test "malformed line becomes :unknown" do
    assert Parser.parse("garbage").level == :unknown
  end

  test "generator is deterministic and has the requested size" do
    assert Generator.generate(50, 1) == Generator.generate(50, 1)
    assert length(Generator.generate(50, 1)) == 50
    assert Generator.generate(0, 1) == []
  end
end