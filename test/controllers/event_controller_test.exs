defmodule Eqdash.EventControllerTest do
  use Eqdash.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "eqdash"
  end
end
