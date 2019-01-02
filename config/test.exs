use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :town_sounds, TownSoundsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :town_sounds, TownSounds.Repo,
  username: "postgres",
  password: "postgres",
  database: "town_sounds_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
