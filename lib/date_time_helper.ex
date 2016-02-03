defmodule DateTimeHelper do
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  @doc ~S"""
  Computes the date and time from the given number of gregorian seconds.

  Returns a datetime tuple like: {{year, month, day}, {hour, minute, second}}

  ## Examples

    iex> DateTimeHelper.from_timestamp(1454466248)
    {{2016, 2, 3}, {2, 24, 8}}
  """
  def from_timestamp(timestamp) do
    timestamp
    |> +(@epoch)
    |> :calendar.gregorian_seconds_to_datetime
  end

  @doc ~S"""
  Computes the number of gregorian seconds starting with year 0 and
  ending at the given date and time.

  Returns an integer (unix timestamp in seconds).

  ## Examples

    iex> DateTimeHelper.to_timestamp({{2016, 2, 3}, {2, 24, 8}})
    1454466248
  """
  def to_timestamp(datetime) do
    datetime
    |> :calendar.datetime_to_gregorian_seconds
    |> -(@epoch)
  end
end
