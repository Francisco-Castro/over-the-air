defmodule OverTheAir.HTTP do
  require Logger
  alias OverTheAir.Utils

  @url Application.get_env(:over_the_air, :url, "http://localhost:3000/")
  @http_options Application.get_env(:over_the_air, :http_options, [{"Content-Type", "application/json"}])

  def send_chunk(_raw_record, _encoded_data, 0), do: :error

  def send_chunk(raw_record, encoded_data, times) do
    response = HTTPoison.post(@url, "CHUNK: " <> "#{encoded_data}", @http_options)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: "OK\n"}} ->
        :ok

      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.warn("#{:error_processing_content} | Attempt(s): #{times() - times + 1} for: #{raw_record}")
        send_chunk(raw_record, encoded_data, times - 1)

      _ ->
        Logger.warn("#{:error_http_request} | Attempt(s): #{times() - times + 1} for: #{raw_record}")
        send_chunk(raw_record, encoded_data, times - 1)
    end
  end

  def send_checksum() do
    response = HTTPoison.post(@url, "CHECKSUM", @http_options)
    handle_checksum_response(response)
  end

  defp handle_checksum_response({:ok, _response = %HTTPoison.Response{body: body}}) do
    body
    |> Utils.remove_carriage_returns()
    |> String.split(" ")
    |> List.last()
  end
  defp handle_checksum_response({:error, _error = %HTTPoison.Error{reason: reason}}) do
    Logger.error("Server/Device is not running. Error: #{reason}")
  end


  def times() do
    Application.get_env(:over_the_air, :times, 10)
  end
end
