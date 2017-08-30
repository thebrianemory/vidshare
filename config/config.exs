# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :video_share,
  ecto_repos: [VideoShare.Repo]

# Configures the endpoint
config :video_share, VideoShareWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7T9cturUN5gNegb+26pimc6jto1GqKy8B/DAm6rip+rd1GW8nksg2vje1jZ2OGHB",
  render_errors: [view: VideoShareWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VideoShare.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
