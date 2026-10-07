defmodule SoonexI18n.RootLayout do
  @moduledoc false

  import Phoenix.Controller, only: [get_csrf_token: 0]

  use Tableau.Layout
  use Phoenix.Component
  use Corex
  use SoonexI18n.Routes
  use SoonexI18n.GettextSigil

  import SoonexI18n.CookieConsent, only: [cookie_consent: 1]
  import SoonexI18n.Layouts.Root.Demo, only: [demo_site_controls: 1]
  import SoonexI18n.Layouts.Root.Footer, only: [site_footer: 1]
  import SoonexI18n.Layouts.Root.Nav, only: [site_nav: 1]

  alias Phoenix.HTML
  alias Phoenix.HTML.Safe
  alias SoonexI18n.Locale

  def template(assigns) do
    locale = Locale.current(assigns.page)
    Gettext.put_locale(SoonexI18n.Gettext, Locale.lang(locale))

    site_name = "Soonex"
    copyright_holder = "Soonex"

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

    canonical_url =
      if assigns.page[:page_kind] == :home and
           page_path in ["/", "/" <> Locale.default_locale_string() <> "/"] do
        base_url <> "/"
      else
        base_url <> page_path
      end

    public_path_prefix =
      SoonexI18nWeb.Endpoint.path("/")
      |> String.trim_trailing("/")

    rtl_locales =
      Locale.locales()
      |> Enum.filter(&(Locale.dir(&1) == "rtl"))
      |> Enum.join(",")

    og_image_url = base_url <> "/images/og.svg"

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
      |> Map.put(:public_path_prefix, public_path_prefix)
      |> Map.put(:rtl_locales, rtl_locales)
      |> Map.put(:canonical_url, canonical_url)
      |> Map.put(:base_url, base_url)
      |> Map.put(:page_path, page_path)
      |> Map.put(:og_image_url, og_image_url)
      |> Map.put(:flash, Map.get(assigns, :flash, %{}))

    ~H"""
    <!DOCTYPE html>
    <html
      class="scroll-smooth motion-reduce:scroll-auto"
      lang={Locale.lang(@locale)}
      dir={Locale.dir(@locale)}
      data-theme={@theme}
      data-mode={@mode}
      data-locale={@locale}
      data-themes={Enum.join(SoonexI18n.Theme.themes(), ",")}
      data-locales={Enum.join(Locale.locales(), ",")}
      data-rtl-locales={@rtl_locales}
      data-default-theme={SoonexI18n.Theme.default_theme()}
      data-locale-selected-path={Locale.selected_path(@page, @locale)}
      data-public-path-prefix={@public_path_prefix}
      {SoonexI18n.Accessibility.data_attrs()}
    >
      <head>
        {SoonexI18n.Theme.head_script()}
        {SoonexI18n.Mode.head_script()}
        {SoonexI18n.Accessibility.head_script()}
        {SoonexI18n.CookieConsent.head_script()}
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="csrf-token" content={get_csrf_token()} />

        <link rel="icon" href={SoonexI18n.Public.path("/images/logo.svg")} type="image/svg+xml" />
        <link rel="icon" href={SoonexI18n.Public.path("/images/favicon.ico")} sizes="48x48" />
        <link
          rel="icon"
          type="image/png"
          sizes="32x32"
          href={SoonexI18n.Public.path("/images/favicon-32x32.png")}
        />
        <link
          rel="icon"
          type="image/png"
          sizes="16x16"
          href={SoonexI18n.Public.path("/images/favicon-16x16.png")}
        />
        <link
          rel="apple-touch-icon"
          sizes="180x180"
          href={SoonexI18n.Public.path("/images/apple-touch-icon.png")}
        />
        <link
          rel="icon"
          type="image/png"
          sizes="192x192"
          href={SoonexI18n.Public.path("/images/android-chrome-192x192.png")}
        />
        <link
          rel="icon"
          type="image/png"
          sizes="512x512"
          href={SoonexI18n.Public.path("/images/android-chrome-512x512.png")}
        />
        <link rel="manifest" href={SoonexI18n.Public.path("/site.webmanifest")} />

        <title>{@doc_title}</title>
        <meta name="description" content={@doc_description} />

        <link rel="canonical" href={@canonical_url} />
        <link
          :for={loc <- Locale.locales()}
          rel="alternate"
          hreflang={loc}
          href={@base_url <> Locale.swap_path(@page_path, loc)}
        />
        <link
          rel="alternate"
          hreflang="x-default"
          href={@base_url <> Locale.swap_path(@page_path, Locale.default_locale_string())}
        />

        <meta property="og:type" content="website" />
        <meta property="og:locale" content={Locale.lang(@locale)} />
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
          rel="preload"
          href={SoonexI18n.Public.path("/fonts/manrope-latin-wght-normal.woff2")}
          as="font"
          type="font/woff2"
          crossorigin
        />
        <link
          rel="preload"
          href={SoonexI18n.Public.path("/fonts/outfit-latin-wght-normal.woff2")}
          as="font"
          type="font/woff2"
          crossorigin
        />
        <link rel="stylesheet" href={SoonexI18n.Public.asset("/css/site.css")} />
        <script type="module" src={SoonexI18n.Public.asset("/js/site.js")} />
      </head>

      <body class="layout typo flex min-h-dvh min-w-0 flex-col overflow-x-clip bg-root text-ink antialiased">
        <.navigate to="#main-content" class="link link--skip">{~t"Skip to content"}</.navigate>

        <.demo_site_controls page={@page} locale={@locale} mode={@mode} />
        <.site_nav page_path={@page_path} locale={@locale} />

        <main id="main-content" class="layout__main flex-1">
          {render(@inner_content)}
        </main>

        <.site_footer copyright_holder={@copyright_holder} page_path={@page_path} />
        <.cookie_consent privacy_path={~p"/privacy"} />

        <.toast_group id="layout-toast" class="toast" phx-update="ignore" flash={@flash}>
          <:loading>
            <.heroicon name="hero-arrow-path" />
          </:loading>
        </.toast_group>
        <.toast_client_error
          toast_group_id="layout-toast"
          title={~t"We lost the connection"}
          description={~t"We're trying to reconnect you..."}
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
    if md_page?(page) and present_string?(page[:title]) do
      page[:title]
    else
      kind_title(page[:page_kind], site_name)
    end
  end

  defp kind_title(:home, site_name),
    do: ~t"#{name = site_name} · Launch #{date = SoonexI18n.Launch.year_label()}"

  defp kind_title(:blog_index, site_name), do: ~t"Journal · #{name = site_name}"
  defp kind_title(:not_found, site_name), do: ~t"Page not found · #{name = site_name}"
  defp kind_title(:privacy, site_name), do: ~t"Privacy · #{name = site_name}"
  defp kind_title(:tags_index, site_name), do: ~t"Tags · #{name = site_name}"
  defp kind_title(_kind, site_name), do: site_name

  defp meta_description(page, site_name) do
    kind_description(page[:page_kind], site_name) ||
      page_description(page) ||
      ~t"Soonex: the launch page kit for Phoenix teams, built with Tableau and Corex."
  end

  defp kind_description(:home, _site_name),
    do:
      ~t"Soonex is the launch page kit for Phoenix teams: static HTML, accessible Corex components, four themes, a waitlist, and a journal."

  defp kind_description(:blog_index, site_name), do: ~t"Shipping notes from #{name = site_name}."
  defp kind_description(:not_found, site_name), do: ~t"That page is not on #{name = site_name}."

  defp kind_description(:privacy, _site_name),
    do:
      ~t"Necessary preferences stay on this device. Analytics and marketing stay off unless you allow them."

  defp kind_description(:tags_index, site_name),
    do: ~t"Browse journal tags on #{name = site_name}."

  defp kind_description(_kind, _site_name), do: nil

  defp page_description(page) do
    if present_string?(page[:description]), do: page[:description]
  end

  defp md_page?(page), do: page[:__tableau_page_extension__] == true

  defp present_string?(v) when is_binary(v), do: String.trim(v) != ""
  defp present_string?(_), do: false
end
