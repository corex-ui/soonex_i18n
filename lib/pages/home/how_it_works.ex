defmodule SoonexI18n.HomePage.HowItWorks do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Layouts.Section, only: [block: 1]

  def how_it_works(assigns) do
    ~H"""
    <.block
      id="spotlight"
      section="spotlight"
      labelledby="soonex-spotlight-heading"
      eyebrow={~t"Workflow"}
      tone={:inverse}
      layout={:split}
      heading_size={:large}
    >
      <:title>
        {~t"From clone to live in an afternoon."}
      </:title>
      <:lede>
        {~t"Three steps, all in Mix. No Node toolchain, no parallel design system, and nothing to maintain beyond your config and your copy."}
      </:lede>
      <.tabs
        id="soonex-how-tabs"
        class="tabs tabs--wide ui-accent ui-width-full"
        value="setup"
        dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
        items={tab_items()}
      >
        <:content :let={item}>
          <div class="flex flex-col gap-5">
            <p class="m-0 text-base/7">{item.meta.intro}</p>
            <ul class="m-0 flex list-none flex-col gap-3 p-0">
              <li :for={step <- item.meta.steps} class="flex items-start gap-3 text-sm/6">
                <.heroicon name="hero-check-circle" class="mt-0.5 size-4 shrink-0" />
                <span>{step}</span>
              </li>
            </ul>
            <.clipboard
              id={"soonex-how-copy-#{item.meta.id}"}
              class="clipboard ui-accent ui-size-sm ui-width-fit"
              trigger_aria_label={~t"Copy"}
              input_aria_label={~t"Text to copy"}
              value={item.meta.command}
              dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
            >
              <:label class="sr-only">{item.meta.command}</:label>
              <:copy>
                <.heroicon name="hero-clipboard" />
                <span>{~t"Copy #{label = item.meta.command_label}"}</span>
              </:copy>
              <:copied>
                <.heroicon name="hero-check" />
                <span>{~t"Copied"}</span>
              </:copied>
            </.clipboard>
          </div>
        </:content>
      </.tabs>
    </.block>
    """
  end

  defp tab_items do
    Corex.Content.new([
      %{
        value: "setup",
        label: ~t"Setup",
        content: ~t"Setup",
        meta: %{
          id: "setup",
          intro:
            ~t"Clone the repo, fetch Hex dependencies, and build the design assets in one command.",
          steps: [
            ~t"Run mix setup from the repo root. It fetches deps and builds Corex design CSS.",
            ~t"Start the dev server with mix server and open localhost:4999.",
            ~t"Try neo, uno, duo, or leo and light or dark mode from Template Options."
          ],
          command: "mix setup",
          command_label: "mix setup"
        }
      },
      %{
        value: "customize",
        label: ~t"Customize",
        content: ~t"Customize",
        meta: %{
          id: "customize",
          intro: ~t"Make it yours with one config block and plain HEEx content modules.",
          steps: [
            ~t"Set seeds, radius, fonts, and type scale under config :corex_design.",
            ~t"Run mix corex.design.build to regenerate tokens and component CSS.",
            ~t"Edit copy in lib/pages/home, translations in priv/gettext, and the launch date in SoonexI18n.Launch."
          ],
          command: "mix corex.design.build",
          command_label: "mix corex.design.build"
        }
      },
      %{
        value: "ship",
        label: ~t"Ship",
        content: ~t"Ship",
        meta: %{
          id: "ship",
          intro:
            ~t"Build static HTML into _site/ and publish it to GitHub Pages or any static host.",
          steps: [
            ~t"Set SOONEX_PUBLIC_URL to your production origin.",
            ~t"Run MIX_ENV=prod mix build to produce _site/ with prefixed asset paths.",
            ~t"Point the waitlist form at your email provider and go live."
          ],
          command: "MIX_ENV=prod mix build",
          command_label: ~t"prod build"
        }
      }
    ])
  end
end
