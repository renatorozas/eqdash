defmodule Eqdash.EventView do
  use Eqdash.Web, :view


  def decorate_events(events) do
    Enum.map(events, fn(event) ->
      %{event |
        time_local: format_datetime(event.time_local)
      }
    end)
  end

  defp format_datetime(datetime) do
    datetime
    |> DateTimeHelper.format("{Mshort} {D}, {h12}:{m} {AM}")
  end
end
