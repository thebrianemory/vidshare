defmodule Vidshare.UserTest do
  use Vidshare.ModelCase
  alias Vidshare.User

  @valid_attrs %{token: "fahoifhaoaew0rheh0", email: "batman@example.com",
                 full_name: "Bruce Wayne", provider: "github"}
  @invalid_attrs %{}

  test "changeset with valide attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
