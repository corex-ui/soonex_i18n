defmodule SoonexI18n.NotFoundPage do
  @moduledoc false

  use Tableau.Page,
    layout: SoonexI18n.RootLayout,
    permalink: "/404.html",
    title: "Page not found",
    description: "The page you requested is not part of this static site.",
    page_kind: :not_found

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  def template(assigns) do
    ~H"""
    <section
      class="flex min-h-dvh flex-col items-center justify-center gap-space-lg px-space py-size-xl text-center"
      aria-labelledby="soonex_i18n-not-found-heading"
    >
      <div class="flex max-w-md flex-col gap-space-lg">
        <p class="ui-label m-0 text-ink-muted">404</p>
        <h1 id="soonex_i18n-not-found-heading" class="m-0 text-4xl font-bold tracking-tight">
          {~t"Page not found"}
        </h1>
        <p class="m-0 leading-relaxed text-ink-muted">
          {~t"The URL may be mistyped, or the page may have moved. Try the home page."}
        </p>
        <.navigate to={~p"/"} class="button ui-accent ui-solid w-fit self-center">
          {~t"Back to home"}
        </.navigate>
      </div>
    </section>
    """
  end
end
