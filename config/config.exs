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

# Configure GitHub OAuth
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "read:user,user:email,read:org,"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Configure Rummage Phoenix
config :rummage_ecto, Rummage.Ecto,
  default_repo: VideoShare.Repo,
  default_per_page: 5

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
