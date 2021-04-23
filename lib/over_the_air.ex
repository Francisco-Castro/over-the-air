defmodule OverTheAir do

  alias OverTheAir.Process

  defdelegate start(), to: Process

end
