defmodule SoonexI18n.HomePage.Hero do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.Routes
  use SoonexI18n.GettextSigil

  attr(:countdown_ms, :integer, required: true)

  def hero(assigns) do
    locale = Gettext.get_locale(SoonexI18n.Gettext)
    headline = ~t"Write Elixir, ship a static build."

    assigns =
      assigns
      |> Phoenix.Component.assign(:hero_locale, locale)
      |> Phoenix.Component.assign(:hero_headline, headline)

    ~H"""
    <header
      class="relative flex min-h-dvh flex-col justify-center px-space py-size-xl"
      aria-labelledby="soonex_i18n-headline"
      data-hero-boundary
    >
      <div class="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden="true">
        <div
          class="absolute inset-0 bg-[length:var(--spacing-size-lg)_var(--spacing-size-lg)] bg-[linear-gradient(var(--color-border)_1px,transparent_1px),linear-gradient(90deg,var(--color-border)_1px,transparent_1px)] opacity-20"
          data-parallax
        >
        </div>
      </div>

      <div
        class="relative z-[1] mx-auto flex w-full min-w-0 max-w-4xl flex-col items-center gap-space-lg text-center"
        data-hero
      >
        <h1
          id="soonex_i18n-headline"
          class="m-0 text-5xl md:text-7xl lg:text-8xl tracking-tight leading-[0.95] text-balance"
        >
          <%= if @hero_locale == "ar" do %>
            {@hero_headline}
          <% else %>
            <%= for word <- String.split(@hero_headline, " ") do %>
              <span class="inline-block" data-hero-word>{word}&nbsp;</span>
            <% end %>
          <% end %>
        </h1>

        <div class="flex max-w-xl flex-col gap-space text-balance">
          <h2 class="m-0 max-w-xl font-sans !text-base !font-normal leading-normal text-ink-muted md:!text-lg">
            <span class="text-brand-text">Tableau</span>{" "}
            {~t"compiles HEEx to static files."}
          </h2>
          <h3 class="m-0 max-w-xl font-sans !text-base !font-normal leading-normal text-ink-muted md:!text-lg">
            <span class="text-brand-text">Corex</span>{" "}
            {~t"covers components, tokens, Markdown, locales, themes, and MCP for your editor."}
          </h3>
        </div>

        <.timer
          id="soonex_i18n-hero-countdown"
          countdown
          start_ms={@countdown_ms}
          target_ms={0}
          class="timer ui-brand ui-rounded-xl ui-size-xl"
        >
          <:day_label>{~t"Days"}</:day_label>
          <:hour_label>{~t"Hours"}</:hour_label>
          <:minute_label>{~t"Min"}</:minute_label>
          <:second_label>{~t"Sec"}</:second_label>
        </.timer>

        <div class="flex w-full flex-col items-center gap-space sm:flex-row sm:justify-center">
          <.navigate to="#waitlist" class="button ui-accent ui-solid">
            {~t"Join the waitlist"}
          </.navigate>
          <.navigate to={~p"/docs"} class="button ui-ghost">
            {~t"Read the documentation"} <.heroicon name="hero-arrow-up-right" />
          </.navigate>
        </div>
      </div>
    </header>

    <div data-hero-sentinel aria-hidden="true" class="pointer-events-none h-px w-full shrink-0"></div>
    """
  end
end
