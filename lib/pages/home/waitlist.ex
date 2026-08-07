defmodule SoonexI18n.HomePage.Waitlist do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell

  def waitlist(assigns) do
    ~H"""
    <section
      id="waitlist"
      class="flex w-full flex-col border-y border-border bg-ui-muted py-size-xl"
      aria-labelledby="soonex_i18n-waitlist-heading"
    >
      <div class={"#{Shell.stage()} flex flex-col items-center"}>
        <div class="flex w-full max-w-2xl flex-col items-center gap-size-lg text-center">
          <div class="flex w-full max-w-2xl flex-col items-center gap-size-md">
            <h2 id="soonex_i18n-waitlist-heading" class={Shell.section_heading()}>
              {~t"Lorem ipsum"} <span class="text-brand-text">{~t"SoonexI18n"}</span>
            </h2>
            <p class="m-0 max-w-2xl text-pretty text-center text-lg text-ink-muted">
              {~t"Dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
            </p>
          </div>

          <form
            id="soonex_i18n-waitlist-form"
            class="flex w-full max-w-md flex-col items-stretch gap-space"
            data-waitlist-toast-title={~t"Thanks for joining"}
            data-waitlist-toast-description={
              ~t"This demo does not send or collect email. Point this form at your API or endpoint when you ship."
            }
          >
            <div class="flex w-full items-stretch gap-space">
              <div class="min-w-0 flex-1">
                <.native_input
                  type="email"
                  name="waitlist[email]"
                  id="soonex_i18n-waitlist-email"
                  required
                  class="native-input ui-size-md ui-width-full"
                >
                  <:label class="sr-only">{~t"Your email"}</:label>
                </.native_input>
              </div>
              <button
                type="submit"
                class="button ui-brand ui-solid ui-size-md shrink-0"
              >
                {~t"Join waitlist"}
              </button>
            </div>

            <div class="flex justify-center pt-space-sm">
              <.checkbox
                id="soonex_i18n-waitlist-updates"
                name="waitlist[updates]"
                checked={true}
                class="checkbox ui-accent ui-size-md"
              >
                <:indicator>
                  <.heroicon name="hero-check" />
                </:indicator>
                <:label>{~t"Send me build updates"}</:label>
              </.checkbox>
            </div>
          </form>
        </div>
      </div>
    </section>
    """
  end
end
