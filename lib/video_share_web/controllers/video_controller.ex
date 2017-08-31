defmodule VideoShareWeb.VideoController do
  use VideoShareWeb, :controller

  alias VideoShare.Videos
  alias VideoShare.Videos.{Video, YoutubeData}

  def index(conn, _params) do
    videos = Videos.list_videos()
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = Videos.change_video(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    case has_valid_regex?(video_params) do
      nil ->
        changeset = Video.changeset(%Video{}, video_params)

        conn
        |> put_flash(:error, "Invalid URL")
        |> render("new.html", changeset: changeset)
      regex ->
        youtube_or_vimeo?(conn, regex)
    end
  end

  def show(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def delete(conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp has_valid_regex?(video_params) do
    Regex.run(~r{^.*((youtu.be\/|vimeo.com\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*}, video_params["video_id"])
  end

  defp youtube_or_vimeo?(conn, regex) do
    video_id = tl(regex) |> List.last
    case Regex.run(~r{[a-z]}i, video_id) do
      nil ->
        VimeoData.create_or_show_video(conn, video_id)
      _ ->
        YoutubeData.create_or_show_video(conn, video_id)
    end

  end
end
