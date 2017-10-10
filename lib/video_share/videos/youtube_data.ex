defmodule VideoShare.Videos.YoutubeData do
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import VideoShareWeb.Router.Helpers

  alias VideoShare.Videos.Video

  def create_or_show_video(conn, video_id) do
    video_data =
      get_json_data(video_id)
      |> decode_json_data()
      |> get_video_data()

    video_attrs =
      get_formatted_time(video_data)
      |> create_video_attrs(video_data)

    changeset = create_changeset(conn, video_attrs)

    case VideoShare.Repo.insert(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))

      {:error, _video} ->
        video = Video |> VideoShare.Repo.get_by(video_id: video_id)

        conn
        |> put_flash(:info, "Video has already been created.")
        |> redirect(to: video_path(conn, :show, video))
    end
  end

  defp get_json_data(video_id) do
    HTTPoison.get!(
      "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{
        System.get_env("YOUTUBE_API_KEY")
      }&part=snippet,statistics,contentDetails&fields=items(id,snippet(title,thumbnails(high)),statistics(viewCount),contentDetails(duration))"
    )
  end

  defp decode_json_data(json_data) do
    Poison.decode!(json_data.body, keys: :atoms)
  end

  defp get_video_data(video) do
    hd(video.items)
  end

  defp get_formatted_time(video_data) do
    duration = tl(Regex.run(~r/PT(\d+H)?(\d+M)?(\d+S)?/, video_data.contentDetails.duration))

    [hours, minutes, seconds] =
      for x <- duration, do: hd(Regex.run(~r{\d+}, x) || ["0"]) |> String.to_integer()

    {_status, time} = Time.new(hours, minutes, seconds)
    Time.to_string(time)
  end

  defp create_video_attrs(duration, video_data) do
    %{
      duration: duration,
      thumbnail: video_data.snippet.thumbnails.high.url,
      title: video_data.snippet.title,
      video_id: video_data.id,
      view_count: String.to_integer(video_data.statistics.viewCount),
      embed: "https://www.youtube.com/embed/#{video_data.id}?rel=0"
    }
  end

  defp create_changeset(conn, video_attrs) do
    conn.assigns.user
    |> Ecto.build_assoc(:videos)
    |> Video.changeset(video_attrs)
  end
end
