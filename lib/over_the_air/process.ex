defmodule OverTheAir.Process do
  require Logger
  alias OverTheAir.Transaction

  def start(path \\ "../../assets/example.hex") do
    if check_device_status() == "0x0" do
      path
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Transaction.make()
    else
      Logger.error("CHECKSUM NOT 0x0. Please ensure that the server/device is setup to 0x0")
      {:error, :server_shows_not_0x0}
    end
  end

  defdelegate check_device_status, to: Transaction

  defdelegate reset_device_status, to: Transaction

end
