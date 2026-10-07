defmodule SoonexI18n.HomePage.Showcase do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Layouts.Section, only: [block: 1]

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  def showcase(assigns) do
    assigns = assign(assigns, :config_snippet, config_snippet())

    ~H"""
    <.block
      id="preview"
      section="preview"
      labelledby="soonex-preview-heading"
      eyebrow={~t"Live preview"}
      tone={:photo}
      photo="/images/photos/texture.jpg"
    >
      <:title>
        {~t"Real components, not screenshots."}
      </:title>
      <:lede>
        {~t"Every control on this page is a Corex component rendered to static HTML and hydrated in the browser. Switch themes in Template Options and watch the whole page follow."}
      </:lede>

      <div class={"#{Shell.frame()} shadow-2xl"}>
        <div class="grid grid-cols-1 lg:grid-cols-12">
          <div class="flex flex-col border-b border-border p-8 sm:p-10 lg:col-span-5 lg:border-b-0 lg:border-e">
            <p class={Shell.eyebrow()}>{~t"One config"}</p>
            <h3 class="display mt-3 text-2xl font-medium tracking-tight text-ink">
              {~t"Brand once, everywhere."}
            </h3>
            <p class="mt-3 text-sm/6 text-ink-muted sm:text-base/7">
              {~t"Seeds, radius, and type scale live in a single block. Rebuild and every button, field, and panel picks up the change."}
            </p>
            <pre dir="ltr" class="code code--wide mt-8 overflow-x-auto p-4 text-xs/6 sm:text-sm/6"><code>{@config_snippet}</code></pre>
            <.clipboard
              id="soonex-preview-copy"
              class="clipboard ui-accent ui-size-sm ui-width-fit mt-6"
              trigger_aria_label={~t"Copy"}
              input_aria_label={~t"Text to copy"}
              value="mix corex.design.build"
              dir={Locale.dir(Locale.current())}
            >
              <:label class="sr-only">mix corex.design.build</:label>
              <:copy>
                <.heroicon name="hero-clipboard" />
                <span>{~t"Copy build command"}</span>
              </:copy>
              <:copied>
                <.heroicon name="hero-check" />
                <span>{~t"Copied"}</span>
              </:copied>
            </.clipboard>
          </div>

          <div class="flex flex-col gap-8 p-8 sm:p-10 lg:col-span-7">
            <div class="flex flex-wrap items-center justify-between gap-4">
              <p class={Shell.eyebrow()}>{~t"Live UI"}</p>
              <div class="flex flex-wrap items-center gap-2">
                <span class="badge ui-size-sm">{~t"WCAG AA"}</span>
                <span class="badge ui-size-sm">{~t"Light and dark"}</span>
              </div>
            </div>

            <.tabs
              id="soonex-preview-tabs"
              class="tabs tabs--wide ui-accent ui-width-full"
              value="tokens"
              dir={Locale.dir(Locale.current())}
              items={tab_items()}
            >
              <:content :let={item}>
                <div class="flex flex-col gap-4">
                  <p class="m-0 text-base/7">{item.meta.intro}</p>
                  <ul class="m-0 flex list-none flex-col gap-3 p-0">
                    <li :for={point <- item.meta.points} class="flex items-start gap-3 text-sm/6">
                      <.heroicon name="hero-check-circle" class="mt-0.5 size-4 shrink-0" />
                      <span>{point}</span>
                    </li>
                  </ul>
                </div>
              </:content>
            </.tabs>

            <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
              <.native_input
                type="email"
                name="preview[email]"
                id="soonex-preview-email"
                placeholder="you@company.com"
                class="native-input ui-size-sm ui-width-full"
                readonly
              >
                <:label>{~t"Work email"}</:label>
              </.native_input>
              <.switch
                id="soonex-preview-switch"
                name="preview[notes]"
                checked
                class="switch ui-accent"
                dir={Locale.dir(Locale.current())}
              >
                <:label>{~t"Send launch notes"}</:label>
              </.switch>
            </div>

            <div class="flex flex-wrap items-center gap-3 border-t border-border pt-6">
              <span class={Shell.primary_button()}>{~t"Join waitlist"}</span>
              <span class="button ui-ghost ui-size-sm">{~t"Maybe later"}</span>
            </div>
          </div>
        </div>
      </div>
    </.block>
    """
  end

  defp tab_items do
    Corex.Content.new([
      %{
        value: "tokens",
        label: ~t"Tokens",
        content: ~t"Tokens",
        meta: %{
          intro:
            ~t"Colors are generated from a handful of seeds, so contrast holds in every mode.",
          points: [
            ~t"Light and dark palettes regenerate from the same seeds.",
            ~t"Ink, surface, and accent pairs are checked for readable contrast.",
            ~t"Four starting themes: neo, uno, duo, and leo."
          ]
        }
      },
      %{
        value: "hooks",
        label: ~t"Interactivity",
        content: ~t"Interactivity",
        meta: %{
          intro:
            ~t"Static pages still get real widgets, with no Phoenix server running behind them.",
          points: [
            ~t"Tabs, accordion, select, timer, and marquee hydrate on the client.",
            ~t"Keyboard and screen reader behavior comes from Zag state machines.",
            ~t"Hooks load lazily, so the first paint stays light."
          ]
        }
      },
      %{
        value: "a11y",
        label: ~t"Accessibility",
        content: ~t"Accessibility",
        meta: %{
          intro: ~t"Visitors can tune the page to how they read, and it remembers their choice.",
          points: [
            ~t"Text size, contrast, motion, focus ring, and link underline controls.",
            ~t"Preferences persist locally with no account or backend.",
            ~t"The test suite runs axe against the home page in headless Chrome."
          ]
        }
      }
    ])
  end

  defp config_snippet do
    """
    config :corex_design,
      default_theme: :neo,
      themes: %{
        neo: %{seeds: %{accent: "#7c5cff"}}
      }
    """
    |> String.trim()
  end
end
