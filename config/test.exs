use Mix.Config

# Configure your database
config :trivium, Trivium.Repo,
  username: "postgres",
  password: "postgres",
  database: "trivium_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trivium, TriviumWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
