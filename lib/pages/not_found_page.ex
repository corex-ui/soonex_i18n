defmodule SoonexI18n.NotFoundPage do
  @moduledoc false

  use Tableau.Page,
    layout: SoonexI18n.RootLayout,
    permalink: "/404.html",
    title: "Page not found",
    description: "That page is not on Soonex.",
    page_kind: :not_found,
    sitemap: %{priority: 0.2, changefreq: "yearly"}

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.Layouts.Brand, only: [lockup: 1]

  alias SoonexI18n.Layouts.Shell

  def template(assigns) do
    ~H"""
    <section
      class={"#{Shell.section()} flex min-h-dvh flex-col items-center justify-center bg-root text-center"}
      aria-labelledby="soonex-not-found-heading"
    >
      <div class={Shell.stage()}>
        <div class={"#{Shell.panel()} mx-auto flex max-w-lg flex-col items-center gap-6 px-8 py-16"}>
          <.lockup />
          <p class={Shell.eyebrow()}>404</p>
          <h1 id="soonex-not-found-heading" class="display m-0 text-4xl font-semibold tracking-tight">
            {~t"Page not found"}
          </h1>
          <p class="m-0 max-w-sm text-base/7 text-ink-muted">
            {~t"That URL is not on this site. Head home or read the journal."}
          </p>
          <div class="mt-4 flex flex-wrap items-center justify-center gap-4">
            <.navigate to={~p"/"} class="button ui-brand ui-solid ui-size-md">
              {~t"Home"}
            </.navigate>
            <.navigate to={~p"/blog"} class="button ui-ghost ui-size-md">
              {~t"Journal"}
            </.navigate>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
