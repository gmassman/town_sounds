defmodule TownSounds.AutocompletePlace do
  use Ecto.Schema
  import Ecto.Changeset

  @derive [Poison.Encoder]

  schema "autocomplete_places" do
    field :description, :string
    field :place_id, :string

    timestamps()
  end

  @doc false
  def changeset(autocomplete_place, attrs) do
    autocomplete_place
    |> cast(attrs, [:description, :place_id])
    |> validate_required([:description, :place_id])
    |> unique_constraint(:place_id)
  end
end
