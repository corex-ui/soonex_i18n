import Config

config :logger, level: :warning

config :soonex_i18n, :mcp_enabled, false

config :tableau, :server, false

wallaby_chromedriver_overrides =
  case System.get_env("WALLABY_CHROME_BINARY") do
    nil -> []
    "" -> []
    p -> [binary: p]
  end ++
    case System.get_env("WALLABY_CHROMEDRIVER_PATH") do
      nil -> []
      "" -> []
      p -> [path: p]
    end

config :wallaby,
  otp_app: :soonex_i18n,
  driver: Wallaby.Chrome,
  hackney_options: [timeout: :infinity, recv_timeout: :infinity],
  max_wait_time: 30_000,
  chromedriver:
    Keyword.merge(
      [
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
      ],
      wallaby_chromedriver_overrides
    )
