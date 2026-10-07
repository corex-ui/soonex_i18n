defmodule SoonexI18n.HomePage.Hero do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  def hero(assigns) do
    ~H"""
    <header
      class={"#{Shell.section_hero()} bg-root"}
      aria-labelledby="soonex-headline"
      data-section="hero"
    >
      <div class={Shell.stage_wide()}>
        <div class="grid grid-cols-1 gap-10 lg:grid-cols-12 lg:items-end lg:gap-16">
          <div class="lg:col-span-8">
            <p class="badge ui-size-sm m-0 w-fit">
              <span>{~t"Doors open #{date = SoonexI18n.Launch.year_label()}"}</span>
            </p>
            <h1 id="soonex-headline" class={"#{Shell.display_heading()} mt-8"}>
              {~t"Launch pages that feel finished before you ship."}
            </h1>
          </div>

          <div class="lg:col-span-4 lg:pb-3">
            <p class="m-0 max-w-md text-pretty text-base/7 text-ink-muted sm:text-lg/8">
              {~t"Soonex turns a Phoenix team's coming-soon page into static HTML with accessible Corex components, four tuned themes, and a waitlist that works from day one."}
            </p>
            <div class="mt-8 flex flex-wrap items-center gap-3">
              <.navigate to="#waitlist" class={Shell.primary_button_md()}>
                {~t"Join the waitlist"}
              </.navigate>
              <.navigate to="#preview" class={Shell.secondary_button_md()}>
                {~t"See it in action"} <.heroicon name="hero-arrow-down" />
              </.navigate>
            </div>
          </div>
        </div>

        <div class={"#{Shell.photo_frame()} mt-14 aspect-[4/5] sm:mt-20 sm:aspect-[16/9] lg:aspect-[21/9]"}>
          <img
            src={SoonexI18n.Public.path("/images/photos/hero.jpg")}
            alt=""
            width="2400"
            height="1500"
            fetchpriority="high"
            decoding="async"
            class={Shell.photo_fill()}
          />
          <div class="absolute inset-x-4 bottom-4 sm:inset-x-auto sm:bottom-8 sm:start-8">
            <div class={"#{Shell.panel()} w-full shadow-2xl sm:w-auto"}>
              <p class={Shell.eyebrow()}>{~t"Countdown to launch"}</p>
              <.timer
                id="soonex-hero-timer"
                countdown
                start_ms={SoonexI18n.Launch.countdown_ms()}
                target_ms={0}
                dir={Locale.dir(Locale.current())}
                class="timer ui-accent ui-size-sm mt-3"
              >
                <:day_label>{~t"days"}</:day_label>
                <:hour_label>{~t"hours"}</:hour_label>
                <:minute_label>{~t"min"}</:minute_label>
                <:second_label>{~t"sec"}</:second_label>
              </.timer>
            </div>
          </div>
        </div>
      </div>
    </header>
    """
  end
end
