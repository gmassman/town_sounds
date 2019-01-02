defmodule TownSounds.Repo.Migrations.CreateAutocompletePlaces do
  use Ecto.Migration

  def change do
    create table(:autocomplete_places) do
      add :description, :string
      add :place_id, :string

      timestamps()
    end

    create unique_index(:autocomplete_places, [:place_id])
  end
end
