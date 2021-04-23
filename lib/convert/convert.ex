defmodule OverTheAir.Convert do
  alias OverTheAir.Record

  def line_to_record(line) do
    Record.build!(line)
  end

  def record_to_line(%Record{byte_count: byte_count, address: address, record_type: record_type, data: data, checksum: checksum} = _record) do
    List.flatten([byte_count, address, record_type, data, List.wrap(checksum)]) |> Enum.join("")
  end

  def stream_to_list(stream) do
    Enum.to_list(stream)
  end

end
