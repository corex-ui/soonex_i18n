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
        <h2 id="home-numbers-heading" class="sr-only">
          {gettext("Corex by the numbers")}
        </h2>
        <div class="home__numbers">
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              {@stats_components}<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{gettext("Components")}</span>
            <p class="home__numbers__hint">
              {gettext("Works in Controller and Live View")}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              100<span class="home__numbers__value__suffix">+</span>
            </span>
            <span class="home__numbers__label">{gettext("API & Events")}</span>
            <p class="home__numbers__hint">
              {gettext("From the Server and the Client")}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              100<span class="home__numbers__value__suffix">%</span>
            </span>
            <span class="home__numbers__label">{gettext("Open Source")}</span>
            <p class="home__numbers__hint">
              {gettext("Open Source and free to use. MIT License")}
            </p>
          </div>
          <div class="home__numbers__cell">
            <span class="home__numbers__value">
              A<span class="home__numbers__value__suffix">11y</span>
            </span>
            <span class="home__numbers__label">{gettext("Built in")}</span>
            <p class="home__numbers__hint">
              {gettext("Keyboard, focus and ARIA from Zag.js machines.")}
            </p>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
