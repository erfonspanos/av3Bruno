defmodule Av3Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Av3ApiWeb.Telemetry,
      Av3Api.Repo,
      {DNSCluster, query: Application.get_env(:av3_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Av3Api.PubSub},
      # Start a worker by calling: Av3Api.Worker.start_link(arg)
      # {Av3Api.Worker, arg},
      # Start to serve requests, typically the last entry
      Av3ApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Av3Api.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Av3ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
