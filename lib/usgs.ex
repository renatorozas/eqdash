defmodule USGS do
  use HTTPoison.Base

  def process_url(url) do
    "http://earthquake.usgs.gov/earthquakes/feed/v1.0" <> url
  end
end
