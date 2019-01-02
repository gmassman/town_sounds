defmodule TownSounds.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :artist, :string
      add :venue, :string
      add :start_time, :utc_datetime
    end
  end
end
