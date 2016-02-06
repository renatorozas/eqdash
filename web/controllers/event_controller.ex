defmodule Eqdash.EventController do
  use Eqdash.Web, :controller
  alias Eqdash.{Event, EventView}

  def index(conn, _params) do
    events = Event.latest(50) |> EventView.decorate_events

    render conn, "index.html", events: events
  end
end
