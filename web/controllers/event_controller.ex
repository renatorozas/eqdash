defmodule Eqdash.EventController do
  use Eqdash.Web, :controller

  alias Eqdash.Event

  def index(conn, _params) do
    events = Event.latest(100)
    render conn, "index.html", events: events
  end
end
