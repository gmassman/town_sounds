defmodule TownSounds.UpcomingEvents do
  use Ecto.Schema
  import Ecto.Changeset

  schema "upcoming_events" do
    field :raw_html, :binary
    field :place_id, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w[raw_html place_id])
  end
end
