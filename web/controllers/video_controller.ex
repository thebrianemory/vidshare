defmodule Vidshare.VideoController do
  use Vidshare.Web, :controller
  use Rummage.Phoenix.Controller

  alias Vidshare.Video

  plug Vidshare.Plugs.RequireAuth when action in [:new, :create, :delete]
  plug :check_video_owner when action in [:delete]

  def index(conn, params) do
    Video
    |> Repo.all
    |> Repo.preload(:user)

    {query, rummage} = Video
    |> Video.rummage(params["rummage"])

    videos = query
    |> Repo.all
    |> Repo.preload(:user)
    render(conn, "index.html", videos: videos, rummage: rummage)
  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    # Sets regex to nil if invalid URL to make sure we only get valid YouTube/Vimeo links
    regex = Regex.run(~r{^.*((youtu.be\/|vimeo.com\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*}, video_params["video_id"])

    if regex == nil do
      changeset = Video.changeset(%Video{})

      conn
      |> put_flash(:error, "Invalid URL")
      |> render("new.html", changeset: changeset)
    else
      # Grab only the video ID from the submitted YouTube/Vimeo link
      video_id = List.last(regex)

      valid_attrs = if Regex.run(~r{[a-z]}i, video_id) == nil do
        create_vimeo_attributes(video_id)
      else
        create_youtube_attributes(video_id)
      end

      # Creates are changeset and builds the association with the current user
      changeset = conn.assigns.user
      |> build_assoc(:videos)
      |> Video.changeset(valid_attrs)

      # Creates our video in the database if it does not already exist
      # If it fails to create at this point, that means it already exists. Redirect to its show page
      case Repo.insert(changeset) do
        {:ok, video} ->
          conn
          |> put_flash(:info, "Video created successfully.")
          |> redirect(to: video_path(conn, :show, video))
        {:error, _video} ->
          video = Vidshare.Video |> Vidshare.Repo.get_by(video_id: video_id)
          conn
          |> put_flash(:info, "Video has already been created.")
          |> redirect(to: video_path(conn, :show, video))
      end
    end
  end

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.html", video: video)
  end

  def delete(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp create_vimeo_attributes(video_id) do
    # Submit our info to the Vimeo API and get back the JSON
    json_data = HTTPoison.get!("https://api.vimeo.com/videos/#{video_id}?fields=uri,name,link,duration,pictures,stats", %{"Authorization" => "bearer #{System.get_env("VIMEO_TOKEN")}"})

    # Decode the JSON
    data = Poison.decode!(json_data.body, keys: :atoms)

    # Convert the duration into a human readable format
    duration = vimeo_sec_to_str(data.duration)

    # The information we need to create our video
    %{duration: duration, thumbnail: List.last(data.pictures.sizes).link,
      title: data.name, video_id: video_id,
      view_count: data.stats.plays,
      embed: "https://player.vimeo.com/video/#{video_id}?badge=0&autopause=0&player_id=0"}
  end

  defp create_youtube_attributes(video_id) do
    # Submit our info to the YouTube API and get back the JSON
    json_data = HTTPoison.get! "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{System.get_env("YOUTUBE_API_KEY")}&part=snippet,statistics,contentDetails&fields=items(id,snippet(title,thumbnails(high)),statistics(viewCount),contentDetails(duration))"

    # Decode the JSON
    data = Poison.decode!(json_data.body, keys: :atoms)
    # Grab our items from the JSON list within our data
    items = hd(data.items)

    # Convert the duration into a human readable format
    duration = tl(Regex.run(~r{PT(\d+H)?(\d+M)?(\d+S)?}, items.contentDetails.duration))
    |> youtube_get_formatted_time()

    # The information we need to create our video
    %{duration: duration, thumbnail: items.snippet.thumbnails.high.url,
      title: items.snippet.title, video_id: video_id,
      view_count: String.to_integer(items.statistics.viewCount),
      embed: "https://www.youtube.com/embed/#{video_id}?rel=0"}
  end

  defp youtube_get_formatted_time(duration) do
    [hours, minutes, seconds] = for x <- duration do
      String.to_integer(hd(Regex.run(~r{\d+}, x) || ["0"]))
    end

    {_status, time} = Time.new(hours, minutes, seconds)
    Time.to_string(time)
  end

  defp vimeo_sec_to_str(sec) do
    {_, [s, m, h]} =
      Enum.reduce([(60*60), 60, 1], {sec,[]}, fn divisor,{n,acc} ->
        {rem(n,divisor), [div(n,divisor) | acc]}
      end)

    {_status, time} = Time.new(h, m, s)
    Time.to_string(time)
  end

  defp check_video_owner(conn, _params) do
    %{params: %{"id" => video_id}} = conn

    if Repo.get(Video, video_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot do that")
      |> redirect(to: video_path(conn, :index))
      |> halt()
    end
  end
end
