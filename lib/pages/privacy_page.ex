defmodule SoonexI18n.PrivacyPage do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  @updated ~D[2026-09-01]

  def template(assigns) do
    assigns = Map.put(assigns, :updated_label, SoonexI18n.Locale.format_date(@updated))

    ~H"""
    <article class={"#{Shell.section()} bg-root"}>
      <div class={Shell.stage()}>
        <.layout_heading class="layout-heading" subtitle_tag="p">
          <:title>{~t"Privacy"}</:title>
          <:subtitle>
            {~t"This page describes how the Soonex demo handles information on your device. It is not legal advice."}
          </:subtitle>
          <:actions>
            <.navigate to={~p"/"} class="button ui-ghost ui-size-sm">
              <.heroicon name="hero-arrow-left" /> {~t"Home"}
            </.navigate>
          </:actions>
        </.layout_heading>

        <div class="typo markdown prose mt-16 min-w-0 max-w-3xl text-base/7 text-ink-muted">
          <p class="text-sm text-ink-muted">
            {~t"Last updated: #{date = @updated_label}"}
          </p>

          <h2>{~t"Who this applies to"}</h2>
          <p>
            {~t"Soonex is a static launch-page template published by Corex for demonstration and forking. When you browse the hosted demo or run it locally, the site behaves as described below. If you fork the template and deploy it under your own domain, you are responsible for updating this page and your consent banner to match your product and jurisdiction."}
          </p>

          <h2>{~t"What we do not collect"}</h2>
          <p>
            {~t"The waitlist forms on the home page are wired for UX only. Submitting an email shows a success toast but does not send your address to a server, database, or third-party list provider. There is no account system, no payment flow, and no server-side session in this template."}
          </p>

          <h2>{~t"Information stored on your device"}</h2>
          <p>
            {~t"To make the demo usable across visits, Soonex stores a small set of preferences in your browser using localStorage. These values stay on your device and are not transmitted to us."}
          </p>
          <ul>
            <li>
              <strong>{~t"Theme and color mode"}</strong>
              — {~t"which Corex theme (neo, uno, duo, leo) and light or dark mode you selected."}
            </li>
            <li>
              <strong>{~t"Accessibility settings"}</strong>
              — {~t"contrast, motion, and related choices from the accessibility panel."}
            </li>
            <li>
              <strong>{~t"Language"}</strong>
              — {~t"the language you picked last, so the site can open in it next time."}
            </li>
            <li>
              <strong>{~t"Cookie consent"}</strong>
              — {~t"whether you accepted, rejected, or customised analytics and marketing categories."}
            </li>
          </ul>
          <p>
            {~t"You can clear these at any time through your browser settings or by removing site data for this origin. The cookie banner can be reopened from the footer to change your choices."}
          </p>

          <h2>{~t"Cookie categories"}</h2>
          <p>
            {~t"The consent banner groups cookies into three categories. Only necessary storage is active by default."}
          </p>
          <ul>
            <li>
              <strong>{~t"Necessary"}</strong>
              — {~t"required for theme, accessibility, language, and remembering your consent decision. These cannot be disabled without breaking the demo experience."}
            </li>
            <li>
              <strong>{~t"Analytics"}</strong>
              — {~t"would cover measurement tags such as privacy-friendly analytics. This template does not load analytics scripts even if you allow the category."}
            </li>
            <li>
              <strong>{~t"Marketing"}</strong>
              — {~t"would cover remarketing or social pixels. This template does not load marketing tags even if you allow the category."}
            </li>
          </ul>

          <h2>{~t"Third parties"}</h2>
          <p>
            {~t"The static build may reference self-hosted fonts and images. It does not embed third-party trackers, social widgets, or hosted video players. If you add those integrations when forking the template, disclose them here and wire them through the consent module:"}
            <code dir="ltr">lib/soonex_i18n/cookie_consent.ex</code>
          </p>

          <h2>{~t"Retention"}</h2>
          <p>
            {~t"Local preference data persists until you clear it or until the browser removes it under its own storage policies. Because nothing is sent to a backend in the demo, we do not hold copies of your choices on our servers."}
          </p>

          <h2>{~t"Your rights"}</h2>
          <p>
            {~t"Depending on where you live, you may have rights to access, correct, or delete personal data. On this demo, the only data involved is what your browser stores locally; you control it directly. For a production deployment you operate, provide a contact path and process requests under your own policy."}
          </p>

          <h2>{~t"Children"}</h2>
          <p>
            {~t"The Soonex demo is a developer-facing marketing template. It is not directed at children and does not knowingly collect information from anyone under 16."}
          </p>

          <h2>{~t"Changes"}</h2>
          <p>
            {~t"We may update this page when the template changes, for example if a fork adds real list collection or analytics. The last updated date at the top will change when we do."}
          </p>

          <h2>{~t"Contact"}</h2>
          <p>
            {~t"Questions about this demo policy can be sent to"}
            <a href="mailto:info@netoum.com" class="link ui-brand" dir="ltr">info@netoum.com</a>. {~t"For production sites you deploy, replace this address with your own."}
          </p>
        </div>
      </div>
    </article>
    """
  end
end

for locale <- SoonexI18n.Locale.locales() do
  Module.create(
    Module.concat(SoonexI18n.PrivacyPage, String.upcase(locale)),
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote("/#{locale}/privacy"),
        title: "Privacy",
        page_kind: :privacy,
        sitemap: %{priority: 0.3, changefreq: "yearly"}

      def template(assigns), do: SoonexI18n.PrivacyPage.template(assigns)
    end,
    __ENV__
  )
end
