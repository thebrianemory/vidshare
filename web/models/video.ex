defmodule Vidshare.Video do
  use Vidshare.Web, :model
  use Rummage.Ecto

  schema "videos" do
    field :video_id, :string
    field :title, :string
    field :duration, :string
    field :thumbnail, :string
    field :view_count, :integer
    belongs_to :user, Vidshare.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:video_id, :title, :duration, :thumbnail, :view_count])
    |> validate_required([:video_id, :title, :duration, :thumbnail, :view_count])
  end
end
