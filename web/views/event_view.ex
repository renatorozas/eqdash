defmodule Eqdash.EventView do
  use Eqdash.Web, :view

  @doc ~S"""
  Return a format a `%Ecto.DateTime{}` record.

  ## Examples

    iex> dt = %Ecto.DateTime{year: 2015, month: 2, day: 2, hour: 13, min: 10, sec: 20}
    #Ecto.DateTime<2015-02-02T13:10:20Z>
    iex> Eqdash.EventView.format_datetime(dt, "{Mshort} {D}, {h12}:{m} {AM}")
    "Feb 2, 1:10 PM"
  """
  def format_datetime(datetime, format_string) do
    datetime
    |> Ecto.DateTime.to_iso8601
    |> Timex.DateFormat.parse!("{ISO}")
    |> Timex.Format.DateTime.Formatter.format!(format_string)
  end
end
