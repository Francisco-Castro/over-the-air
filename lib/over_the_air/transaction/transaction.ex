defmodule OverTheAir.Transaction do

  require Logger
  alias OverTheAir.{Parser, Record, Convert, HTTP, Operation, Utils}

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

  def check_device_status() do
    HTTP.send_cheksum()
  end

  def reset_device_status() do
    {status, error_or_chunk} = tranform_checksum()
    if status == :no_needed, do: error_or_chunk, else: do_reset(error_or_chunk)
  end

  defp do_reset(chunk) do
    res = HTTP.send_chunk(":reset_mode", chunk, times())

    case res do
      :ok -> "Reset was done sucessfully"
      :error -> Logger.error("Impossible to reset the server/device state. To many attempts")
    end
  end

  defp tranform_checksum() do
    http_res = HTTP.send_cheksum()

    case http_res do
      "0x0" -> {:no_needed, "Server/device already in default state."}
      _ -> {:ok, handle_checksum(http_res)}
    end
  end

  defp handle_checksum(http_res) do
    processed_http_res =
      http_res
      |> Utils.remove_0x()
      |> String.upcase()
      |> Base.decode16!()
      |> :binary.decode_unsigned()

    (256 - processed_http_res)
    |> Utils.unsigned()
    |> Base.encode64()
  end

  defp handle_counts() do
    Logger.error("Halted by too many http attempts.")
    {:error, :to_many_attemps}
  end

  defp handle_checksum_comparison(checksum_list) do
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
