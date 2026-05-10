import Config

config :logger, level: :warning

config :soonex_i18n, :mcp_enabled, false

config :tableau, :server, false

config :wallaby,
  otp_app: :soonex_i18n,
  driver: Wallaby.Chrome,
  hackney_options: [timeout: :infinity, recv_timeout: :infinity],
  max_wait_time: 30_000,
  chromedriver: [
    capabilities: %{
      chromeOptions: %{
        args: [
          "--no-sandbox",
          "--disable-dev-shm-usage",
          "--disable-gpu",
          "--headless",
          "window-size=1280,900"
        ]
      }
    }
  ]
