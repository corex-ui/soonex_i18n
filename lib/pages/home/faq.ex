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
              "How static Tableau, the Mix asset pipeline, Corex MCP, and Markdown posts fit together—and how this repo relates to a future Phoenix SoonexI18n application template."
            )}
          </p>
        </div>

        <div class="min-w-0 w-full">
          <.accordion
            id="soonex_i18n-faq"
            class="accordion accordion--accent accordion--xl w-full max-w-6xl"
            multiple={false}
            value="stack"
            items={
              Corex.Content.new([
                %{
                  value: "stack",
                  trigger: gettext("What is SoonexI18n?"),
                  content:
                    gettext(
                      "A Tableau-driven coming-soon site that demonstrates Corex on static HTML: countdown, highlights, metrics, pricing, FAQ, waitlist, Markdown journal post, and footer—built with mix tableau.build and deployable as plain files."
                    ),
                  meta: %{icon: "hero-squares-2x2"}
                },
                %{
                  value: "tableau",
                  trigger: gettext("Which Mix tasks matter?"),
                  content:
                    gettext(
                      "mix assets.build runs soonex_i18n.palette, designex corex, Tailwind, and esbuild. mix tableau.build emits _site. In development, mix tableau.server watches HEEx and Markdown. Content lives under _posts with MDEx rendering."
                    ),
                  meta: %{icon: "hero-globe-alt"}
                },
                %{
                  value: "liveview",
                  trigger: gettext("What about Corex MCP?"),
                  content:
                    gettext(
                      "In development, Corex can expose MCP tools backed by the component registry—list_components, get_component—so assistants pull slots and modifiers instead of inventing markup. It complements Localize and Gettext for structured authoring."
                    ),
                  meta: %{icon: "hero-bolt"}
                },
                %{
                  value: "themes",
                  trigger: gettext("Themes, modes, and locales?"),
                  content:
                    gettext(
                      "data-theme and data-mode switch Neo, Uno, Duo, and Leo; theme and mode scripts in the layout sync controls and localStorage. Gettext and Localize back RTL locales such as Arabic alongside English."
                    ),
                  meta: %{icon: "hero-swatch"}
                },
                %{
                  value: "next",
                  trigger: gettext("What comes after this static template?"),
                  content:
                    gettext(
                      "A fuller Phoenix SoonexI18n application template is planned on top of the same Corex primitives—auth, data, and realtime—without throwing away this landing. Stay on the waitlist for migration notes."
                    ),
                  meta: %{icon: "hero-rocket-launch"}
                }
              ])
            }
          >
            <:trigger :let={item}>
              <span class="flex min-w-0 items-center gap-space">
                <.heroicon name={item.meta.icon} />
                <span class="min-w-0 text-start">{item.trigger}</span>
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
