defmodule VideoShare.Factory do
  use ExMachina.Ecto, repo: VideoShare.Repo

  def user_factory do
    %VideoShare.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      full_name: "Bruce Wayne",
      provider: "github"
    }
  end
end
