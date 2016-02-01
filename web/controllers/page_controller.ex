defmodule Eqdash.PageController do
  use Eqdash.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
