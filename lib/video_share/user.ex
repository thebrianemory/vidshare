defmodule VideoShare.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias VideoShare.User


  schema "users" do
    field :email, :string
    field :full_name, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :provider, :token])
    |> validate_required([:full_name, :email, :provider, :token])
  end
end
