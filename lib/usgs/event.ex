defmodule USGS.Event do
  def fetch!(:all_hour) do
    USGS.get!("/summary/all_hour.geojson").body
    |> Poison.decode!
    |> Dict.get("features")
    |> Enum.map(&USGS.Event.changeset/1)
  end

  def changeset(data) do
    %{
      alert: data["properties"]["alert"],
      cdi: data["properties"]["cdi"],
      code: data["properties"]["code"],
      detail: data["properties"]["detail"],
      event_id: data["id"],
      associated_event_ids: data["properties"]["ids"],
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
      time: time(data),
      tsunami: tsunami(data),
      type: data["properties"]["type"],
      tz: data["properties"]["tz"],
      updated: updated(data),
    }
  end

  defp time(data) do
    round(data["properties"]["time"]/1000)
    |> DateTimeHelper.from_timestamp
    |> Ecto.DateTime.from_erl
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
