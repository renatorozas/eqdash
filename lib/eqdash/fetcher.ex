defmodule Eqdash.Fetcher do
  use GenServer

  alias Eqdash.Event
  alias Eqdash.Repo

  @every_thirty_minutes 1000 * 60 * 30

  def start_link do
    GenServer.start_link(__MODULE__, %{fetch_count: 0})
  end

  def init(state) do
    schedule(:fetch, 0)
    {:ok, state}
  end

  def handle_info(:fetch, state) do
    {:ok, response} = USGS.events({:all, :hour})
    events = response.body |> EventMapper.from_usgs

    new_events = upsert_events(events)
    broadcast(new_events)

    schedule(:fetch, @every_thirty_minutes)

    {:noreply, %{state | fetch_count: state[:fetch_count] + 1}}
  end

  # TODO: Update this function to return new_events.
  defp upsert_events(events) do
    Enum.each(events, fn(params) ->
      case Repo.get_by(Event, event_id: params[:event_id]) do
        nil -> %Event{}
        event -> event
      end
      |> Event.changeset(params)
      |> Repo.insert_or_update!
    end)
  end

  defp broadcast(_new_events) do
    Eqdash.Endpoint.broadcast_from!(
      self,
      "events:index",
      "new_events",
      %{events: []}
    )
  end

  defp schedule(task_name, interval) do
    Process.send_after(self, task_name, interval)
  end
end
