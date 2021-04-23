defmodule OverTheAir.Common.ReturnOkOr do
  require Logger

  def return_ok_or(:error, message) do
    Logger.error("#{inspect(message)}")
    {:error, message}
  end

  def return_ok_or(item, _message) when item != nil do
    {:ok, item}
  end

  def return_ok_or(item, message) when item == nil do
    Logger.error("#{inspect(message)}")
    {:error, message}
  end

end
