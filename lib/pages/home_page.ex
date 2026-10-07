defmodule SoonexI18n.HomePage do
  @moduledoc false

  use Phoenix.Component
  use Corex

  import SoonexI18n.HomePage.Hero, only: [hero: 1]
  import SoonexI18n.HomePage.Logos, only: [logos: 1]
  import SoonexI18n.HomePage.Showcase, only: [showcase: 1]
  import SoonexI18n.HomePage.Features, only: [features: 1]
  import SoonexI18n.HomePage.HowItWorks, only: [how_it_works: 1]
  import SoonexI18n.HomePage.Proof, only: [proof: 1]
  import SoonexI18n.HomePage.Journal, only: [journal: 1]
  import SoonexI18n.HomePage.Faq, only: [faq: 1]
  import SoonexI18n.HomePage.Waitlist, only: [waitlist: 1]

  def template(assigns) do
    assigns =
      assigns
      |> Map.put(
        :posts,
        SoonexI18n.Locale.local_posts(Map.get(assigns, :posts, []), assigns.page)
      )

    ~H"""
    <div id="home" class="w-full text-ink">
      <.hero />
      <.logos />
      <.showcase />
      <.features />
      <.how_it_works />
      <.proof />
      <.journal posts={@posts} />
      <.faq />
      <.waitlist />
    </div>
    """
  end
end

for locale <- SoonexI18n.Locale.locales() do
  Module.create(
    Module.concat(SoonexI18n.HomePage, String.upcase(locale)),
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote("/#{locale}/"),
        title: "Soonex",
        page_kind: :home

      def template(assigns), do: SoonexI18n.HomePage.template(assigns)
    end,
    __ENV__
  )
end
