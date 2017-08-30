defmodule VideoShareWeb.NavigationTest do
  use VideoShareWeb.ConnCase

  test "shows a sign in with GitHub link when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in with GitHub"
  end
end
