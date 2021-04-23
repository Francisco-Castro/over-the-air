defmodule OverTheAir.Operation do
  alias OverTheAir.{Convert, Utils}

  def compute_file_checksum(stream) do
    result = stream
    |> Convert.stream_to_list()
    |> Enum.map(&String.slice(&1, -2..-1))
    |> Enum.map(&Utils.calculate_checksum(&1))
    |> Enum.sum()
    |> rem(256)
    |> Integer.to_string(16)
    |> String.downcase()
    "0x" <> result
  end

  def count_records_from_file(stream) do
    stream
    |> Convert.stream_to_list()
    |> Enum.count()
  end

  def count_records_sent(checksum_list) do
    Enum.count(checksum_list)
  end

end
