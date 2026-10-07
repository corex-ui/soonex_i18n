import Config

config :tableau, :reloader,
  patterns: [
    ~r"^lib/.*.ex",
    ~r"^(_posts|_pages|_data)/.*.(md|yaml|yml)",
    ~r"^assets/.*.(css|js)"
  ]

config :web_dev_utils, :reload_log, true

config :soonex_i18n, :public_path_prefix, ""

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
  include_dir: Path.expand("../extra", __DIR__),
  converters: [md: SoonexI18n.MDExConverter],
  markdown: [
    mdex: [
      extension: [
        table: true,
        header_id_prefix: "",
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
  title: "Soonex",
  description:
    "Tableau + Corex coming-soon template: accessible Phoenix UI, waitlist, journal, and config-driven design tokens."

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

l = fn lightness, seed ->
  %{kind: :l, seed: seed, l: lightness}
end

fill = fn lightness, seed ->
  %{
    kind: :l,
    seed: seed,
    l: lightness,
    states: %{
      muted: min(lightness + 0.03, 1.0),
      default: lightness,
      hover: max(lightness - 0.04, 0.0),
      active: max(lightness - 0.07, 0.0)
    }
  }
end

contrast = fn seed, against, target ->
  %{kind: :contrast, seed: seed, against: against, target: target * 1.0}
end

# Host color maps replace the preset mode (resolved_spec?/1). Keep *-contrast and
# *-text so solid brand/accent buttons stay readable. Do not lower these targets.
with_on = fn colors ->
  colors
  |> Map.merge(%{
    alert: fill.(0.44, :alert),
    info: fill.(0.4, :info),
    success: fill.(0.38, :success)
  })
  |> Map.merge(%{
    "accent-contrast" => contrast.(:neutral, :accent, 9.5),
    "brand-contrast" => contrast.(:neutral, :brand, 9.5),
    "alert-contrast" => contrast.(:neutral, :alert, 9.5),
    "info-contrast" => contrast.(:neutral, :info, 9.5),
    "success-contrast" => contrast.(:neutral, :success, 9.5),
    "accent-text" => contrast.(:accent, :ui, 4.6),
    "brand-text" => contrast.(:brand, :ui, 4.6),
    "alert-text" => contrast.(:alert, :ui, 4.6),
    "info-text" => contrast.(:info, :ui, 4.6),
    "success-text" => contrast.(:success, :ui, 4.6)
  })
end

config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  # Host overlays cannot set *_scale / duration / opacity. See Theme.Validator.
  # Contrast targets stay at or above preset strength so the solver and axe stay green.
  themes: %{
    neo: %{
      seeds: %{
        neutral: "#FAF9F6",
        accent: "#141414",
        brand: "#141414",
        alert: "#B42318",
        info: "#0E7490",
        success: "#15803D"
      },
      colors: %{
        light:
          with_on.(%{
            root: l.(0.99, :neutral),
            surface: l.(0.965, :neutral),
            ui: fill.(0.94, :neutral),
            accent: fill.(0.24, :accent),
            brand: fill.(0.4, :brand),
            ink: contrast.(:accent, :root, 12),
            "ink-muted": contrast.(:accent, :root, 6.0),
            link: contrast.(:brand, :root, 5.5),
            border: contrast.(:neutral, :ui, 1.28),
            focus: contrast.(:brand, :ui, 2.3),
            shadow: contrast.(:accent, :root, 1.1)
          }),
        dark:
          with_on.(%{
            root: l.(0.055, :accent),
            surface: l.(0.095, :accent),
            ui: fill.(0.155, :accent),
            accent: fill.(0.5, :accent),
            brand: fill.(0.54, :brand),
            ink: contrast.(:neutral, :root, 13),
            "ink-muted": contrast.(:neutral, :root, 6.6),
            link: contrast.(:brand, :root, 6.2),
            border: contrast.(:neutral, :ui, 1.32),
            focus: contrast.(:brand, :ui, 2.4),
            shadow: contrast.(:accent, :root, 1.18)
          })
      },
      dimensions: %{
        radius: %{
          xs: 0.28,
          sm: 0.48,
          md: 0.72,
          lg: 1.0,
          xl: 1.25,
          "2xl": 1.5,
          "3xl": 1.9,
          "4xl": 2.4,
          full: 9999
        },
        font: %{
          sans: ["Manrope", "ui-sans-serif", "system-ui", "sans-serif"],
          display: ["Outfit", "ui-sans-serif", "system-ui", "sans-serif"],
          mono: ["JetBrains Mono", "ui-monospace", "monospace"],
          code: ["JetBrains Mono", "ui-monospace", "monospace"],
          serif: ["ui-serif", "Georgia", "serif"]
        }
      },
      typography: %{
        "h1" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :medium},
          letter_spacing: {:tracking, :tight}
        },
        "h2" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :medium},
          letter_spacing: {:tracking, :tight}
        },
        "h3" => %{font_family: {:font, :display}, font_weight: {:weight, :medium}},
        "h4" => %{font_family: {:font, :sans}, font_weight: {:weight, :medium}},
        "p" => %{line_height: {:leading, :relaxed}},
        "p.display" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :medium},
          letter_spacing: {:tracking, :tight}
        },
        "blockquote" => %{font_family: {:font, :serif}, font_style: :italic},
        "code" => %{font_family: {:font, :mono}},
        "kbd" => %{font_family: {:font, :mono}}
      }
    },
    uno: %{
      seeds: %{
        neutral: "#F6F6F6",
        accent: "#071614",
        brand: "#0F766E",
        alert: "#B91C1C",
        info: "#0369A1",
        success: "#166534"
      },
      colors: %{
        light:
          with_on.(%{
            root: l.(0.99, :neutral),
            surface: l.(0.97, :neutral),
            ui: fill.(0.94, :neutral),
            accent: fill.(0.3, :accent),
            brand: fill.(0.36, :brand),
            ink: contrast.(:accent, :root, 10),
            "ink-muted": contrast.(:accent, :root, 5.5),
            link: contrast.(:brand, :root, 5.8),
            border: contrast.(:neutral, :ui, 1.22),
            focus: contrast.(:brand, :ui, 2.2),
            shadow: contrast.(:accent, :root, 1.06)
          }),
        dark:
          with_on.(%{
            root: l.(0.065, :accent),
            surface: l.(0.11, :accent),
            ui: fill.(0.175, :accent),
            accent: fill.(0.52, :accent),
            brand: fill.(0.52, :brand),
            ink: contrast.(:neutral, :root, 12.5),
            "ink-muted": contrast.(:neutral, :root, 6.2),
            link: contrast.(:brand, :root, 7.0),
            border: contrast.(:neutral, :ui, 1.28),
            focus: contrast.(:brand, :ui, 2.3),
            shadow: contrast.(:accent, :root, 1.14)
          })
      },
      dimensions: %{
        radius: %{
          xs: 0.55,
          sm: 0.9,
          md: 1.25,
          lg: 1.7,
          xl: 2.2,
          "2xl": 3.0,
          "3xl": 4.0,
          "4xl": 5.0,
          full: 9999
        },
        font: %{
          sans: ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
          display: ["Sora", "ui-sans-serif", "system-ui", "sans-serif"],
          mono: ["JetBrains Mono", "ui-monospace", "monospace"],
          code: ["JetBrains Mono", "ui-monospace", "monospace"],
          serif: ["Playfair Display", "Georgia", "serif"]
        }
      },
      typography: %{
        "h1" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :semibold},
          letter_spacing: {:tracking, :tight}
        },
        "h2" => %{font_family: {:font, :display}, letter_spacing: {:tracking, :tight}},
        "h3" => %{font_family: {:font, :display}, font_weight: {:weight, :medium}},
        "h4" => %{font_weight: {:weight, :medium}},
        "p" => %{line_height: {:leading, :snug}},
        "p.display" => %{font_family: {:font, :display}, font_weight: {:weight, :semibold}},
        "blockquote" => %{font_family: {:font, :serif}, font_style: :italic},
        "code" => %{font_family: {:font, :mono}},
        "kbd" => %{font_family: {:font, :mono}}
      }
    },
    duo: %{
      seeds: %{
        neutral: "#F7EDE4",
        accent: "#3A2618",
        brand: "#C2410C",
        alert: "#9F1239",
        info: "#3D5278",
        success: "#3F6B4E"
      },
      colors: %{
        light:
          Map.merge(
            with_on.(%{
              root: l.(0.99, :neutral),
              surface: l.(0.97, :neutral),
              ui: fill.(0.94, :neutral),
              accent: fill.(0.34, :accent),
              brand: fill.(0.42, :brand),
              ink: contrast.(:accent, :root, 12.5),
              "ink-muted": contrast.(:accent, :root, 6.8),
              link: contrast.(:brand, :root, 7.0),
              border: contrast.(:neutral, :ui, 1.22),
              focus: contrast.(:brand, :ui, 2.3),
              shadow: contrast.(:accent, :root, 1.28)
            }),
            %{"brand-text" => contrast.(:brand, :root, 7.0)}
          ),
        dark:
          with_on.(%{
            root: l.(0.075, :accent),
            surface: l.(0.125, :accent),
            ui: fill.(0.195, :accent),
            accent: fill.(0.5, :accent),
            brand: fill.(0.56, :brand),
            ink: contrast.(:neutral, :root, 12),
            "ink-muted": contrast.(:neutral, :root, 6.2),
            link: contrast.(:brand, :root, 7.0),
            border: contrast.(:neutral, :ui, 1.18),
            focus: contrast.(:brand, :ui, 2.3),
            shadow: contrast.(:accent, :root, 1.32)
          })
      },
      dimensions: %{
        radius: %{
          xs: 0.55,
          sm: 0.9,
          md: 1.3,
          lg: 1.8,
          xl: 2.35,
          "2xl": 3.1,
          "3xl": 4.0,
          "4xl": 5.0,
          full: 9999
        },
        font: %{
          sans: ["Work Sans", "ui-sans-serif", "system-ui", "sans-serif"],
          display: ["Playfair Display", "Georgia", "serif"],
          mono: ["JetBrains Mono", "ui-monospace", "monospace"],
          code: ["JetBrains Mono", "ui-monospace", "monospace"],
          serif: ["Playfair Display", "Georgia", "serif"]
        }
      },
      typography: %{
        "h1" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :bold},
          letter_spacing: {:tracking, :tight}
        },
        "h2" => %{font_family: {:font, :display}, font_weight: {:weight, :semibold}},
        "h3" => %{font_family: {:font, :display}},
        "h4" => %{font_family: {:font, :serif}, font_weight: {:weight, :medium}},
        "p" => %{line_height: {:leading, :relaxed}},
        "p.display" => %{
          font_family: {:font, :display},
          font_weight: {:weight, :bold},
          letter_spacing: {:tracking, :tight}
        },
        "blockquote" => %{font_family: {:font, :serif}, font_style: :italic},
        "code" => %{font_family: {:font, :mono}},
        "kbd" => %{font_family: {:font, :mono}}
      }
    },
    leo: %{
      seeds: %{
        neutral: "#E6DCCE",
        accent: "#0C0C0C",
        brand: "#E2410A",
        alert: "#C41E1E",
        info: "#0369A1",
        success: "#166534"
      },
      colors: %{
        light:
          with_on.(%{
            root: l.(0.985, :neutral),
            surface: l.(0.96, :neutral),
            ui: fill.(0.92, :neutral),
            accent: fill.(0.16, :accent),
            brand: fill.(0.36, :brand),
            ink: contrast.(:accent, :root, 12),
            "ink-muted": contrast.(:accent, :root, 5.8),
            link: contrast.(:brand, :root, 5.8),
            border: contrast.(:accent, :ui, 1.55),
            focus: contrast.(:brand, :ui, 2.5),
            shadow: contrast.(:accent, :root, 1.04)
          }),
        dark:
          with_on.(%{
            root: l.(0.04, :accent),
            surface: l.(0.085, :accent),
            ui: fill.(0.145, :accent),
            accent: fill.(0.48, :accent),
            brand: fill.(0.5, :brand),
            ink: contrast.(:neutral, :root, 14),
            "ink-muted": contrast.(:neutral, :root, 6.8),
            link: contrast.(:brand, :root, 7.2),
            border: contrast.(:neutral, :ui, 1.42),
            focus: contrast.(:brand, :ui, 2.6),
            shadow: contrast.(:accent, :root, 1.06)
          })
      },
      dimensions: %{
        radius: %{
          xs: 0,
          sm: 0.01,
          md: 0.02,
          lg: 0.03,
          xl: 0.04,
          "2xl": 0.06,
          "3xl": 0.08,
          "4xl": 0.1,
          full: 9999
        },
        font: %{
          sans: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
          display: ["IBM Plex Sans", "ui-sans-serif", "system-ui", "sans-serif"],
          mono: ["IBM Plex Mono", "ui-monospace", "monospace"],
          code: ["IBM Plex Mono", "ui-monospace", "monospace"],
          serif: ["ui-serif", "Georgia", "serif"]
        }
      },
      typography: %{
        "h1" => %{font_weight: {:weight, :semibold}, letter_spacing: {:tracking, :tight}},
        "h2" => %{font_weight: {:weight, :semibold}},
        "h3" => %{font_weight: {:weight, :medium}},
        "h4" => %{
          font_weight: {:weight, :medium},
          letter_spacing: {:tracking, :widest},
          font_size: {:text, :sm}
        },
        "p" => %{line_height: {:leading, :snug}},
        "p.display" => %{font_weight: {:weight, :semibold}, letter_spacing: {:tracking, :tight}},
        "blockquote" => %{font_style: :italic},
        "code" => %{font_family: {:font, :mono}},
        "kbd" => %{font_family: {:font, :mono}}
      }
    }
  },
  modes: [:light, :dark],
  scales: [
    space: [xs: 1, sm: 2, md: 3, lg: 5, xl: 6],
    size: [xs: 6, sm: 8, md: 11, lg: 13, xl: 15],
    text: [md: 1.02, lg: 1.15, xl: 1.28, "2xl": 1.55],
    weight: [normal: 400, medium: 500, semibold: 600, bold: 700]
  ],
  components: [
    :toast,
    :typo,
    :"layout-heading",
    :icon,
    :button,
    :link,
    :badge,
    :code,
    :clipboard,
    :tooltip,
    :select,
    :tabs,
    :toggle,
    :"toggle-group",
    :dialog,
    :menu,
    :"native-input",
    :checkbox,
    :"data-list",
    :timer,
    :marquee,
    :accordion,
    :avatar,
    :"floating-panel",
    :scrollbar,
    :pagination,
    :carousel,
    :switch,
    :"data-table",
    :collapsible,
    :"radio-group",
    :"tags-input",
    :"number-input",
    :"date-picker"
  ],
  semantics: [:accent, :brand, :alert, :info, :success],
  accessibility: true

config :phoenix, json_library: Jason

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
