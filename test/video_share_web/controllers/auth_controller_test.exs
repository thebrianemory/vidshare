defmodule VideoShareWeb.AuthControllerTest do
  use VideoShareWeb.ConnCase
  alias VideoShare.Repo
  alias VideoShare.User

  @ueberauth_auth %{credentials: %{token: "fdsnoafhnoofh08h38h"},
                    info: %{email: "batman@example.com", name: "Bruce Wayne"},
                    provider: :github}

  test "redirects user to GitHub for authentication", %{conn: conn} do
    conn = get conn, "/auth/github?scope=read%3Auser+user%3Aemail+read%3Aorg"

    assert redirected_to(conn, 302)
  end

  test "creates a user from GitHub's information", %{conn: conn} do
    conn = conn
           |> assign(:ueberauth_auth, @ueberauth_auth)
           |> get("/auth/github/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end
end
