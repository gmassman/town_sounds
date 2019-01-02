defmodule TownSounds.Repo.Migrations.CreateAutocompletePlaces do
  use Ecto.Migration

  def change do
    create table(:autocomplete_places) do
      add :description, :string
      add :place_id, :string

      timestamps()
    end

  end
end
