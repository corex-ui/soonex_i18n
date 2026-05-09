defmodule SoonexI18n.HomePage.Waitlist do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  def waitlist(assigns) do
    ~H"""
    <section
      id="waitlist"
      class="relative flex min-h-dvh flex-col justify-center border-y border-border bg-ui-muted px-space py-size-xl"
      aria-labelledby="soonex_i18n-waitlist-heading"
      data-reveal
    >
      <div class="mx-auto flex w-full max-w-6xl flex-col items-center gap-space-xl lg:flex-row lg:items-start lg:justify-center lg:gap-x-space-xl">
        <div class="flex w-full max-w-md flex-col items-center gap-space text-center">
          <h2 id="soonex_i18n-waitlist-heading">{gettext("Be there when SoonexI18n ships.")}</h2>
          <p class="m-0">
            {gettext(
              "One launch email, optional build notes, no spam. Full Phoenix template lands after this static core. Get notified for both."
            )}
          </p>
          <ul class="m-0 flex w-full list-none flex-col gap-space-sm p-0 text-start">
            <%= for line <- [
                  gettext("Early access, two weeks before the public drop."),
                  gettext("Launch mail only: you choose product updates or silence."),
                  gettext("One-click unsubscribe; we never sell or rent your email.")
                ] do %>
              <li class="flex gap-space-sm text-start">
                <.heroicon name="hero-check" />
                <span class="text-sm">{line}</span>
              </li>
            <% end %>
          </ul>
        </div>

        <div class="w-full max-w-md min-w-0">
          <form
            id="soonex_i18n-waitlist-form"
            class="flex flex-col gap-space"
            data-waitlist-toast-title={gettext("Thanks for joining")}
            data-waitlist-toast-description={
              gettext(
                "This demo does not send or collect email. Point this form at your API or endpoint when you ship."
              )
            }
          >
            <div class="flex flex-col gap-space-sm sm:flex-row sm:items-end sm:gap-space">
              <div class="min-w-0 flex-1">
                <.native_input
                  type="email"
                  name="waitlist[email]"
                  id="soonex_i18n-waitlist-email"
                  required
                  class="native-input"
                >
                  <:label class="sr-only">{gettext("Your email")}</:label>
                  <:icon><.heroicon name="hero-envelope" class="icon" /></:icon>
                </.native_input>
              </div>
              <button
                type="submit"
                class="button button--accent button--sm"
              >
                {gettext("Join waitlist")}
              </button>
            </div>
            <.checkbox
              id="soonex_i18n-waitlist-updates"
              name="waitlist[updates]"
              checked={true}
              class="checkbox checkbox--accent"
            >
              <:indicator>
                <.heroicon name="hero-check" />
              </:indicator>
              <:label>{gettext("Send me build updates")}</:label>
            </.checkbox>
          </form>
        </div>
      </div>
    </section>
    """
  end
end
