defmodule OverTheAir.Parser do
  alias OverTheAir.Utils
  # import OverTheAir.Common.ReturnOkOr

  def line(line) do
    line
    |> Utils.remove_carriage_returns()
    |> colon!()
  end

  defp colon!(":" <> rest) do
    rest
  end
  defp colon!(_line) do
    :error
  end

  # Future use for handle errors while parsing the line
  # defp colon(line) do
    # colon!(line) |> return_ok_or("Error parsing colon for: #{line}")
  # end

  # def check_min_lenght(record, length \\ 10)
  # def check_min_lenght(record, length) when byte_size(record) >= length do
  #   {:ok, record}
  # end
  # def check_min_lenght(record, _length) do
  #   {:error, "Error: Record #{record}. Size is not correct."}
  # end
end
