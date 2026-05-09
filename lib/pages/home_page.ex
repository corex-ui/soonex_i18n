defmodule SoonexI18n.HomePage do
  @moduledoc false

  use Phoenix.Component
  use Corex

  import SoonexI18n.HomePage.Hero, only: [hero: 1]
  import SoonexI18n.HomePage.Highlights, only: [highlights: 1]
  import SoonexI18n.HomePage.Scale, only: [scale: 1]
  import SoonexI18n.HomePage.Pricing, only: [pricing: 1]
  import SoonexI18n.HomePage.Faq, only: [faq: 1]
  import SoonexI18n.HomePage.Waitlist, only: [waitlist: 1]

  def template(assigns) do
    assigns =
      assigns
      |> Map.put(
        :countdown_ms,
        max(DateTime.diff(~U[2026-09-01 00:00:00Z], DateTime.utc_now(), :millisecond), 0)
      )
      |> Map.put(:stats_components, length(Corex.component_ids()))

    ~H"""
    <.hero countdown_ms={@countdown_ms} />
    <.highlights />
    <.scale stats_components={@stats_components} />
    <.pricing />
    <.faq />
    <.waitlist />
    """
  end
end

for locale <- SoonexI18n.Locale.locales() do
  mod = Module.concat(SoonexI18n.HomePage, String.upcase(locale))

  permalink = "/#{locale}/"

  title = "SoonexI18n"

  Module.create(
    mod,
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote(permalink),
        title: unquote(title),
        page_kind: :home

      def template(assigns), do: SoonexI18n.HomePage.template(assigns)
    end,
    __ENV__
  )
end
