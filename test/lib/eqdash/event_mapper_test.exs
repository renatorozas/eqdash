defmodule Eqdash.EventMapperTest do
  use ExUnit.Case, async: true

  alias Eqdash.EventMapper

  test "when processing a valid usgs response, it returns an array of maps" do
    json_response = File.read!("test/fixtures/usgs/summary/all_hour.json")

    assert EventMapper.from_usgs(json_response) == [
      %{
        alert: nil,
        associated_event_ids: ",nc72602580,",
        cdi: 1,
        code: "72602580",
        detail: "http://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/nc72602580.geojson",
        event_id: "nc72602580",
        latitude: 36.3306656,
        longitude: -120.8953323,
        magnitude: 1.93,
        magnitude_type: "md",
        mmi: nil,
        net: "nc",
        place: "24km ENE of King City, California", sig: 57,
        sources: ",nc,",
        status: "automatic",
        time_local: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 12,
          min: 51,
          sec: 36,
        },
        time_utc: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 20,
          min: 51,
          sec: 36,
        },
        title: "M 1.9 - 24km ENE of King City, California",
        tsunami: false,
        type: "earthquake",
        tz_offset_secs: -28800,
        updated: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 20,
          min: 54,
          sec: 0,
        },
      },
      %{
        alert: nil,
        associated_event_ids: ",ak12947560,",
        cdi: nil,
        code: "12947560",
        detail: "http://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ak12947560.geojson",
        event_id: "ak12947560",
        latitude: 64.9861,
        longitude: -147.3341,
        magnitude: 1.7,
        magnitude_type: "ml",
        mmi: nil,
        net: "ak",
        place: "22km NNE of Badger, Alaska",
        sig: 44,
        sources: ",ak,",
        status: "automatic",
        time_local: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 11,
          min: 2,
          sec: 26,
        },
        time_utc: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 20,
          min: 2,
          sec: 26,
        },
        title: "M 1.7 - 22km NNE of Badger, Alaska",
        tsunami: false,
        type: "earthquake",
        tz_offset_secs: -32400,
        updated: %Ecto.DateTime{
          year: 2016,
          month: 3,
          day: 5,
          hour: 20,
          min: 36,
          sec: 57,
        },
      }
    ]
  end

  test "when processing an empty, it returns an empty array" do
    json_response = File.read!("test/fixtures/usgs/summary/all_hour_empty.json")
    assert EventMapper.from_usgs(json_response) == []
  end
end
