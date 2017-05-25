defmodule Vidshare.VideoController do
  use Vidshare.Web, :controller

  alias Vidshare.Video

  def index(conn, _params) do
    videos = Repo.all(Video)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}) do
    # Sets regex to nil if invalid URL to make sure we only get valid YouTube links
    regex = Regex.run(~r/(?:youtube\.com\/\S*(?:(?:\/e(?:mbed))?\/|watch\?(?:\S*?&?v\=))|youtu\.be\/)([a-zA-Z0-9_-]{6,11})/, video_params["video_id"])

    if regex == nil do
      changeset = Video.changeset(%Video{})

      conn
      |> put_flash(:error, "Invalid YouTube URL")
      |> render("new.html", changeset: changeset)
    else
      # Grab only the video ID from the submitted YouTube link
      video_id = List.first(tl(regex))

      # Submit our info to the YouTube API and get back the JSON
      json_data = HTTPoison.get! "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{System.get_env("YOUTUBE_API_KEY")}&part=snippet,statistics,contentDetails&fields=items(id,snippet(title,thumbnails(high)),statistics(viewCount),contentDetails(duration))"

      # Decode the JSON
      data = Poison.decode!(json_data.body, keys: :atoms)

      # Grab our items from the JSON list within our data
      items = hd(data.items)

      # Convert the duration into a human readable format
      length_regex = tl(Regex.run(~r/PT(\d+H)?(\d+M)?(\d+S)?/, items.contentDetails.duration))
      duration = get_formatted_time(length_regex)

      # The information we need to create our video
      valid_attrs = %{duration: duration, thumbnail: items.snippet.thumbnails.high.url,
                      title: items.snippet.title, video_id: items.id,
                      view_count: String.to_integer(items.statistics.viewCount)}

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
end
