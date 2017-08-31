defmodule VideoShareWeb.VideoControllerTest do
  use VideoShareWeb.ConnCase

  import VideoShare.Factory

  alias VideoShare.Videos.Video

  @create_attrs %{video_id: "https://www.youtube.com/watch?v=tMO28ar0lW8"}
  @invalid_attrs %{video_id: ""}

  def fixture(:video) do
    user = insert(:user)
    video = VideoShare.Repo.insert! %Video{
      duration: "PT51M44S",
      thumbnail: "https://i.ytimg.com/vi/tMO28ar0lW8/hqdefault.jpg",
      title: "Lonestar ElixirConf 2017- KEYNOTE: Phoenix 1.3 by Chris McCord",
      video_id: "tMO28ar0lW8",
      view_count: 24054,
      embed: "https://www.youtube.com/embed/tMO28ar0lW8?rel=0",
      user_id: user.id
    }

    {:ok, video: video, user: user}
  end

  describe "index" do
    test "lists all videos", %{conn: conn} do
      conn = get conn, video_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Videos"
    end
  end

  describe "new video" do
    test "renders form", %{conn: conn} do
      conn = get conn, video_path(conn, :new)
      assert html_response(conn, 200) =~ "Add video"
    end
  end

  describe "create video" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = insert(:user)

      conn = conn
      |> assign(:user, user)
      |> post(video_path(conn, :create), video: @create_attrs)

      video = Video |> Ecto.Query.last |> VideoShare.Repo.one
      assert redirected_to(conn) == video_path(conn, :show, video)
      assert get_flash(conn, :info) == "Video created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = insert(:user)

      conn = conn
             |> assign(:user, user)
             |> post(video_path(conn, :create), video: @invalid_attrs)

      assert html_response(conn, 200) =~ "Add video"
    end
  end

  describe "delete video" do
    setup [:create_video]

    test "deletes chosen video", %{conn: conn, video: video} do
      conn = delete conn, video_path(conn, :delete, video)
      assert redirected_to(conn) == video_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, video_path(conn, :show, video)
      end
    end
  end

  defp create_video(_) do
    fixture(:video)
  end
end
