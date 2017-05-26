defmodule Vidshare.Repo.Migrations.AddUnqiueIndexToVideoId do
  use Ecto.Migration

  def change do
    create unique_index(:videos, [:video_id])
  end
end
