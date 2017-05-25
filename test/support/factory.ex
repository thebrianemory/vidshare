defmodule Vidshare.Factory do
  use ExMachina.Ecto, repo: Vidshare.Repo

  def user_factory do
    %Vidshare.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end
end
