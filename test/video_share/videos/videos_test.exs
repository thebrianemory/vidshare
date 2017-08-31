defmodule VideoShare.VideosTest do
  use VideoShare.DataCase

  alias VideoShare.Videos

  describe "videos" do
    alias VideoShare.Videos.Video

    @valid_attrs %{duration: "some duration", embed: "some embed", thumbnail: "some thumbnail", title: "some title", video_id: "some video_id", view_count: 42}
    @update_attrs %{duration: "some updated duration", embed: "some updated embed", thumbnail: "some updated thumbnail", title: "some updated title", video_id: "some updated video_id", view_count: 43}
    @invalid_attrs %{duration: nil, embed: nil, thumbnail: nil, title: nil, video_id: nil, view_count: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Videos.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Videos.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Videos.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Videos.create_video(@valid_attrs)
      assert video.duration == "some duration"
      assert video.embed == "some embed"
      assert video.thumbnail == "some thumbnail"
      assert video.title == "some title"
      assert video.video_id == "some video_id"
      assert video.view_count == 42
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Videos.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, video} = Videos.update_video(video, @update_attrs)
      assert %Video{} = video
      assert video.duration == "some updated duration"
      assert video.embed == "some updated embed"
      assert video.thumbnail == "some updated thumbnail"
      assert video.title == "some updated title"
      assert video.video_id == "some updated video_id"
      assert video.view_count == 43
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Videos.update_video(video, @invalid_attrs)
      assert video == Videos.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Videos.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Videos.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Videos.change_video(video)
    end
  end
end
