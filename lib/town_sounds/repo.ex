defmodule TownSounds.Repo do
  use Ecto.Repo,
    otp_app: :town_sounds,
    adapter: Ecto.Adapters.Postgres
end
