defmodule Eqdash.EventController do
  use Eqdash.Web, :controller

  alias Eqdash.Event

  def index(conn, _params) do
    render conn, "index.html", events: Event.latest(50)
  end
end
