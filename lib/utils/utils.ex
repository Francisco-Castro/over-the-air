defmodule OverTheAir.Utils do

  def remove_carriage_returns(line) do
    String.replace(line, ~r{(\r\n|\r|\n)}, "")
  end

  def split_every_two(string) when rem(byte_size(string), 2) == 0 do
    for <<x::binary-2 <- string>>, do: x
  end
  def split_every_two(string) do
    {:error, "Error: Invalid split. Check: #{string}"}
  end

  def calculate_checksum(str_hex) do
    str_hex
    |> String.to_integer(16)
    |> Kernel.*(-1)
    |> unsigned()
    |> :binary.decode_unsigned()
  end
  def unsigned(num) do
    <<num :: integer-unsigned-8>>
  end

  def remove_0x(<<_static_part::bytes-size(2)>> <> hex) do
    hex
  end

end
