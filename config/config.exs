# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :av3_api,
  ecto_repos: [Av3Api.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :av3_api, Av3ApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: Av3ApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Av3Api.PubSub,
  live_view: [signing_salt: "XT7G0X3Z"]

# Configure the mailer
config :av3_api, Av3Api.Mailer, adapter: Swoosh.Adapters.Local

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# --- CONFIGURAÇÃO DO GUARDIAN (JWT) ---
# Adicionado para resolver o erro {:error, :secret_not_found}
config :av3_api, Av3Api.Guardian,
  issuer: "av3_api",
  secret_key: "SegredoSuperSecreto_TroqueIssoEmProducao_MasParaOTrabalhoServe"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
