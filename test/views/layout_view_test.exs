defmodule Vidshare.LayoutViewTest do
  use Vidshare.ConnCase, async: true

  test "Verify navbar is displayed", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<nav class=\"navbar navbar-default\">"
  end

  test "Sign in with Google link shown when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in with Google"
  end

  test "Sign out link shown when signed in", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/")

    assert html_response(conn, 200) =~ "Sign out"
  end
end
