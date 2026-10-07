defmodule SoonexI18n.Layouts.Root.Footer do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.CookieConsent, only: [cookie_dialog: 1]
  import SoonexI18n.Layouts.Brand, only: [lockup: 1]

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  @github "https://github.com/corex-ui/soonex_i18n"
  @hexdocs "https://hexdocs.pm/corex"

  attr(:copyright_holder, :string, required: true)
  attr(:page_path, :string, default: "/")

  def site_footer(assigns) do
    assigns =
      assigns
      |> assign(:github, @github)
      |> assign(:hexdocs, @hexdocs)

    ~H"""
    <footer class="soonex-footer mt-auto border-t border-border bg-root py-16 sm:py-20">
      <div class={Shell.stage_wide()}>
        <div class="grid grid-cols-1 gap-12 lg:grid-cols-12 lg:gap-16">
          <div class="lg:col-span-4">
            <.lockup />
            <p class="mt-4 max-w-xs text-sm/6 text-ink-muted">
              {~t"The launch page kit for Phoenix teams. Static HTML, accessible Corex components, and a waitlist that is ready on day one."}
            </p>
          </div>
          <div class="grid grid-cols-2 gap-8 sm:grid-cols-3 lg:col-span-8">
            <div>
              <p class="m-0 text-sm/6 font-medium text-ink">{~t"Product"}</p>
              <ul class="mt-4 flex list-none flex-col gap-3 p-0">
                <li>
                  <.navigate
                    to={Locale.home_anchor(@page_path, "capabilities")}
                    class="link ui-nav ui-size-sm"
                  >
                    {~t"Capabilities"}
                  </.navigate>
                </li>
                <li>
                  <.navigate
                    to={Locale.home_anchor(@page_path, "spotlight")}
                    class="link ui-nav ui-size-sm"
                  >
                    {~t"Workflow"}
                  </.navigate>
                </li>
                <li>
                  <.navigate
                    to={Locale.home_anchor(@page_path, "proof")}
                    class="link ui-nav ui-size-sm"
                  >
                    {~t"Why Soonex"}
                  </.navigate>
                </li>
              </ul>
            </div>
            <div>
              <p class="m-0 text-sm/6 font-medium text-ink">{~t"Journal"}</p>
              <ul class="mt-4 flex list-none flex-col gap-3 p-0">
                <li>
                  <.navigate to={~p"/blog"} class="link ui-nav ui-size-sm">
                    {~t"All posts"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/tags"} class="link ui-nav ui-size-sm">
                    {~t"Tags"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={SoonexI18n.Public.path("/feed.xml")} class="link ui-nav ui-size-sm">
                    RSS
                  </.navigate>
                </li>
              </ul>
            </div>
            <div>
              <p class="m-0 text-sm/6 font-medium text-ink">{~t"Elsewhere"}</p>
              <ul class="mt-4 flex list-none flex-col gap-3 p-0">
                <li>
                  <.navigate to={@github} class="link ui-nav ui-size-sm" external>
                    GitHub
                  </.navigate>
                </li>
                <li>
                  <.navigate to={@hexdocs} class="link ui-nav ui-size-sm" external>
                    Hexdocs
                  </.navigate>
                </li>
                <li>
                  <.navigate
                    to={Locale.home_anchor(@page_path, "waitlist")}
                    class="link ui-nav ui-size-sm"
                  >
                    {~t"Waitlist"}
                  </.navigate>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div class="mt-16 flex flex-col gap-4 border-t border-border pt-8 sm:flex-row sm:items-center sm:justify-between">
          <div class="flex flex-col gap-2">
            <p class="m-0 text-sm/6 text-ink-muted">
              © {Date.utc_today().year} {@copyright_holder}
            </p>
            <p class="m-0 text-xs/6 text-ink-muted">{SoonexI18n.Layouts.Media.credits()}</p>
            <div class="flex flex-wrap items-center gap-x-4 gap-y-2">
              <.navigate
                to={~p"/privacy"}
                class="link ui-nav ui-size-sm text-ink-muted"
              >
                {~t"Privacy"}
              </.navigate>
              <.cookie_dialog />
            </div>
          </div>
          <.navigate to="#main-content" class="link ui-nav ui-size-sm text-ink-muted">
            {~t"Back to top ↑"}
          </.navigate>
        </div>
      </div>
    </footer>
    """
  end
end
