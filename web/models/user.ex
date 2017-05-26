defmodule Vidshare.User do
  use Vidshare.Web, :model

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :videos, Vidshare.Video

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:full_name, :email, :provider, :token])
    |> validate_required([:full_name, :email, :provider, :token])
  end
end
