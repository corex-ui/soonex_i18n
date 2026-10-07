defmodule SoonexI18n.HomePage.Waitlist do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  alias SoonexI18n.Layouts.Shell

  def waitlist(assigns) do
    assigns = assign(assigns, :role_items, role_items())

    ~H"""
    <section
      id="waitlist"
      data-section="waitlist"
      class={"#{Shell.section()} bg-root"}
      aria-labelledby="soonex-waitlist-heading"
    >
      <div class={Shell.stage_wide()}>
        <div class={"#{Shell.photo_frame()} px-6 py-14 sm:px-12 sm:py-20 lg:px-16 lg:py-24"}>
          <img
            src={SoonexI18n.Public.path("/images/photos/closing.jpg")}
            alt=""
            width="2000"
            height="1125"
            loading="lazy"
            decoding="async"
            class={Shell.photo_fill()}
          />
          <div class="absolute inset-0 -z-10 bg-black/55" aria-hidden="true"></div>

          <div class="grid grid-cols-1 gap-12 lg:grid-cols-12 lg:items-center lg:gap-16">
            <div class="lg:col-span-6">
              <p class={"#{Shell.eyebrow()} text-white/75"}>{~t"Early access"}</p>
              <h2 id="soonex-waitlist-heading" class={"#{Shell.on_photo_heading()} mt-3"}>
                {~t"Be first through the door."}
              </h2>
              <p class={Shell.on_photo_body()}>
                {~t"Join the list for launch day access, release notes, and the occasional behind-the-scenes post. No spam, unsubscribe anytime."}
              </p>
            </div>

            <div class="lg:col-span-6">
              <div class={"#{Shell.panel_open()} shadow-2xl sm:p-10"}>
                <form
                  id="soonex-waitlist-form"
                  class="flex w-full flex-col items-stretch gap-5"
                  data-waitlist-toast-title={~t"You're on the list"}
                  data-waitlist-toast-description={
                    ~t"Thanks for signing up. Connect your email provider to start collecting real addresses."
                  }
                >
                  <.native_input
                    type="email"
                    name="waitlist[email]"
                    id="soonex-waitlist-email"
                    required
                    autocomplete="email"
                    placeholder="you@company.com"
                    class="native-input ui-size-md ui-width-full"
                  >
                    <:label>{~t"Work email"}</:label>
                  </.native_input>

                  <.select
                    id="soonex-waitlist-role"
                    name="waitlist[role]"
                    class="select ui-accent ui-size-md ui-width-full"
                    value={["founder"]}
                    dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
                    items={@role_items}
                    positioning={
                      %Corex.Positioning{
                        strategy: "absolute",
                        placement: "bottom-start",
                        same_width: true,
                        gutter: 8,
                        slide: false,
                        fit_viewport: false,
                        flip: false
                      }
                    }
                  >
                    <:label>{~t"I am a"}</:label>
                    <:trigger>
                      <.heroicon name="hero-chevron-down" />
                    </:trigger>
                  </.select>

                  <.switch
                    id="soonex-waitlist-notes"
                    name="waitlist[notes]"
                    checked
                    class="switch ui-accent"
                    dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}
                  >
                    <:label>{~t"Email me launch notes"}</:label>
                  </.switch>

                  <button type="submit" class={"#{Shell.primary_button_md()} w-full"}>
                    {~t"Join the waitlist"}
                  </button>
                  <p class="m-0 text-xs/5 text-ink-muted">
                    {~t"This form is not connected to a provider yet, so nothing you enter is stored."}
                  </p>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp role_items do
    Corex.List.new([
      %{label: ~t"Founder", value: "founder"},
      %{label: ~t"Engineer", value: "engineer"},
      %{label: ~t"Designer", value: "designer"},
      %{label: ~t"Marketer", value: "marketer"}
    ])
  end
end
