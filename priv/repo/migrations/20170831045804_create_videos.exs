defmodule VideoShare.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :video_id, :string
      add :title, :string
      add :duration, :string
      add :thumbnail, :string
      add :view_count, :integer
      add :embed, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:videos, [:video_id])
    create index(:videos, [:user_id])
  end
end
