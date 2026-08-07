defmodule SoonexI18n.HomePage.Hero do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  attr(:countdown_ms, :integer, required: true)

  def hero(assigns) do
    ~H"""
    <header
      class={"relative isolate #{Shell.section()} overflow-x-hidden"}
      aria-labelledby="soonex_i18n-headline"
      data-hero-boundary
    >
      <div class="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden="true">
        <div
          class="absolute inset-0 bg-[length:var(--spacing-size-lg)_var(--spacing-size-lg)] bg-[linear-gradient(var(--color-border)_1px,transparent_1px),linear-gradient(90deg,var(--color-border)_1px,transparent_1px)] opacity-[0.18]"
          data-parallax
        >
        </div>
      </div>

      <div class={"relative z-1 #{Shell.stage()} grid grid-cols-1 items-center gap-size-lg lg:grid-cols-2 lg:gap-size-xl xl:grid-cols-[minmax(0,1fr)_minmax(22rem,1.15fr)]"}>
        <div
          class="flex w-full max-w-xl flex-col items-center gap-size-md text-center lg:max-w-none lg:items-start lg:text-start"
          data-hero
        >
          <p class="m-0 text-sm font-semibold uppercase tracking-[0.2em] text-brand-text">
            {~t"SoonexI18n"}
          </p>

          <h1
            id="soonex_i18n-headline"
            class="display m-0 text-balance text-4xl tracking-tighter text-ink sm:text-5xl lg:text-6xl xl:text-7xl"
          >
            {~t"Lorem ipsum dolor"} <span class="text-brand-text">{~t"sit amet"}</span>.
          </h1>

          <p class={Shell.lede()}>
            {~t"Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."}
          </p>

          <ul
            class="m-0 grid w-full max-w-xl list-none grid-cols-1 gap-x-space-xl gap-y-space-lg p-0 sm:grid-cols-2"
            aria-label={~t"Highlights"}
          >
            <%= for line <- [
                  ~t"Lorem ipsum dolor sit amet, consectetur.",
                  ~t"Sed do eiusmod tempor incididunt ut.",
                  ~t"Ut labore et dolore magna aliqua enim.",
                  ~t"Quis nostrud exercitation ullamco laboris."
                ] do %>
              <li class="relative flex items-start gap-x-space text-pretty text-start text-sm text-ink-muted">
                <span class="mt-space-xs shrink-0 text-success-text">
                  <.heroicon name="hero-check" />
                </span>
                <span>{line}</span>
              </li>
            <% end %>
          </ul>

          <div class="flex w-full flex-wrap items-center justify-center gap-space-lg lg:justify-start">
            <.navigate to="#waitlist" class="button ui-brand ui-solid ui-size-lg">
              {~t"Join the waitlist"}
            </.navigate>
            <.navigate to={~p"/blog"} class="button ui-ghost ui-size-lg">
              {~t"Read the journal"} <.heroicon name="hero-arrow-up-right" />
            </.navigate>
          </div>
        </div>

        <div
          class="hero-countdown mx-auto w-full max-w-lg lg:mx-0 lg:max-w-none"
          aria-labelledby="hero-countdown-title"
        >
          <div class="hero-countdown__head">
            <p class="hero-countdown__eyebrow">{~t"Launching in"}</p>
            <p id="hero-countdown-title" class="hero-countdown__title">
              {~t"Lorem ipsum countdown"}
            </p>
          </div>

          <.timer
            id="soonex_i18n-hero-countdown"
            countdown
            start_ms={@countdown_ms}
            target_ms={0}
            class="timer hero-countdown__timer ui-success ui-size-xl w-full"
          >
            <:day_label>{~t"Days"}</:day_label>
            <:hour_label>{~t"Hours"}</:hour_label>
            <:minute_label>{~t"Min"}</:minute_label>
            <:second_label>{~t"Sec"}</:second_label>
          </.timer>

          <p class="hero-countdown__note">
            {~t"Consectetur adipiscing elit · launch window Q3 2026"}
          </p>
        </div>
      </div>
    </header>

    <div data-hero-sentinel aria-hidden="true" class="pointer-events-none h-px w-full shrink-0"></div>
    """
  end
end
