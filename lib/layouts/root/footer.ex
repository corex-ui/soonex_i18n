defmodule SoonexI18n.Layouts.Root.Footer do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext
  use SoonexI18n.Routes

  attr(:copyright_holder, :string, required: true)

  def site_footer(assigns) do
    ~H"""
    <footer class="layout__footer">
      <div class="layout__footer__content">
        <div class="grid gap-space-xl lg:grid-cols-12 lg:gap-space-lg">
          <div class="flex flex-col gap-space lg:col-span-4">
            <span class="badge badge--accent w-fit">
              {gettext("Coming soon · Q3 2026")}
            </span>
            <h2>
              {gettext("Be there when SoonexI18n ships.")}
            </h2>
            <p class="text-ink-muted max-w-prose">
              {gettext("One email at launch. Optional build updates. No spam, no resale, ever.")}
            </p>
            <.navigate to={~p"/" <> "#waitlist"} class="button button--accent w-fit">
              {gettext("Join the waitlist")}
            </.navigate>
          </div>

          <nav
            class="grid grid-cols-2 gap-space-lg sm:grid-cols-4 lg:col-span-8"
            aria-label={gettext("Footer navigation")}
          >
            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {gettext("Product")}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space-sm p-0">
                <li>
                  <.navigate to={~p"/" <> "#highlights"} class="link link--accent">
                    {gettext("Highlights")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#scale"} class="link link--accent">
                    {gettext("Scale")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#pricing"} class="link link--accent">
                    {gettext("Pricing")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#faq"} class="link link--accent">
                    {gettext("FAQ")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#waitlist"} class="link link--accent">
                    {gettext("Waitlist")}
                  </.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {gettext("Resources")}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space-sm p-0">
                <li>
                  <.navigate to="#" class="link link--accent">
                    {gettext("GitHub")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/docs"} class="link link--accent">
                    {gettext("Documentation")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {gettext("Changelog")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#highlights"} class="link link--accent">
                    {gettext("Templates")}
                  </.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {gettext("Company")}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space-sm p-0">
                <li>
                  <.navigate to="#" class="link link--accent">{gettext("About")}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {gettext("Contact")}
                  </.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">{gettext("Press")}</.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {gettext("Legal")}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space-sm p-0">
                <li>
                  <.navigate to="#" class="link link--accent">{gettext("Privacy")}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">{gettext("Terms")}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {gettext("License")}
                  </.navigate>
                </li>
              </ul>
            </div>
          </nav>
        </div>

        <hr class="my-space-xl border-0 border-t border-border" />

        <div class="flex flex-col gap-space sm:flex-row sm:items-center sm:justify-between">
          <p class="text-ink-muted m-0 text-sm">
            © {Date.utc_today().year} {@copyright_holder} · MIT
          </p>
          <div
            class="flex flex-wrap items-center gap-space"
            aria-label={gettext("Social links")}
          >
            <.navigate
              to="#"
              class="button button--circle button--ghost"
              aria_label="GitHub"
            >
              <.heroicon name="hero-code-bracket-square" />
            </.navigate>
            <.navigate
              to="#"
              class="button button--circle button--ghost"
              aria_label="X / Twitter"
            >
              <.heroicon name="hero-megaphone" />
            </.navigate>
            <.navigate
              to={~p"/feed.xml"}
              class="button button--circle button--ghost"
              aria_label="RSS"
            >
              <.heroicon name="hero-rss" />
            </.navigate>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
