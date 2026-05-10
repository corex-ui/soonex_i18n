# Soonex i18n, Tableau + Corex coming soon

Single-page static site with Corex components, themes, Gettext locales, Localize-backed layout metadata, and the same contrast-driven color pipeline as the SaaS template. For a single-locale sibling without path prefixes, see **`github.com/corex-ui/soonex`**.

## Prerequisites

- Elixir ~> 1.15
- Node.js (for `npm install` under `assets/`)

## Site identity and tuning

Edit strings and lists directly in the source instead of `Application` config:

- **Brand**, `site_name` and `copyright_holder` literals in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex); page titles for generated home modules in [`lib/pages/home_page.ex`](lib/pages/home_page.ex).
- **Themes**, allowed theme ids and default in [`lib/soonex_i18n/theme.ex`](lib/soonex_i18n/theme.ex) (`data-theme` on `<html>` must match CSS imports in `assets/css/site.css`).
- **Locales**, from Gettext and [`config :localize`](config/config.exs): keep `supported_locales` aligned with Gettext, and set **`default_locale`** to a valid BCP 47 id (the template uses `"en"`). That explicit default avoids relying on POSIX `LANG` during `mix tableau.build` or CI, where values like `C.UTF-8` are not valid language tags for Localize’s resolver. [`lib/soonex_i18n/gettext.ex`](lib/soonex_i18n/gettext.ex) (`allowed_locales`) and [`lib/soonex_i18n/locale.ex`](lib/soonex_i18n/locale.ex) drive URLs and the language switcher.

## Rename after clone

From the repo root run **`mix project.rename your_otp_app`** (snake_case only). The task is [`lib/mix/tasks/project.rename.ex`](lib/mix/tasks/project.rename.ex): it rewrites modules and `:soonex_i18n` keys, renames `lib/soonex_i18n/` and `lib/soonex_i18n_web/` (and matching `test/` trees when present), Mix aliases, and selected npm metadata. **Commit or branch first**, there is no undo, then **`mix format`** and **`mix compile`**. **`_posts/*.md`:** only the YAML `layout:` line is rewritten so the module prefix matches the new app (e.g. `SoonexI18n.PostLayout` → `Acme.PostLayout`); post body and this **README** are otherwise left alone so org URLs and prose stay intact. See [`_posts/2026-05-08-docs.md`](_posts/2026-05-08-docs.md) for the full narrative.

## Document title and meta description

`<title>` and `<meta name="description">` are computed in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex) with Gettext (after the active locale is applied). The home pages use `page_kind: :home` for dedicated strings; other Elixir pages fall back to site-default SEO copy. Markdown pages under `_pages/` can set `title` and `description` in YAML front matter (`title` overrides the document title, `description` overrides the meta description when non-empty).

## Pages and URLs

Section templates live under [`lib/pages/home/`](lib/pages/home/). `SoonexI18n.HomePage` composes them. At compile time, one `Tableau.Page` module is generated per Gettext locale, each with permalink **`/<locale>/`** (for example `/en/`, `/ar/`).

The bare site root **`/`** is the same default-locale home as **`/<default_locale>/`**: [`lib/pages/root_index_page.ex`](lib/pages/root_index_page.ex) uses [`SoonexI18n.RootLayout`](lib/layouts/root_layout.ex) and delegates its body to `SoonexI18n.HomePage.template/1`. The prefixed English home at **`/en/`** (when `en` is default) is still built for bookmarks and parity; its canonical URL points at **`/`** so search engines consolidate on the root.

Verified paths follow the same pattern as Corex e2e: [`use SoonexI18n.Routes`](lib/soonex_i18n/routes.ex) wires [`Phoenix.VerifiedRoutes`](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) with **`path_prefixes: [{SoonexI18n.Locale, :current, []}]`** so `Gettext.get_locale(SoonexI18n.Gettext)` (set from the page before render in [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex)) is prepended to every `~p` path. Write **`~p"/"`** and **`~p"/docs"`** in HEEx; at build time they become `/en/…` or `/ar/…` as appropriate (and, in production, the host path prefix from **`SoonexI18nWeb.Endpoint`** `url` before the locale segment). See Phoenix’s [Localized routes and path_prefixes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes). Paths listed under **`statics`** (`images`, `css`, `js`, `feed.xml`, `site.webmanifest`, `404.html`) use the same **`~p`** helpers in the root layout so they pick up that prefix. The stub [`SoonexI18nWeb.Router`](lib/soonex_i18n_web/router.ex) declares **`/`** and **`/docs`** without a locale segment plus the same paths under **`/:locale`** so `~p` compiles; Tableau does not use the router at runtime.

**LocalizeWeb** plugs apply to live Phoenix requests. This template is static-first: locale comes from each page’s **`permalink`** and Gettext in the layout, not from `conn`. When you lift the same HEEx into a full Phoenix app, you can add `Localize.Plug.PutLocale` like e2e.

The language switcher uses [`SoonexI18n.Locale.swap_path/2`](lib/soonex_i18n/locale.ex). [`SoonexI18nWeb.Endpoint`](lib/soonex_i18n_web/endpoint.ex) is headless for VerifiedRoutes only.

## Setup

```shell
cd templates/soonex_i18n
mix deps.get
mix setup
mix designex corex
cd assets && npm install && cd ..
```

