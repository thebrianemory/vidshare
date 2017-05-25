defmodule Vidshare.VideoTest do
  use Vidshare.ModelCase

  alias Vidshare.Video

  @valid_attrs %{duration: "some content", thumbnail: "some content", title: "some content", video_id: "some content", view_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end
end
