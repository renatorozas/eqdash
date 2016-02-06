defmodule Eqdash.EventChannel do
  use Phoenix.Channel
  alias Eqdash.{Event,EventView}

  def join("events:index", _message, socket) do
    events = Event.latest(50) |> EventView.decorate_events

    {:ok, %{events: events}, socket}
  end

  def join("events:" <> _private_subtopic_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("events_updates", %{new_events: new_events, updated_events: updated_events}, socket) do
    payload = %{
      new_events: new_events |> EventView.decorate_events,
      updated_events: updated_events |> EventView.decorate_events,
    }

    broadcast! socket, "event_updates", payload

    {:noreply, socket}
  end
end
