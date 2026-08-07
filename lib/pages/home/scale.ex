defmodule SoonexI18n.HomePage.Scale do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell

  attr(:stats_components, :integer, required: true)

  def scale(assigns) do
    ~H"""
    <section
      id="scale"
      class={"#{Shell.section()} home__numbers-section bg-ui-muted"}
      aria-labelledby="home-numbers-heading"
    >
      <div class={"#{Shell.stage()} home-stack flex flex-col"}>
        <p
          id="home-numbers-heading"
          class="m-0 text-sm font-semibold uppercase tracking-[0.18em] text-brand-text"
        >
          {~t"Lorem ipsum metrics"}
        </p>

        <div class="home__numbers rounded-xl border border-border bg-root">
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              {@stats_components}<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{~t"Lorem"}</span>
            <p class="home__numbers__hint">
              {~t"Ipsum dolor sit amet, consectetur adipiscing elit sed do."}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              50<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{~t"Ipsum"}</span>
            <p class="home__numbers__hint">
              {~t"Eiusmod tempor incididunt ut labore et dolore magna."}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              100<span class="home__numbers__value__suffix">%</span>
            </span>
            <span class="home__numbers__label">{~t"Dolor"}</span>
            <p class="home__numbers__hint">
              {~t"Ut enim ad minim veniam, quis nostrud exercitation."}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              A<span class="home__numbers__value__suffix">11y</span>
            </span>
            <span class="home__numbers__label">{~t"Sit amet"}</span>
            <p class="home__numbers__hint">
              {~t"Ullamco laboris nisi ut aliquip ex ea commodo consequat."}
            </p>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
