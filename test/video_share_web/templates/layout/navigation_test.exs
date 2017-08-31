defmodule VideoShareWeb.NavigationTest do
  use VideoShareWeb.ConnCase
  import VideoShare.Factory

  test "shows a sign in with GitHub link when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in with GitHub"
  end

  test "shows a sign out link when signed in", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/")

    assert html_response(conn, 200) =~ "Sign out"
  end

  test "shows a link to the videos index", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "<a class=\"nav-link\" href=\"/videos\">Videos</a>"
  end

  test "shows a link to add video for a signed in user", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/")

    assert html_response(conn, 200) =~ "<a class=\"nav-link\" href=\"/videos/new\">Add Video</a>"
  end
end
