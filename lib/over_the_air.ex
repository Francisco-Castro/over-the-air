defmodule OverTheAir do

  alias OverTheAir.Procs

  defdelegate start(), to: Procs

  defdelegate check_device_status(), to: Procs

  defdelegate reset_device_status(), to: Procs

end
