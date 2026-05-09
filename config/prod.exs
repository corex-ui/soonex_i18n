import Config

site_url =
  case System.get_env("SOONEX_PUBLIC_URL") do
    url when is_binary(url) and url != "" -> url
    _ -> "https://example.com"
  end

config :tableau, :config, url: site_url
config :tableau, Tableau.PostExtension, future: false, dir: ["_posts"]
config :tableau, Tableau.PageExtension, dir: ["_pages"]
