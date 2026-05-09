defmodule SoonexI18n.HomePage.Highlights do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  def highlights(assigns) do
    ~H"""
    <section
      id="highlights"
      class="relative flex min-h-dvh flex-col justify-center border-y border-border bg-root px-space py-size-xl"
      aria-labelledby="soonex_i18n-highlights-heading"
      data-reveal
    >
      <div class="mx-auto flex w-full max-w-6xl flex-col gap-size">
        <div class="layout__section-intro gap-space-lg pb-space-lg">
          <h2 id="soonex_i18n-highlights-heading">{gettext("Elixir from palette to page.")}</h2>
          <p>
            {gettext(
              "Palette, Corex, and Tailwind v4 read the same tokens. Scripts bundle from one app. Tableau ships static HTML built from HEEx you would use with LiveView, compiled ahead of deploy."
            )}
          </p>
        </div>

        <.marquee
          id="soonex_i18n-marquee"
          class="marquee marquee--accent max-w-none"
          duration={28}
          spacing="2.5rem"
          pause_on_interaction={false}
          items={[
            %{label: gettext("Tableau static")},
            %{label: gettext("Tableau dev server")},
            %{label: gettext("Palette and assets")},
            %{label: gettext("Design tokens")},
            %{label: gettext("Tailwind v4")},
            %{label: gettext("Corex MCP")},
            %{label: gettext("Markdown posts")},
            %{label: gettext("Gettext + Localize")}
          ]}
        >
          <:item :let={item}>
            <span class="text-2xl font-semibold tracking-tight text-ink">{item.label}</span>
            <span class="text-ink-muted" aria-hidden="true">·</span>
          </:item>
        </.marquee>

        <ul class="m-0 grid list-none gap-space p-0 lg:grid-cols-3" data-stagger>
          <%= for card <- [
                 %{
                   title: gettext("Static build, Elixir-native"),
                   body:
                     gettext(
                       "Author in HEEx and Markdown under Tableau. Output is plain HTML, CSS, and ESM. Host on GitHub Pages, S3, or any CDN without a Node runtime on the edge."
                     )
                 },
                 %{
                   title: gettext("Design pipeline in one app"),
                   body:
                     gettext(
                       "Palette JSON feeds Designex and Corex component CSS. Tailwind v4 reads the same tokens so utilities and components stay aligned without hand-synced spreadsheets."
                     )
                 },
                 %{
                   title: gettext("MCP-aware components"),
                   body:
                     gettext(
                       "Corex exposes a component registry and MCP tools in development so assistants resolve slots, modifiers, and anatomy instead of guessing markup."
                     )
                 }
               ] do %>
            <li class="min-w-0 rounded-xl border border-border bg-layer p-space-lg">
              <h3>{card.title}</h3>
              <p>{card.body}</p>
            </li>
          <% end %>
        </ul>
      </div>
    </section>
    """
  end
end
