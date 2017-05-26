defmodule Vidshare.AuthController do
  use Vidshare.Web, :controller
  plug Ueberauth

  alias Vidshare.User

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, full_name: auth.info.name, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    create(conn, changeset)
  end

  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: video_path(conn,:index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect("/")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
