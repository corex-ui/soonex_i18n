defmodule SoonexI18n.MixProject do
  use Mix.Project

  def project do
    [
      app: :soonex_i18n,
      version: "0.3.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      deps: deps(),
      usage_rules: usage_rules()
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test], do: ["lib", "lib_dev"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:tableau, "~> 0.30"},
      # Override Tableau's ~> 0.11.1 pin for patched MDEx (CVE fixes from 0.13.2+).
      {:mdex, "~> 0.13.5", override: true},
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
      {:corex, "~> 0.2"},
      {:corex_design, "~> 0.2", runtime: false},
      {:corex_mcp, "~> 0.2", only: [:dev, :test]},
      {:gettext, "~> 1.0"},
      {:gettext_sigils, "~> 0.5.1"},
      {:localize_web, "~> 0.5.1"},
      {:color, "~> 0.11"},
      {:floki, "~> 0.38"},
      {:makeup, "~> 1.2"},
      {:makeup_elixir, "~> 1.0"},
      {:makeup_eex, "~> 2.0"},
      {:makeup_html, "~> 0.2"},
      {:makeup_css, "~> 0.2"},
      {:makeup_js, "~> 0.1"},
      {:rustler_precompiled, "~> 0.9", override: true},
      {:makeup_syntect, "~> 0.1.4"},
      {:wallaby, "~> 0.30", only: :test, runtime: false},
      {:a11y_audit, "~> 0.5.0", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.1", only: [:dev, :test], runtime: false},
      {:usage_rules, "~> 1.1", only: :dev}
    ] ++ maybe_json_polyfill()
  end

  defp usage_rules do
    [
      skills: [
        location: ".cursor/skills",
        package_skills: [:corex]
      ]
    ]
  end

  defp maybe_json_polyfill do
    if Code.ensure_loaded?(:json) do
      []
    else
      [{:json_polyfill, "~> 0.2 or ~> 1.0"}]
    end
  end

  defp aliases do
    [
      compile: ["compile"],
      setup: ["deps.get", "localize.download_locales", "corex.design.build"],
      "pre.test": [
        "corex.design.build",
        "esbuild default",
        "tailwind default",
        "tableau.build"
      ],
      test: ["pre.test", "test"],
      server: ["soonex_i18n.port_check", "tableau.server"],
      "assets.build": [
        "corex.design.build",
        "tailwind default",
        "esbuild default"
      ],
      build: [
        "compile",
        "corex.design.build",
        "tableau.build",
        "tailwind default --minify",
        "esbuild default --minify"
      ]
    ]
  end
end
