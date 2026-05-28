defmodule SoonexI18n.Layouts.Root.Footer do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  attr(:copyright_holder, :string, required: true)

  def site_footer(assigns) do
    ~H"""
    <footer class="layout__footer">
      <div class="layout__footer__content">
        <div class="grid gap-space-xl lg:grid-cols-12 lg:gap-space-lg">
          <div class="flex flex-col gap-space-lg lg:col-span-4">
            <span class="badge badge--accent w-fit">
              {~t"Coming soon · Q3 2026"}
            </span>
            <h2>
              {~t"Be there when SoonexI18n ships."}
            </h2>
            <p class="max-w-prose leading-relaxed text-ink-muted">
              {~t"One email at launch. Optional build updates. No spam, no resale, ever."}
            </p>
            <.navigate to={~p"/" <> "#waitlist"} class="button button--accent w-fit">
              {~t"Join the waitlist"}
            </.navigate>
          </div>

          <nav
            class="grid grid-cols-2 gap-space-lg sm:grid-cols-4 lg:col-span-8"
            aria-label={~t"Footer navigation"}
          >
            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {~t"Product"}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space p-0">
                <li>
                  <.navigate to={~p"/" <> "#highlights"} class="link link--accent">
                    {~t"Highlights"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#scale"} class="link link--accent">
                    {~t"Scale"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#pricing"} class="link link--accent">
                    {~t"Pricing"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#faq"} class="link link--accent">
                    {~t"FAQ"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#waitlist"} class="link link--accent">
                    {~t"Waitlist"}
                  </.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {~t"Resources"}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space p-0">
                <li>
                  <.navigate to="#" class="link link--accent">
                    {~t"GitHub"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/docs"} class="link link--accent">
                    {~t"Documentation"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {~t"Changelog"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to={~p"/" <> "#highlights"} class="link link--accent">
                    {~t"Templates"}
                  </.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {~t"Company"}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space p-0">
                <li>
                  <.navigate to="#" class="link link--accent">{~t"About"}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {~t"Contact"}
                  </.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">{~t"Press"}</.navigate>
                </li>
              </ul>
            </div>

            <div class="flex min-w-0 flex-col gap-space-sm">
              <p class="ui-label uppercase tracking-widest text-ink-muted">
                {~t"Legal"}
              </p>
              <ul class="m-0 flex list-none flex-col gap-space p-0">
                <li>
                  <.navigate to="#" class="link link--accent">{~t"Privacy"}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">{~t"Terms"}</.navigate>
                </li>
                <li>
                  <.navigate to="#" class="link link--accent">
                    {~t"License"}
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
            aria-label={~t"Social links"}
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
