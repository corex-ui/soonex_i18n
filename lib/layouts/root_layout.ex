defmodule SoonexI18n.RootLayout do
  @moduledoc false

  import Phoenix.Controller, only: [get_csrf_token: 0]

  use Tableau.Layout
  use Phoenix.Component
  use Corex
  use SoonexI18n.Routes
  use Gettext, backend: SoonexI18n.Gettext

  import SoonexI18n.Layouts.Root.Demo, only: [demo_site_controls: 1]
  import SoonexI18n.Layouts.Root.Footer, only: [site_footer: 1]
  import SoonexI18n.Layouts.Root.LandingChrome, only: [landing_chrome: 1]

  alias Phoenix.HTML
  alias Phoenix.HTML.Safe
  alias SoonexI18n.Locale

  def template(assigns) do
    locale = Locale.current(assigns.page)
    Gettext.put_locale(SoonexI18n.Gettext, Locale.lang(locale))

    site_name = "SoonexI18n"
    copyright_holder = "SoonexI18n"

    countdown_start_ms =
      max(
        DateTime.diff(~U[2026-09-01 00:00:00Z], DateTime.utc_now(), :millisecond),
        0
      )

    tableau_config =
      case Tableau.Config.get() do
        {:ok, %Tableau.Config{} = c} -> c
        %Tableau.Config{} = c -> c
      end

    base_url =
      tableau_config.url
      |> to_string()
      |> String.trim_trailing("/")

    page_path = Locale.current_path(assigns.page)
    default_loc = Locale.default_locale_string()

    canonical_url =
      if assigns.page[:page_kind] == :home and page_path == "/" <> default_loc <> "/" do
        base_url <> "/"
      else
        base_url <> page_path
      end

    og_image_url = base_url <> "/images/og.svg"

    public_path_prefix =
      SoonexI18nWeb.Endpoint.path("/")
      |> String.trim_trailing("/")

    assigns =
      assigns
      |> Map.put(:site_name, site_name)
      |> Map.put(:copyright_holder, copyright_holder)
      |> Map.put(:doc_title, document_title(assigns.page, site_name))
      |> Map.put(:doc_description, meta_description(assigns.page, site_name))
      |> Map.put(:default_theme, SoonexI18n.Theme.default_theme())
      |> Map.put(:theme, SoonexI18n.Theme.current(assigns))
      |> Map.put(:mode, SoonexI18n.Mode.current(assigns))
      |> Map.put(:locale, locale)
      |> Map.put(:countdown_start_ms, countdown_start_ms)
      |> Map.put(:canonical_url, canonical_url)
      |> Map.put(:base_url, base_url)
      |> Map.put(:page_path, page_path)
      |> Map.put(:og_image_url, og_image_url)
      |> Map.put(:public_path_prefix, public_path_prefix)
      |> Map.put(:flash, Map.get(assigns, :flash, %{}))

    ~H"""
    <!DOCTYPE html>
    <html
      class="lenis"
      lang={Locale.lang(@locale)}
      dir={Locale.dir(@locale)}
      data-theme={@theme}
      data-mode={@mode}
      data-locale={@locale}
      data-themes={Enum.join(SoonexI18n.Theme.themes(), ",")}
      data-locales={Enum.join(Locale.locales(), ",")}
      data-default-theme={SoonexI18n.Theme.default_theme()}
      data-locale-selected-path={Locale.selected_path(@page, @locale)}
      data-public-path-prefix={@public_path_prefix}
    >
      <head>
        {SoonexI18n.Theme.head_script()}
        {SoonexI18n.Mode.head_script()}
        <meta charset="utf-8" />
        <base href={"#{@base_url}/"} />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="csrf-token" content={get_csrf_token()} />

        <link rel="icon" href={~p"/images/favicon.ico"} sizes="48x48" />
        <link rel="icon" type="image/png" sizes="32x32" href={~p"/images/favicon-32x32.png"} />
        <link rel="icon" type="image/png" sizes="16x16" href={~p"/images/favicon-16x16.png"} />
        <link rel="apple-touch-icon" sizes="180x180" href={~p"/images/apple-touch-icon.png"} />
        <link
          rel="icon"
          type="image/png"
          sizes="192x192"
          href={~p"/images/android-chrome-192x192.png"}
        />
        <link
          rel="icon"
          type="image/png"
          sizes="512x512"
          href={~p"/images/android-chrome-512x512.png"}
        />
        <link rel="manifest" href={~p"/site.webmanifest"} />

        <title>{@doc_title}</title>
        <meta name="description" content={@doc_description} />

        <link rel="canonical" href={@canonical_url} />
        <%= for loc <- Locale.locales() do %>
          <link
            rel="alternate"
            hreflang={loc}
            href={@base_url <> Locale.swap_path(@page_path, loc)}
          />
        <% end %>
        <link
          rel="alternate"
          hreflang="x-default"
          href={@base_url <> Locale.swap_path(@page_path, Locale.default_locale_string())}
        />

        <meta property="og:type" content="website" />
        <meta property="og:site_name" content={@site_name} />
        <meta property="og:title" content={@doc_title} />
        <meta property="og:description" content={@doc_description} />
        <meta property="og:url" content={@canonical_url} />
        <meta property="og:image" content={@og_image_url} />
        <meta property="og:image:alt" content={@doc_title} />
        <meta property="og:image:type" content="image/svg+xml" />
        <meta property="og:image:width" content="1200" />
        <meta property="og:image:height" content="630" />

        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={@doc_title} />
        <meta name="twitter:description" content={@doc_description} />
        <meta name="twitter:image" content={@og_image_url} />

        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Figtree:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&family=Lexend:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
        />
        <link rel="stylesheet" href={~p"/css/site.css"} />
        <script type="module" src={~p"/js/site.js"} />
      </head>

      <body class="layout typo">
        <.navigate to="#main-content" class="link link--skip">{gettext("Skip to content")}</.navigate>

        <.demo_site_controls page={@page} locale={@locale} mode={@mode} />
        <.landing_chrome countdown_start_ms={@countdown_start_ms} />

        <main
          id="main-content"
          class="layout__main"
          data-landing
        >
          {render(@inner_content)}
        </main>

        <.site_footer copyright_holder={@copyright_holder} />

        <.toast_group id="layout-toast" class="toast" phx-update="ignore" flash={@flash}>
          <:loading>
            <.heroicon name="hero-arrow-path" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={gettext("We lost the connection")}
          description={gettext("We're trying to reconnect you...")}
          type={:error}
          duration={:infinity}
        />

        <%= if Mix.env() == :dev do %>
          {HTML.raw(Tableau.live_reload(assigns))}
        <% end %>
      </body>
    </html>
    """
    |> Safe.to_iodata()
  end

  defp document_title(page, site_name) do
    cond do
      md_page?(page) and present_string?(page[:title]) ->
        page[:title]

      page[:page_kind] == :home ->
        gettext("%{name} · Elixir static site template", name: site_name)

      page[:page_kind] == :not_found ->
        gettext("Page not found · %{name}", name: site_name)

      true ->
        gettext("%{name}", name: site_name)
    end
  end

  defp meta_description(page, site_name) do
    cond do
      page[:page_kind] == :home ->
        gettext(
          "Tableau + Corex coming-soon template: static HEEx, design tokens, Markdown, locales. Join the %{name} waitlist.",
          name: site_name
        )

      page[:page_kind] == :not_found ->
        gettext("This URL is not available on the %{name} static site.", name: site_name)

      present_string?(page[:description]) ->
        page[:description]

      true ->
        gettext(
          "A coming-soon static site. Learn more about %{name}.",
          name: site_name
        )
    end
  end

  defp md_page?(page), do: page[:__tableau_page_extension__] == true

  defp present_string?(v) when is_binary(v), do: String.trim(v) != ""
  defp present_string?(_), do: false
end
