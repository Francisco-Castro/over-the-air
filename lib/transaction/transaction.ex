defmodule OverTheAir.Transaction do

  require Logger
  alias OverTheAir.{Parser, Record, Convert, HTTP, Operation}

  def make(stream) do
    common = stream |> Stream.map(&Parser.line(&1))

    checksum_list =
      common
      |> Stream.map(&Convert.line_to_record/1)
      |> Stream.transform(1, fn %Record{checksum: checksum} = record, acc ->
        raw_record = Convert.record_to_line(record)
        Logger.info("Processing record: #{raw_record}")
        case HTTP.send_chunk(raw_record, Record.encode64(record), times()) do
          :ok -> {[checksum], acc + 1}
          :error -> {:halt, acc}
        end
      end)
      |> Enum.to_list()

    cond do
      Operation.count_records_sent(checksum_list) < Operation.count_records_from_file(common) -> handle_counts()
      true -> handle_checksum_comparison(checksum_list)
    end
  end

  def handle_counts() do
    Logger.error("Halted by too many http attempts.")
    {:error, :to_many_attemps}
  end

  def handle_checksum_comparison(checksum_list) do
    file_checksum = Operation.compute_file_checksum(checksum_list)
    http_checksum = HTTP.send_cheksum()

    if file_checksum == http_checksum do
      {:ok, "Delivery succesfully completed."}
    else
      Logger.error(":mismatch_checksum")
      {:error, :mismatch_checksum}
    end
  end

  defdelegate times(), to: HTTP

end
