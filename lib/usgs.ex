defmodule USGS do
  use HTTPoison.Base

  def process_url(url) do
    "http://earthquake.usgs.gov/earthquakes/feed/v1.0" <> url
  end

  def events(query) do
    endpoint(query) |> USGS.get
  end

  @doc ~S"""
  Returns USGS endpoint id based.

  ## Example

    iex> USGS.endpoint({:all, :hour})
    "/summary/all_hour.geojson",

    iex> USGS.endpoint({:all, :day})
    "/summary/all_day.geojson",

    iex> USGS.endpoint({:all, :week})
    "/summary/all_week.geojson",

    iex> USGS.endpoint({:all, :month})
    "/summary/all_month.geojson",
  """
  def endpoint(query) do
    case query do
      {:all, :hour}  -> "/summary/all_hour.geojson"
      {:all, :day}   -> "/summary/all_day.geojson"
      {:all, :week}  -> "/summary/all_week.geojson"
      {:all, :month} -> "/summary/all_month.geojson"
    end
  end
end
