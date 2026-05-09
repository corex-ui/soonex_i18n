# Soonex — Tableau + Corex coming soon

Single-page static site with Corex components, themes, and the same contrast-driven color pipeline as the SaaS template.

## Prerequisites

- Elixir ~> 1.15
- Node.js (for `npm install` under `assets/`)

## Site identity and tuning

Edit strings and lists directly in the source instead of `Application` config:

- **Brand** — `site_name` and `copyright_holder` literals in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex); page titles for generated home modules in [`lib/pages/home_page.ex`](lib/pages/home_page.ex).
- **Themes** — allowed theme ids and default in [`lib/soonex/theme.ex`](lib/soonex/theme.ex) (`data-theme` on `<html>` must match CSS imports in `assets/css/site.css`).
- **Locales** — from Gettext and [`config :localize`](config/config.exs); [`lib/soonex/gettext.ex`](lib/soonex/gettext.ex) (`allowed_locales`) and [`lib/soonex/locale.ex`](lib/soonex/locale.ex) drive URLs and the language switcher.

## Rename after clone

From the repo root run **`mix project.rename your_otp_app`** (snake_case only). The task is [`lib/mix/tasks/project.rename.ex`](lib/mix/tasks/project.rename.ex): it rewrites modules and `:soonex` keys, renames `lib/soonex/` and `lib/soonex_web/` (and matching `test/` trees when present), Mix aliases, and selected npm metadata. **Commit or branch first**—there is no undo—then **`mix format`** and **`mix compile`**. **`_posts/*.md`:** only the YAML `layout:` line is rewritten so the module prefix matches the new app (e.g. `SoonexI18n.PostLayout` → `Acme.PostLayout`); post body and this **README** are otherwise left alone so org URLs and prose stay intact. See [`_posts/2026-05-08-docs.md`](_posts/2026-05-08-docs.md) for the full narrative.

## Document title and meta description

`<title>` and `<meta name="description">` are computed in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex) with Gettext (after the active locale is applied). The home pages use `page_kind: :home` for dedicated strings; other Elixir pages fall back to site-default SEO copy. Markdown pages under `_pages/` can set `title` and `description` in YAML front matter (`title` overrides the document title, `description` overrides the meta description when non-empty).

## Pages and URLs

Section templates live under [`lib/pages/home/`](lib/pages/home/). `Soonex.HomePage` composes them. At compile time, one `Tableau.Page` module is generated per Gettext locale, each with permalink **`/<locale>/`** (for example `/en/`, `/ar/`).

The bare site root **`/`** is the same default-locale home as **`/<default_locale>/`**: [`lib/pages/root_index_page.ex`](lib/pages/root_index_page.ex) uses [`Soonex.RootLayout`](lib/layouts/root_layout.ex) and delegates its body to `Soonex.HomePage.template/1`. The prefixed English home at **`/en/`** (when `en` is default) is still built for bookmarks and parity; its canonical URL points at **`/`** so search engines consolidate on the root.

Verified paths follow the same pattern as Corex e2e: [`use Soonex.Routes`](lib/soonex/routes.ex) wires [`Phoenix.VerifiedRoutes`](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) with **`path_prefixes: [{Soonex.Locale, :current, []}]`** so `Gettext.get_locale(Soonex.Gettext)` (set from the page before render in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex)) is prepended to every `~p` path. Write **`~p"/"`** and **`~p"/docs"`** in HEEx; at build time they become `/en/…` or `/ar/…` as appropriate. See Phoenix’s [Localized routes and path_prefixes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes). Paths listed under **`statics`** (images, css, js, `feed.xml`, `site.webmanifest`) are not prefixed. The stub [`SoonexWeb.Router`](lib/soonex_web/router.ex) declares **`/`** and **`/docs`** without a locale segment plus the same paths under **`/:locale`** so `~p` compiles; Tableau does not use the router at runtime.

**LocalizeWeb** plugs apply to live Phoenix requests. This template is static-first: locale comes from each page’s **`permalink`** and Gettext in the layout, not from `conn`. When you lift the same HEEx into a full Phoenix app, you can add `Localize.Plug.PutLocale` like e2e.

