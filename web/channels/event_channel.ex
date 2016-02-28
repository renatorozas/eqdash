defmodule Eqdash.EventChannel do
  use Phoenix.Channel
  alias Eqdash.{Event, EventView}

  def join("events:index", _message, socket) do
    events = Event.latest(50) |> EventView.decorate_events

    {:ok, %{events: events}, socket}
  end

  def join("events:" <> _private_subtopic_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
