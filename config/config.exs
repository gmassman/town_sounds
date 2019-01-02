# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :town_sounds,
  ecto_repos: [TownSounds.Repo]

# Configures the endpoint
config :town_sounds, TownSoundsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jL0y+TTr9aLY2J8E1FuZV9xQc2rmTDxonuHfCObuY9mSYgZO85SjSDOcfGjP+PlV",
  render_errors: [view: TownSoundsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TownSounds.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
