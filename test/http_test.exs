defmodule HTTPTest do
  use ExUnit.Case
  alias OverTheAir.HTTP

  describe "send_chunk/1" do
    test "get :error" do
      result = HTTP.send_chunk("_raw_record", "_encoded_data", 0)
      assert result == :error
    end
    test "get :ok" do
      IO.puts("IOU test")
    end
  end

end
