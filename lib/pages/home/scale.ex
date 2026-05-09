defmodule SoonexI18n.HomePage.Scale do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  attr(:stats_components, :integer, required: true)

  def scale(assigns) do
    ~H"""
    <section
      id="scale"
      class="home__section home__section--alt home__numbers-section"
      aria-labelledby="home-numbers-heading"
      data-reveal
    >
      <div class="home__section__inner">
        <h2 id="home-numbers-heading" class="sr-only text-ink-brand">
          {gettext("Corex by the numbers")}
        </h2>
        <div class="home__numbers">
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              {@stats_components}<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{gettext("Components")}</span>
            <p class="home__numbers__hint">
              {gettext(
                "Same Corex pieces in Phoenix controllers and HEEx, or static HEEx builds with Tableau."
              )}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              50<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{gettext("API & Events")}</span>
            <p class="home__numbers__hint">
              {gettext(
                "Phoenix bindings such as phx-click in HEEx, client-side wiring from your templates, alongside JavaScript and TypeScript Corex hooks."
              )}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              100<span class="home__numbers__value__suffix">%</span>
            </span>
            <span class="home__numbers__label">{gettext("Open Source")}</span>
            <p class="home__numbers__hint">
              {gettext("MIT licensed, fork, ship, and extend without a license fee.")}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              A<span class="home__numbers__value__suffix">11y</span>
            </span>
            <span class="home__numbers__label">{gettext("Built in")}</span>
            <p class="home__numbers__hint">
              {gettext(
                "Keyboard flows, focus management, and ARIA patterns powered by Zag.js state machines."
              )}
            </p>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
