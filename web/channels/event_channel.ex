defmodule Eqdash.EventChannel do
  use Phoenix.Channel

  alias Eqdash.Event
  alias Eqdash.Repo

  def join("events:index", _message, socket) do
    events = Event.latest(100)

    {:ok, %{events: events}, socket}
  end

  def join("events:" <> _private_subtopic_id, _params, socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
