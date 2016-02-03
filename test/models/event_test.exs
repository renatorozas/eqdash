defmodule Eqdash.EventTest do
  use Eqdash.ModelCase

  alias Eqdash.{Event, Repo}

  @valid_attrs %{
    alert: "some content",
    associated_event_ids: "some content",
    cdi: "120.5",
    code: "some content",
    detail: "some content",
    event_id: "some content",
    latitude: "120.5",
    longitude: "120.5",
    magnitude: "120.5",
    magnitude_type: "some content",
    mmi: "120.5",
    net: "some content",
    place: "some content",
    sig: 42,
    sources: "some content",
    status: "some content",
    time: "2010-04-17 14:00:00",
    tsunami: true,
    type: "some content",
    tz: 42,
    updated: "2010-04-17 14:00:00"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end

  # TODO: Make this more readable.
  test "latest X events order by :time" do
    assert Event.latest(2) == []

    event = %Event{
      code: "code",
      event_id: "event_id"
    }

    datetime = %Ecto.DateTime{
      year: 2015, month: 2, day: 1,
      hour: 16, min: 0, sec: 0
    }

    Repo.insert!(%Event{event | time: datetime})

    latest_by_time = [
      Repo.insert!(%Event{event | time: %Ecto.DateTime{datetime | day: 3}}),
      Repo.insert!(%Event{event | time: %Ecto.DateTime{datetime | day: 2}})
    ]

    assert Event.latest(2) == latest_by_time
  end
end
