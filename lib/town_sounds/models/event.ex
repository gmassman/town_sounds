defmodule TownSounds.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :place_id, :string
    field :html, :binary

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:place_id, :html])
    |> validate_required([:place_id])
  end
end
