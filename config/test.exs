use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vidshare, Vidshare.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :vidshare, Vidshare.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "brianemory",
  password: "",
  database: "vidshare_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
