defmodule OperationTest do
  use ExUnit.Case
  alias OverTheAir.Operation

  @range 1..10
  @checksum_list ["6A", "48", "38"]

  describe "line_to_record/1" do
    test "take 1" do
      given = @checksum_list |> Enum.take(1)
      result = Operation.compute_file_checksum(given)
      assert result == "0x96"
    end

    test "take 2" do
      given = @checksum_list |> Enum.take(2)
      result = Operation.compute_file_checksum(given)
      assert result == "0x4e"
    end

    test "take 3" do
      given = @checksum_list |> Enum.take(3)
      result = Operation.compute_file_checksum(given)
      assert result == "0x16"
    end
  end

  describe "count_records_from_file/1" do
    test "initial" do
      stream = Stream.map(@range, &(&1))
      result = Operation.count_records_from_file(stream)
      assert result == 10
    end
  end
end
