defmodule USGS do
  use HTTPoison.Base

  def process_url(url) do
    "http://earthquake.usgs.gov/earthquakes/feed/v1.0" <> url
  end

  def summary(query) do
    endpoint(query) |> USGS.get
  end

  @doc ~S"""
  Returns USGS endpoint id based.

  ## Example

    iex> USGS.endpoint("all_hour")
    "/summary/all_hour.geojson",

    iex> USGS.endpoint("all_day")
    "/summary/all_day.geojson",

    iex> USGS.endpoint("all_week")
    "/summary/all_week.geojson",

    iex> USGS.endpoint("all_month")
    "/summary/all_month.geojson",
  """
  def endpoint(query) do
    case query do
      "all_hour"  -> "/summary/all_hour.geojson"
      "all_day"   -> "/summary/all_day.geojson"
      "all_week"  -> "/summary/all_week.geojson"
      "all_month" -> "/summary/all_month.geojson"
    end
  end
end
