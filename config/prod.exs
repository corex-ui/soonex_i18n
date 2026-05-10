import Config

site_url =
  case System.get_env("SOONEX_PUBLIC_URL") do
    url when is_binary(url) and url != "" -> url
    _ -> "https://corex-ui.github.io/soonex_i18n"
  end

uri = URI.parse(String.trim(to_string(site_url)))
scheme = uri.scheme || "https"
host = uri.host || "localhost"
path_str = uri.path || "/"
inner = String.trim(path_str, "/")
path = if inner == "", do: "/", else: "/" <> inner

port =
  if uri.port do
    uri.port
  else
    if scheme == "https", do: 443, else: 80
  end

config :soonex_i18n, SoonexI18nWeb.Endpoint,
  url: [scheme: scheme, host: host, port: port, path: path]

config :tableau, :config, url: site_url
config :tableau, Tableau.PostExtension, future: false, dir: ["_posts"]
config :tableau, Tableau.PageExtension, dir: ["_pages"]
