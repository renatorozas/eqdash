defmodule Eqdash.Fetcher do
  use GenServer
  import Ecto.Query, only: [from: 2]
  alias Eqdash.{Event, EventView, Repo}

  @usgs_api Application.get_env(:eqdash, :usgs_api)
  @every_thirty_minutes 1000 * 60 * 30

  def start_link do
    GenServer.start_link(__MODULE__, %{fetch_count: 0})
  end

  def init(state) do
    schedule(:fetch, 0)
    {:ok, state}
  end

  def handle_info(:fetch, state) do
    {:ok, response} = @usgs_api.events({:all, :hour})
    response.body
    |> EventMapper.from_usgs
    |> insert_or_update_events

    broadcast

    schedule(:fetch, @every_thirty_minutes)

    {:noreply, %{state | fetch_count: state[:fetch_count] + 1}}
  end

  defp insert_or_update_events(events_params) do
    event_ids = Enum.map(events_params, &(&1.event_id))
    query = from e in Event,
            select: e.event_id,
            where: e.event_id in ^event_ids

    existent_events_ids = Repo.all(query)
    existent_events_params = Enum.filter(
      events_params,
      &(Enum.member?(existent_events_ids, &1.event_id))
    )

    non_existent_events_params = Enum.reject(
      events_params,
      &(Enum.member?(existent_events_ids, &1.event_id))
    )

    %{
      new_events: non_existent_events_params |> create_events,
      updated_events: existent_events_params |> update_events
    }
  end

  defp update_events(events_params) do
    Enum.map(events_params, fn(event_params) ->
      Repo.get_by!(Event, event_id: event_params.event_id)
      |> Event.changeset(event_params)
      |> Repo.update!
    end)
  end

  defp create_events(events_params) do
    Enum.map(events_params, fn(event_params) ->
      %Event{}
      |> Event.changeset(event_params)
      |> Repo.insert!
    end)
  end

  defp broadcast do
    Eqdash.Endpoint.broadcast_from!(
      self,
      "events:index",
      "events_updates",
      %{
        events: Event.latest(50) |> EventView.decorate_events
      }
    )
  end

  defp schedule(task_name, interval) do
    Process.send_after(self, task_name, interval)
  end
end
