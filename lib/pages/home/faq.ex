defmodule SoonexI18n.HomePage.Faq do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  def faq(assigns) do
    ~H"""
    <section
      id="faq"
      class="relative flex min-h-dvh flex-col justify-start border-y border-border px-space py-size-xl"
      aria-labelledby="soonex_i18n-faq-heading"
      data-reveal
    >
      <div class="mx-auto flex w-full max-w-6xl flex-col gap-size">
        <div class="layout__section-intro">
          <h2 id="soonex_i18n-faq-heading">{gettext("FAQ")}</h2>
          <p>
            {gettext(
              "How static Tableau, Corex MCP, Markdown posts, and the asset side of this repo fit together, and how it relates to a future Phoenix SoonexI18n application template."
            )}
          </p>
        </div>

        <div class="min-w-0 w-full">
          <.accordion
            id="soonex_i18n-faq"
            class="accordion accordion--accent accordion--sm sm:accordion--md lg:accordion--xl w-full max-w-6xl"
            multiple={false}
            value="stack"
            items={
              Corex.Content.new([
                %{
                  value: "stack",
                  label: gettext("What is SoonexI18n?"),
                  content:
                    gettext(
                      "A Tableau-driven coming-soon site that demonstrates Corex on static HTML: countdown, highlights, metrics, pricing, FAQ, waitlist, Markdown journal post, and footer. Tableau emits files you can host on GitHub Pages, S3, or any CDN."
                    ),
                  meta: %{icon: "hero-squares-2x2"}
                },
                %{
                  value: "tableau",
                  label: gettext("How do builds and previews work?"),
                  content:
                    gettext(
                      "The asset alias refreshes palette JSON, Designex, Tailwind, and esbuild. Tableau writes _site for production. The dev server watches HEEx and Markdown while you work. Journal posts live under _posts and render through MDEx."
                    ),
                  meta: %{icon: "hero-globe-alt"}
                },
                %{
                  value: "liveview",
                  label: gettext("What about Corex MCP?"),
                  content:
                    gettext(
                      "In development, Corex can expose MCP tools backed by the component registry, list_components, get_component, so assistants pull slots and modifiers instead of inventing markup. It complements Localize and Gettext for structured authoring."
                    ),
                  meta: %{icon: "hero-bolt"}
                },
                %{
                  value: "themes",
                  label: gettext("Themes, modes, and locales?"),
                  content:
                    gettext(
                      "data-theme and data-mode switch Neo, Uno, Duo, and Leo; theme and mode scripts in the layout sync controls and localStorage. Gettext and Localize back RTL locales such as Arabic alongside English."
                    ),
                  meta: %{icon: "hero-swatch"}
                },
                %{
                  value: "next",
                  label: gettext("What comes after this static template?"),
                  content:
                    gettext(
                      "A fuller Phoenix SoonexI18n application template is planned on top of the same Corex primitives, auth, data, and realtime, without throwing away this landing. Stay on the waitlist for migration notes."
                    ),
                  meta: %{icon: "hero-rocket-launch"}
                }
              ])
            }
          >
            <:trigger :let={item}>
              <span class="flex min-w-0 items-center gap-space">
                <.heroicon name={item.meta.icon} />
                <span class="min-w-0 text-start">{item.label}</span>
              </span>
            </:trigger>
            <:content :let={item}>
              <p>{item.content}</p>
            </:content>
            <:indicator>
              <.heroicon name="hero-chevron-right" />
            </:indicator>
          </.accordion>
        </div>

        <p class="m-0 text-center text-sm">
          {gettext("Still deciding?")}
          <.navigate to="#waitlist" class="link link--brand">{gettext("Join the waitlist")}</.navigate>. {gettext(
            "We ship quietly and read every reply."
          )}
        </p>
      </div>
    </section>
    """
  end
end
