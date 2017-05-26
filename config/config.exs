# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vidshare,
  ecto_repos: [Vidshare.Repo]

# Configures the endpoint
config :vidshare, Vidshare.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8/ZrRnN3VsgNUSe3UpcJDG9zqq7fWs9xFh6/oMTOwdP0WDwoWay4eC7gdW92o7xy",
  render_errors: [view: Vidshare.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vidshare.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure GitHub OAuth
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "read:user,read:org,"]}
  ]
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Configure Rummage
config :rummage_ecto, Rummage.Ecto,
  default_repo: Vidshare.Repo,
  default_per_page: 5

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
