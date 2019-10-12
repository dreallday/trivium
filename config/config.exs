# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :trivium,
  ecto_repos: [Trivium.Repo]

# Configures the endpoint
config :trivium, TriviumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CXtzHEsR1MOKG/49zyT1+MqmpF0AKI5eqVDJNsVHpNJMreCssAEQewePj4SW0J0O",
  render_errors: [view: TriviumWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Trivium.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :trivium, :pow,
  user: Trivium.Users.User,
  repo: Trivium.Repo,
  web_module: TriviumWeb,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  # https://github.com/danschultzer/pow/blob/master/guides/configuring_mailer.md
  mailer_backend: Trivium.PowMailer,
  routes_backend: TriviumWeb.Pow.Routes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
