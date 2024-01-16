defmodule Coolify.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CoolifyWeb.Telemetry,
      Coolify.Repo,
      {DNSCluster, query: Application.get_env(:coolify, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Coolify.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Coolify.Finch},
      # Start a worker by calling: Coolify.Worker.start_link(arg)
      # {Coolify.Worker, arg},
      # Start to serve requests, typically the last entry
      CoolifyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Coolify.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CoolifyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
