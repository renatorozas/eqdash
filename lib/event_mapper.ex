defmodule EventMapper do
  @doc ~S"""
  Process and map a list of USGS events into a list of Eqdash.Event.
  """
  def from_usgs(body) do
    body
    |> Poison.decode!
    |> Dict.get("features")
    |> Enum.map(&to_event/1)
  end

  @doc ~S"""
  Process a USGS event into a Eqdash.Event.
  """
  def to_event(data) do
    %{
      alert: data["properties"]["alert"],
      associated_event_ids: data["properties"]["ids"],
      cdi: data["properties"]["cdi"],
      code: data["properties"]["code"],
      detail: data["properties"]["detail"],
      event_id: data["id"],
      latitude: latitude(data),
      longitude: longitude(data),
      magnitude: data["properties"]["mag"],
      magnitude_type: data["properties"]["magType"],
      mmi: data["properties"]["mmi"],
      net: data["properties"]["net"],
      place: data["properties"]["place"],
      sig: data["properties"]["sig"],
      sources: data["properties"]["sources"],
      status: data["properties"]["status"],
      time_local: time_local(data),
      time_utc: time_utc(data),
      tsunami: tsunami(data),
      type: data["properties"]["type"],
      tz_offset_secs: tz_offset_secs(data),
      updated: updated(data),
    }
  end

  defp time_utc(data) do
    round(data["properties"]["time"]/1000)
    |> DateTimeHelper.from_timestamp
    |> Ecto.DateTime.from_erl
  end

  defp time_local(data) do
    round(data["properties"]["time"]/1000)
    |> +tz_offset_secs(data)
    |> DateTimeHelper.from_timestamp
    |> Ecto.DateTime.from_erl
  end

  defp tz_offset_secs(data) do
    data["properties"]["tz"] * 60
  end

  defp updated(data) do
    round(data["properties"]["updated"]/1000)
    |> DateTimeHelper.from_timestamp
    |> Ecto.DateTime.from_erl
  end

  defp latitude(data) do
    Enum.at(data["geometry"]["coordinates"], 1, nil)
  end

  defp longitude(data) do
    Enum.at(data["geometry"]["coordinates"], 0, nil)
  end

  defp tsunami(data) do
    if data["properties"]["tsunami"] == 1 do
      true
    else
      false
    end
  end
end
