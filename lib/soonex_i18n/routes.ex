defmodule SoonexI18n.Routes do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: SoonexI18nI18nWeb.Endpoint,
        router: SoonexI18nI18nWeb.Router,
        statics: ~w(images css js feed.xml site.webmanifest 404.html),
        path_prefixes: [{SoonexI18n.Locale, :current, []}]
    end
  end
end
