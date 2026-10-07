defmodule SoonexI18n.HomePage.Faq do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Layouts.Section, only: [block: 1]

  def faq(assigns) do
    ~H"""
    <.block
      id="questions"
      section="faq"
      labelledby="soonex-faq-heading"
      eyebrow={~t"Questions"}
      layout={:sticky}
      tone={:root}
    >
      <:title>
        {~t"Questions, answered."}
      </:title>
      <:lede>
        {~t"The short version: one config block for the look, plain HEEx modules for the words, and static HTML at the end."}
      </:lede>
      <:actions>
        <.navigate to="#waitlist" class="link ui-accent">
          {~t"Join waitlist"} <.heroicon name="hero-arrow-down" />
        </.navigate>
      </:actions>
      <.accordion
        id="soonex-faq"
        class="accordion ui-accent ui-size-md ui-width-full"
        multiple={false}
        collapsible
        value="corex"
        dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
        items={faq_items()}
      >
        <:trigger :let={item}>
          <span class="min-w-0 text-start">{item.label}</span>
        </:trigger>
        <:content :let={item}>
          <div class="flex flex-col gap-4">
            <p class="m-0 text-sm/6 sm:text-base/7">{item.content}</p>
            <.navigate :if={item.value == "customize"} to="#spotlight" class="link ui-accent w-fit">
              {~t"See the workflow"} <.heroicon name="hero-arrow-down" />
            </.navigate>
            <.navigate :if={item.value == "waitlist"} to="#waitlist" class="link ui-accent w-fit">
              {~t"Open the waitlist"} <.heroicon name="hero-arrow-down" />
            </.navigate>
            <.clipboard
              :if={item.value == "toolchain"}
              id="soonex-faq-setup"
              class="clipboard ui-accent ui-size-sm ui-width-fit self-start"
              trigger_aria_label={~t"Copy"}
              input_aria_label={~t"Text to copy"}
              value="mix setup"
              dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
            >
              <:label class="sr-only">mix setup</:label>
              <:copy>
                <.heroicon name="hero-clipboard" />
                <span>{~t"Copy"}</span>
              </:copy>
              <:copied>
                <.heroicon name="hero-check" />
                <span>{~t"Copied"}</span>
              </:copied>
            </.clipboard>
          </div>
        </:content>
        <:indicator>
          <.heroicon name="hero-chevron-right" />
        </:indicator>
      </.accordion>
    </.block>
    """
  end

  defp faq_items do
    Corex.Content.new([
      %{
        value: "corex",
        label: ~t"What is Corex, and why does Soonex use it?",
        content:
          ~t"Corex is an accessible UI kit for Phoenix. Soonex uses its static-site integration: design tokens from config :corex_design, ui-* modifiers in HEEx, and client hooks that bring widgets to life without a server."
      },
      %{
        value: "customize",
        label: ~t"How do I change colors and typography?",
        content:
          ~t"Edit seeds, dimensions, and typography under config :corex_design, then run mix corex.design.build. Light and dark modes regenerate from the same config."
      },
      %{
        value: "waitlist",
        label: ~t"Where do waitlist signups go?",
        content:
          ~t"Nowhere until you connect a provider. Out of the box, submitting shows a confirmation toast and stores nothing. The field names are ready to post to Buttondown, ConvertKit, or your own endpoint."
      },
      %{
        value: "toolchain",
        label: ~t"Do I need npm?",
        content:
          ~t"No. Mix, Tailwind, and esbuild ship in the repo. There is no package.json — run mix setup and mix server to work locally."
      },
      %{
        value: "a11y",
        label: ~t"What do the accessibility controls do?",
        content:
          ~t"The person icon opens Corex accessibility settings: text size, contrast, motion, cursor, focus, and link underline. Choices persist in localStorage on this device."
      }
    ])
  end
end
