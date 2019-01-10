defmodule TownSounds.Repo.Migrations.CreateUpcomingEvents do
  use Ecto.Migration

  def change do
    create table(:upcoming_events) do
      add :raw_html, :text
      add :place_id, :string

      timestamps()
    end

    create_if_not_exists index(:autocomplete_places, [:place_id])
  end
end
