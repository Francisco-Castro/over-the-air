defmodule UtilsTest do
  use ExUnit.Case
  alias OverTheAir.Utils

  @set_of_n List.duplicate("\n", 5)
  @set_of_r List.duplicate("\r", 5)
  @datum "00FF"
  @range 1..255

  describe "remove_carriage_returns" do
    test "remove \n" do
      given = @datum <> (@set_of_n |> Enum.join(""))
      result = Utils.remove_carriage_returns(given)
      assert result == @datum
    end

    test "remove \r" do
      given = @datum <> (@set_of_r |> Enum.join(""))
      result = Utils.remove_carriage_returns(given)
      assert result == @datum
    end

    test "remove random both" do
      given = @datum <> ((@set_of_r ++ @set_of_r) |> Enum.take_random(5) |> Enum.join(""))
      result = Utils.remove_carriage_returns(given)
      assert result == @datum
    end
  end

  describe "split_every_two" do
    test "even" do
      result = Utils.split_every_two(@datum)
      assert result == ["00", "FF"]
    end

    test "odd - error" do
      {atom, _} = result = Utils.split_every_two(@datum <> "A")
      assert atom == :error
    end
  end

  describe "calculate_checksum" do
    test "01..FF" do
      result =
        @range
        |> Enum.map(&Integer.to_string(&1, 16))
        |> Enum.map(&Utils.calculate_checksum(&1))

      assert result == @range |> Enum.to_list() |> Enum.reverse()
    end

    test "00" do
      given = "00"
      result = Utils.calculate_checksum(given)
      assert result == 0
    end
  end
end