The language switcher uses [`Soonex.Locale.swap_path/2`](lib/soonex/locale.ex). [`SoonexWeb.Endpoint`](lib/soonex_web/endpoint.ex) is headless for VerifiedRoutes only.

## Setup

```shell
cd templates/soonex
mix deps.get
mix designex corex
cd assets && npm install && cd ..
```

Development server (defaults to `http://localhost:4999`; default-language home is at **`/`**, with localized copies at **`/en/`** and **`/ar/`** when those locales exist):

```shell
mix tableau.server
```

When compiled with `MIX_ENV=dev`, the Soonex OTP app starts a small Bandit server so Corex MCP is available at `http://localhost:4004/corex/mcp`, plus a headless Phoenix endpoint for VerifiedRoutes (`server: false`, no extra port). The Tableau dev server stays on port 4999. Production builds (`MIX_ENV=prod`) do not start the MCP listener.

Point your MCP client at that URL (see [`.cursor/mcp.json`](.cursor/mcp.json) for Cursor).

Asset rebuild during development:

```shell
mix assets.build
```

## Corex JavaScript paths

`assets/js/site.js` imports Corex with the **`corex`** package specifiers (`corex/hooks`, `corex/select`, …). Esbuild resolves them because **`NODE_PATH`** in [`config/config.exs`](config/config.exs) includes **`deps`**, where Mix puts the **`corex`** dependency from **`mix.exs`**.

Run **`mix designex corex`** so design tokens and component CSS match the same Corex version.

To hack on a local Corex checkout instead, use **`{:corex, path: "../../corex"}`** (adjust the path) in **`mix.exs`**; the same **`corex/…`** imports keep working as long as **`deps/corex`** points at that checkout after **`mix deps.get`**.

Client preferences use [`assets/js/theme.js`](assets/js/theme.js), [`assets/js/mode.js`](assets/js/mode.js), and [`assets/js/locale.js`](assets/js/locale.js). Landing motion uses [`assets/js/landing.js`](assets/js/landing.js) plus [`landing-scroll-chrome.js`](assets/js/landing-scroll-chrome.js), [`landing-hero.js`](assets/js/landing-hero.js), [`landing-reveal.js`](assets/js/landing-reveal.js), and [`landing-parallax.js`](assets/js/landing-parallax.js). The document uses `data-theme`, `data-mode`, and `data-locale` on `<html>` with `localStorage` keys `data-theme`, `data-mode`, and `data-locale`.

## Production build

```shell
MIX_ENV=prod mix build
```

Outputs to `_site/`. Set your canonical URL in `config/prod.exs` (`config :tableau, :config, url: "https://your.domain"`).

After permalink or routing changes, remove stale directories under `_site/` (for example `rm -rf _site`) before rebuilding so old paths do not linger on disk.

## Custom 404 (static hosts)

[`lib/pages/not_found_page.ex`](lib/pages/not_found_page.ex) builds **`_site/404.html`** (`permalink: "/404.html"`). Netlify, GitHub Pages, and Cloudflare Pages serve that file for unknown paths when it sits at the site root of the deploy.

`mix tableau.server` still returns Tableau’s tiny built-in HTML for missing files (from the `tableau` dependency); swapping that would require an upstream Tableau change or a local fork.


Tableau writes **one output tree per `permalink`**. Example: [`_posts/2026-05-08-docs.md`](_posts/2026-05-08-docs.md) uses `permalink: /en/docs/`; [`_posts/2026-05-08-docs-ar.md`](_posts/2026-05-08-docs-ar.md) uses `permalink: /ar/docs/`. In-page links use **`~p"/docs"`** via `Soonex.Routes`, which resolves to the correct prefixed URL for the page being rendered. Published copies of this template live under **`github.com/corex-ui/soonex_i18n`** (localized) and **`github.com/corex-ui/soonex`** (single-locale sibling).

## Draft posts and WIP pages

Draft posts and work-in-progress pages can live in `_drafts` and `_wip`. Directories are configured in `config/dev.exs` and `config/prod.exs`.
