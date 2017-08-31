defmodule VideoShare.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias VideoShare.Videos.Video
  alias VideoShare.User


  schema "videos" do
    field :duration, :string
    field :embed, :string
    field :thumbnail, :string
    field :title, :string
    field :video_id, :string, unique: true
    field :view_count, :integer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:video_id, :title, :duration, :thumbnail, :view_count, :embed])
    |> validate_required([:video_id, :title, :duration, :thumbnail, :view_count, :embed])
    |> unique_constraint(:video_id)
  end
end