`mix setup` runs `deps.get` plus `mix localize.download_locales` (which downloads `config :localize` `:supported_locales`) so the locale ETF cache is populated before the first build.

Development server (defaults to `http://localhost:4999`; default-language home is at **`/`**, with localized copies at **`/en/`** and **`/ar/`** when those locales exist):

```shell
mix tableau.server
```

When compiled with `MIX_ENV=dev`, the SoonexI18n OTP app starts a small Bandit server so Corex MCP is available at `http://localhost:4004/corex/mcp`, plus a headless Phoenix endpoint for VerifiedRoutes (`server: false`, no extra port). The Tableau dev server stays on port 4999. Production builds (`MIX_ENV=prod`) do not start the MCP listener.

Point your MCP client at that URL (see [`.cursor/mcp.json`](.cursor/mcp.json) for Cursor).

Asset rebuild during development:

```shell
mix assets.build
```

## Tests and CI

[`mix test`](mix.exs) runs a **`pre.test`** alias (palette, designex, esbuild, tailwind, then **`mix tableau.build`**) before Wallaby feature tests. [`.github/workflows/ci.yml`](.github/workflows/ci.yml) mirrors that: it installs Chrome and Chromedriver via `browser-actions/setup-chrome`, exports **`WALLABY_CHROME_BINARY`** and **`WALLABY_CHROMEDRIVER_PATH`** from the action outputs, then runs **`mix test --timeout 600000`**. [`.github/workflows/pages.yml`](.github/workflows/pages.yml) runs **`mix localize.download_locales`**, **`npm ci`** in **`assets/`** (so Tailwind can resolve **`lenis`** and other CSS imports from **`node_modules`**), then **`MIX_ENV=prod mix build`** for the published tree (Tableau HTML plus minified CSS and JS).

## Corex JavaScript paths

`assets/js/site.js` imports Corex with the **`corex`** package specifiers (`corex/hooks`, `corex/select`, …). Esbuild resolves them because **`NODE_PATH`** in [`config/config.exs`](config/config.exs) includes **`deps`**, where Mix puts the **`corex`** dependency from **`mix.exs`**.

Run **`mix designex corex`** so design tokens and component CSS match the same Corex version.

To hack on a local Corex checkout instead, use **`{:corex, path: "../../corex"}`** (adjust the path) in **`mix.exs`**; the same **`corex/…`** imports keep working as long as **`deps/corex`** points at that checkout after **`mix deps.get`**.

Client preferences use [`assets/js/theme.js`](assets/js/theme.js), [`assets/js/mode.js`](assets/js/mode.js), and [`assets/js/locale.js`](assets/js/locale.js). Landing motion uses [`assets/js/landing.js`](assets/js/landing.js) plus [`landing-scroll-chrome.js`](assets/js/landing-scroll-chrome.js), [`landing-hero.js`](assets/js/landing-hero.js), [`landing-reveal.js`](assets/js/landing-reveal.js), and [`landing-parallax.js`](assets/js/landing-parallax.js). The document uses `data-theme`, `data-mode`, and `data-locale` on `<html>` with `localStorage` keys `data-theme`, `data-mode`, and `data-locale`.

## Production build

```shell
MIX_ENV=prod mix build
```

Outputs to `_site/`. In production, Tableau’s site URL comes from **`SOONEX_PUBLIC_URL`** when set (for example in GitHub Actions or GitHub **repository variables**); otherwise it defaults to the published demo at **`https://corex-ui.github.io/soonex_i18n`**. **`config/prod.exs`** parses that URL and sets **`SoonexI18nWeb.Endpoint`** `url: [path: …]` so **`~p`** static paths (CSS, JS, icons, manifest, RSS) include the repository prefix on **GitHub Pages project sites** (`/repo-name/…`). The layout also emits **`<base href="…/">`** so Markdown images and other relative URLs resolve under the same public root. Override the URL in the environment when you deploy your own domain.

After permalink or routing changes, remove stale directories under `_site/` (for example `rm -rf _site`) before rebuilding so old paths do not linger on disk.

## Custom 404 (static hosts)

[`lib/pages/not_found_page.ex`](lib/pages/not_found_page.ex) builds **`_site/404.html`** (`permalink: "/404.html"`). Netlify, GitHub Pages, and Cloudflare Pages serve that file for unknown paths when it sits at the site root of the deploy.

`mix tableau.server` still returns Tableau’s tiny built-in HTML for missing files (from the `tableau` dependency); swapping that would require an upstream Tableau change or a local fork.


Tableau writes **one output tree per `permalink`**. Example: [`_posts/2026-05-08-docs.md`](_posts/2026-05-08-docs.md) uses `permalink: /en/docs/`; [`_posts/2026-05-08-docs-ar.md`](_posts/2026-05-08-docs-ar.md) uses `permalink: /ar/docs/`. In-page links use **`~p"/docs"`** via `SoonexI18n.Routes`, which resolves to the correct prefixed URL for the page being rendered. Published copies of this template live under **`github.com/corex-ui/soonex_i18n`** (localized) and **`github.com/corex-ui/soonex`** (single-locale sibling).

## Draft posts and WIP pages

Draft posts and work-in-progress pages can live in `_drafts` and `_wip`. Directories are configured in `config/dev.exs` and `config/prod.exs`.
