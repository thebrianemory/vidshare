defmodule VideoShare.Videos.VimeoData do
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import VideoShareWeb.Router.Helpers

  alias VideoShare.Videos.Video

  def create_or_show_video(conn, video_id) do
    video_data =
      get_json_data(video_id)
      |> decode_json_data()

    # |> get_video_data()

    video_attrs =
      get_formatted_time(video_data)
      |> create_video_attrs(video_data, video_id)

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
      "https://api.vimeo.com/videos/#{video_id}?fields=uri,name,link,duration,pictures,stats",
      %{"Authorization" => "bearer #{System.get_env("VIMEO_TOKEN")}"}
    )
  end

  defp decode_json_data(json_data) do
    Poison.decode!(json_data.body, keys: :atoms)
  end

  defp get_formatted_time(video_data) do
    {_, [s, m, h]} =
      Enum.reduce([60 * 60, 60, 1], {video_data.duration, []}, fn divisor, {n, acc} ->
        {rem(n, divisor), [div(n, divisor) | acc]}
      end)

    {_status, time} = Time.new(h, m, s)
    Time.to_string(time)
  end

  defp create_video_attrs(duration, video_data, video_id) do
    %{
      duration: duration,
      thumbnail: List.last(video_data.pictures.sizes).link,
      title: video_data.name,
      video_id: video_id,
      view_count: video_data.stats.plays,
      embed: "https://player.vimeo.com/video/#{video_id}?badge=0&autopause=0&player_id=0"
    }
  end

  defp create_changeset(conn, video_attrs) do
    conn.assigns.user
    |> Ecto.build_assoc(:videos)
    |> Video.changeset(video_attrs)
  end
end
