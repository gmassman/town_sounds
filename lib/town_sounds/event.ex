defmodule TownSounds.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :artist, :string
    field :start_time, :utc_datetime
    field :venue, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:artist, :venue, :start_time])
    |> validate_required([:artist, :venue, :start_time])
  end
end
