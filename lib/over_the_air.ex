defmodule OverTheAir do

  alias OverTheAir.Process

  defdelegate start(), to: Process

  defdelegate check_device_status(), to: Process

  defdelegate reset_device_status(), to: Process

end
