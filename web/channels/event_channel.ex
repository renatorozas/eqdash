defmodule Eqdash.EventChannel do
  use Phoenix.Channel
  alias Eqdash.{Event,EventView}

  def join("events:index", _message, socket) do
    events = Event.latest(50) |> EventView.decorate_events

    {:ok, %{events: events}, socket}
  end

  def join("events:" <> _private_subtopic_id, _params, socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_out("events_updated", payload, socket) do
    events = payload.events |> EventView.decorate_events

    push socket, "events_updated", %{events: events}

    {:noreply, socket}
  end

  def handle_out("events_added", payload, socket) do
    events = payload.events |> EventView.decorate_events

    push socket, "events_added", %{events: events}

    {:noreply, socket}
  end
end
