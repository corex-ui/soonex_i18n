defmodule SoonexI18n.Application do
  @moduledoc false

  use Application

  @mcp_enabled Mix.env() == :dev

  @impl true
  def start(_type, _args) do
    base = [
      {Phoenix.PubSub, name: SoonexI18n.PubSub},
      SoonexI18nWeb.Endpoint
    ]

    children =
      base ++
        if @mcp_enabled do
          [
            {Bandit, plug: SoonexI18n.Mcp, scheme: :http, port: 4004}
          ]
        else
          []
        end

    opts = [strategy: :one_for_one, name: SoonexI18n.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
