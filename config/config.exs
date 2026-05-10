import Config

config :tableau, :reloader,
  patterns: [
    ~r"^lib/.*.ex",
    ~r"^(_posts|_pages)/.*.md",
    ~r"^assets/.*.(css|js)"
  ]

config :web_dev_utils, :reload_log, true

config :esbuild,
  version: "0.25.5",
  default: [
    args: ~w(js/site.js --bundle --format=esm --splitting --target=es2022 --outdir=../_site/js),
    cd: Path.expand("../assets", __DIR__),
    env: %{
      "NODE_PATH" =>
        [
          Path.expand("../deps", __DIR__),
          Path.expand("../node_modules", __DIR__)
        ]
        |> Enum.join(":")
    }
  ]

config :tailwind,
  version: "4.1.0",
  default: [
    args: ~w(
    --input=assets/css/site.css
    --output=_site/css/site.css
    )
  ]

if Mix.env() == :dev do
  config :tableau, :assets,
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--watch)]}
end

config :tableau, :config,
  url: "http://localhost:4999",
  converters: [md: SoonexI18n.MDExConverter],
  markdown: [
    mdex: [
      extension: [
        table: true,
        header_ids: "",
        tasklist: true,
        strikethrough: true,
        autolink: true,
        alerts: true,
        footnotes: true
      ],
      render: [unsafe: true],
      syntax_highlight: nil
    ]
  ]

config :tableau, Tableau.PageExtension, enabled: true
config :tableau, Tableau.PostExtension, enabled: true
config :tableau, Tableau.DataExtension, enabled: true
config :tableau, Tableau.SitemapExtension, enabled: true

config :tableau, Tableau.RSSExtension,
  enabled: true,
  title: "SoonexI18n",
  description:
    "Elixir static site template: Tableau, Corex, tokens, Tailwind v4, Markdown posts. Waitlist for launch updates."

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :designex,
  version: "1.0.2",
  commit: "1da4b31",
  cd: Path.expand("../assets", __DIR__),
  dir: "corex",
  corex: [
    build_args: ~w(--dir=design --script=build.mjs --tokens=tokens)
  ]

config :phoenix,
  gettext_backend: SoonexI18n.Gettext,
  json_library: Jason

config :soonex_i18n, SoonexI18nWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: SoonexI18n.PubSub,
  server: false,
  secret_key_base:
    "soonex_dev_secret_key_base_minimum_sixty_four_chars_long_placeholder_do_not_use_prod"

config :localize,
  default_locale: "en",
  supported_locales: ~w(en ar fr)

import_config "#{Mix.env()}.exs"
