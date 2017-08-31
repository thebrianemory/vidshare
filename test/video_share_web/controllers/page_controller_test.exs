defmodule VideoShareWeb.PageControllerTest do
  use VideoShareWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to VideoShare!"
  end
end
