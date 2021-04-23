defmodule OverTheAir.Record do
  @moduledoc """
  Information for one line in an Intel HEX file AKA record
  byte_count (2-hex-digits). Number of bytes in the data. Range from 00 to FF. In this case max is 10.
  address (16-hex-digits). Address Offset.
  record_type (2-hex-digits). 00 is Data. 01 is End of file.
  data. Defined by byte_count
  checksum (2-hex-digits)
  """
  alias OverTheAir.Utils

  defstruct [
    byte_count: [],
    address: [],
    record_type: [],
    data: [],
    checksum: nil
  ]

  def encode64(%__MODULE{byte_count: byte_count, address: address, record_type: record_type, data: data}) do
    [byte_count, address, record_type, data]
    |> List.flatten()
    |> encode_record()
  end

  def build!(string) do
    split_record(string)
  end

  defp encode_record(record) do
    record
    |> Enum.map(&String.to_integer(&1, 16))
    |> :erlang.list_to_binary()
    |> Base.encode64
  end

  defp split_record(<<static_part::bytes-size(8)>> <> dynamic_part) do
    static = split_static(static_part)
    dynamic = dynamic_part |> String.reverse() |> split_dynamic()
    content = Keyword.merge(static, dynamic)
    Kernel.struct(%__MODULE__{}, content)
  end

  defp split_static(<<byte_count::bytes-size(2)>> <> <<address::bytes-size(4)>> <> <<record_type::bytes-size(2)>>) do
    [
      byte_count: [byte_count],
      address: Utils.split_every_two(address),
      record_type: [record_type]
    ]
  end
  defp split_dynamic(<<checksum::bytes-size(2)>> <> data) do
    [
      data: String.reverse(data) |> Utils.split_every_two(),
      checksum: String.reverse(checksum)
    ]
  end

end
