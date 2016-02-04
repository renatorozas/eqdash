defmodule Eqdash.EventView do
  use Eqdash.Web, :view

  def format_datetime(datetime) do
    datetime
    |> DateTimeHelper.format("{Mshort} {D}, {h12}:{m} {AM}")
  end
end
