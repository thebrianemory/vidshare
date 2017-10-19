use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :video_share, VideoShareWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :video_share, VideoShare.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "thebrianemory",
  password: "",
  database: "video_share_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
