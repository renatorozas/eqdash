defmodule Eqdash.EventView do
  use Eqdash.Web, :view

  def decorate_events(events) do
    Enum.map(events, fn(event) ->
      %{
        id: event.event_id,
        title: event.title,
        time: format_datetime(event.time_local),
        magnitude: event_magnitude(event),
        location: %{
          latitude: event.latitude,
          longitude: event.longitude
        }
      }
    end)
  end

  defp format_datetime(datetime) do
    datetime
    |> DateTimeHelper.format("{Mshort} {D}, {h12}:{m} {AM}")
  end

  defp event_magnitude(event) do
    "#{event.magnitude} (#{event.magnitude_type})"
  end
end
