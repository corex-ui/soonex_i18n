defmodule SoonexI18n.MixProject do
  use Mix.Project

  def project do
    [
      app: :soonex_i18n,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def cli do
    [preferred_envs: [test: :test]]
  end

  def application do
    [
      mod: {SoonexI18n.Application, []},
      extra_applications: [:logger, :localize]
    ]
  end

  defp deps do
    [
      {:tableau, "~> 0.26"},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:bandit, "~> 1.0"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.2.0",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:corex, "~> 0.1.0-beta.3"},
      {:gettext, "~> 1.0"},
      {:localize_web, "~> 0.5.1"},
      {:color, "~> 0.11"},
      {:designex, "~> 1.0"},
      {:floki, "~> 0.38"},
      {:makeup, "~> 1.2"},
      {:makeup_elixir, "~> 1.0"},
      {:makeup_eex, "~> 2.0"},
      {:makeup_html, "~> 0.2"},
      {:makeup_css, "~> 0.2"},
      {:makeup_js, "~> 0.1"},
      {:rustler_precompiled, "~> 0.9", override: true},
      {:makeup_syntect, "~> 0.1.4"},
      {:wallaby, "~> 0.30", only: :test},
      {:a11y_audit, "~> 0.3.1", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      compile: ["compile"],
      setup: ["deps.get", "localize.download_locales en ar fr"],
      "pre.test": [
        "soonex_i18n.palette",
        "designex corex",
        "esbuild default",
        "tailwind default",
        "tableau.build"
      ],
      test: ["pre.test", "test"],
      "assets.build": [
        "soonex_i18n.palette",
        "designex corex",
        "tailwind default",
        "esbuild default"
      ],
      build: [
        "compile",
        "soonex_i18n.palette",
        "designex corex",
        "tableau.build",
        "tailwind default --minify",
        "esbuild default --minify"
      ]
    ]
  end
end
