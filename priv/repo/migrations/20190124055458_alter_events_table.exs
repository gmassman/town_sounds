defmodule TownSounds.Repo.Migrations.AlterEventsTable do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove :artist
      remove :venue
      remove :start_time

      add :place_id, :string
      add :html, :text
    end
  end
end
