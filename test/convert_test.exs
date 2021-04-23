defmodule ConvertTest do
  use ExUnit.Case
  alias OverTheAir.{Convert, Record}

  @range 1..10
  @line "100000000C9434000C9446000C9446000C9446006A"
  @record %Record{
    address: ["00", "00"],
    byte_count: ["10"],
    checksum: "6A",
    data: ["0C", "94", "34", "00", "0C", "94", "46", "00", "0C", "94", "46", "00", "0C", "94", "46", "00"],
    record_type: ["00"]
  }

  describe "line_to_record/1" do
    test "initial" do
      result = Convert.line_to_record(@line)
      assert result == @record
    end
  end

  describe "record_to_line/1" do
    test "initial" do
      result = Convert.record_to_line(@record)
      assert result == @line
    end
  end

  describe "stream_to_list/1" do
    test "initial" do
      stream = Stream.map(@range, &(&1))
      result = Convert.stream_to_list(stream)
      assert result == Enum.to_list(@range)
    end
  end
end
