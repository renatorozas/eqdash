defmodule Eqdash.EventChannel do
  use Phoenix.Channel

  alias Eqdash.Event
  alias Eqdash.EventView

  def join("events:index", _message, socket) do
    events = Event.latest(50)
    |> Enum.map(fn(e) ->
      %{e | time_local: EventView.format_datetime(e.time_local)}
    end)
    {:ok, %{events: events}, socket}
  end

  def join("events:" <> _private_subtopic_id, _params, socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
