defmodule Vidshare.Factory do
  use ExMachina.Ecto, repo: Vidshare.Repo

  def user_factory do
    %Vidshare.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      full_name: "Bruce Wayne",
      provider: "github"
    }
  end

  def video_factory do
    %Vidshare.Video{
      duration: "PT2M2S",
      thumbnail: "https://i.ytimg.com/vi/1rlSjdnAKY4/hqdefault.jpg",
      title: "Super Troopers (2/5) Movie CLIP - The Cat Game (2001) HD",
      video_id: "1rlSjdnAKY4",
      view_count: 658281,
      embed: "https://www.youtube.com/embed/1rlSjdnAKY4?rel=0"
    }
  end
end
