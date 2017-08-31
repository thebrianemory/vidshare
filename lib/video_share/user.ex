defmodule VideoShare.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias VideoShare.User
  alias VideoShare.Videos.Video

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :provider, :string
    field :token, :string
    has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :provider, :token])
    |> validate_required([:full_name, :email, :provider, :token])
  end
end
