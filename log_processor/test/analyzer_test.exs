defmodule LogProcessor.AnalyzerTest do
  use ExUnit.Case, async: true
  alias LogProcessor.{Analyzer, Merger}

  @lines [
    "2026-10-18 11:30:00 INFO User login",
    "2026-10-18 11:30:01 ERROR Database timeout",
    "2026-10-18 11:30:02 ERROR Database timeout",
    "2026-10-18 11:30:03 WARN Disk almost full"
  ]

  test "counts levels and errors" do
    result = Analyzer.analyze_chunk(@lines)
    assert result.levels == %{info: 1, error: 2, warn: 1}
    assert result.errors == %{"Database timeout" => 2}
  end

  test "referential transparency: same input, same output" do
    assert Analyzer.analyze_chunk(@lines) == Analyzer.analyze_chunk(@lines)
  end

  test "merge is commutative and has an identity" do
    a = Analyzer.analyze_chunk(Enum.take(@lines, 2))
    b = Analyzer.analyze_chunk(Enum.drop(@lines, 2))
    assert Merger.merge(a, b) == Merger.merge(b, a)
    assert Merger.merge(a, Analyzer.empty()) == a
  end

  test "merging chunks equals analyzing everything at once" do
    a = Analyzer.analyze_chunk(Enum.take(@lines, 2))
    b = Analyzer.analyze_chunk(Enum.drop(@lines, 2))
    assert Merger.merge(a, b) == Analyzer.analyze_chunk(@lines)
  end

  test "top_errors" do
    assert Analyzer.top_errors(Analyzer.analyze_chunk(@lines), 1) == [{"Database timeout", 2}]
  end
end