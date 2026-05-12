# Soonex i18n

**Tableau** static site with Corex, Gettext locales, Localize metadata, and verified-route-friendly `~p` paths. Single-locale sibling: [github.com/corex-ui/soonex](https://github.com/corex-ui/soonex).

**Corex docs:** [installation](https://hexdocs.pm/corex/installation.html), [API](https://hexdocs.pm/corex/api.html), [Events](https://hexdocs.pm/corex/events.html), [Tableau + Corex](https://hexdocs.pm/corex/tableau.html), [localize](https://hexdocs.pm/corex/localize.html).

## Prerequisites

- Elixir ~> 1.15
- Node.js (for `npm install` in `assets/`)

## Quick start

```shell
cd templates/soonex_i18n
mix deps.get
mix setup
mix designex corex
cd assets && npm install && cd ..
mix tableau.server
```

- `mix setup` runs `deps.get` and `mix localize.download_locales` so locale data is present before the first build.
- Dev: `http://localhost:4999`. Default locale is also served at `/`; locale-prefixed URLs (e.g. `/en/`, `/ar/`) are built per Gettext.
- Prod: `MIX_ENV=prod mix build` → `_site/`. Set **`SOONEX_PUBLIC_URL`** for your deploy origin; default demo is `https://corex-ui.github.io/soonex_i18n`.

`MIX_ENV=dev` starts Corex MCP at `http://localhost:4004/corex/mcp` and a headless Phoenix endpoint for VerifiedRoutes only. See [`.cursor/mcp.json`](.cursor/mcp.json).

Rebuild assets: `mix assets.build`.

## Customize (where to edit)

- **Brand / SEO (Gettext):** [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex), [`lib/pages/home_page.ex`](lib/pages/home_page.ex).
- **Themes:** [`lib/soonex_i18n/theme.ex`](lib/soonex_i18n/theme.ex) + [`assets/css/site.css`](assets/css/site.css) imports.
- **Locales:** [`config/config.exs`](config/config.exs) `config :localize`, [`lib/soonex_i18n/gettext.ex`](lib/soonex_i18n/gettext.ex), [`lib/soonex_i18n/locale.ex`](lib/soonex_i18n/locale.ex). Keep **`default_locale`** a valid BCP 47 tag (template uses `"en"`) so CI and `mix tableau.build` do not depend on `LANG`.
- **Routes in HEEx:** [`use SoonexI18n.Routes`](lib/soonex_i18n/routes.ex) — write `~p"/docs"` and let the locale (and prod path prefix) apply. Details: [Phoenix VerifiedRoutes — localized routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes).
- **Language switcher:** [`SoonexI18n.Locale.swap_path/2`](lib/soonex_i18n/locale.ex).

Static rendering uses each page’s **permalink** and layout Gettext; there is no Phoenix `conn`. For a full Phoenix app, add something like `Localize.Plug.PutLocale` as in Corex e2e.

## Rename this template

1. Commit or branch (no undo).
2. `mix project.rename your_otp_app` from the repo root (snake_case).
3. `mix format` and `mix compile`.
4. **`_posts/*.md`:** YAML `layout:` lines update to the new module prefix; bodies are untouched.

## Tests and CI

[`mix test`](mix.exs) runs palette, designex, esbuild, tailwind, and `mix tableau.build` before Wallaby tests via the **`pre.test`** alias. [`.github/workflows/ci.yml`](.github/workflows/ci.yml) installs Chrome/Chromedriver and runs `mix test --timeout 600000`. [`.github/workflows/pages.yml`](.github/workflows/pages.yml) downloads locales, runs `npm ci` in `assets/`, then prod build.

## Corex assets and JS

Same as Soonex: `corex/*` imports in [`assets/js/site.js`](assets/js/site.js), **`NODE_PATH`** includes `deps`, **`mix designex corex`** after Corex upgrades. Optional path dep: `{:corex, path: "../../corex"}`.

Client scripts: [`assets/js/theme.js`](assets/js/theme.js), [`assets/js/mode.js`](assets/js/mode.js), [`assets/js/locale.js`](assets/js/locale.js), plus landing scripts in [`assets/js/landing*.js`](assets/js).

## Production and hosting

- **`SOONEX_PUBLIC_URL`:** drives Tableau `url` and [`SoonexI18nWeb.Endpoint`](lib/soonex_i18n_web/endpoint.ex) `path` so GitHub Pages project sites get `/repo/...` prefixes; layout emits `<base href="…">` for relative URLs.
- Clear `_site/` when routes or permalinks change.
- **404:** [`lib/pages/not_found_page.ex`](lib/pages/not_found_page.ex) → `_site/404.html`.

Example permalinks: [`_posts/2026-05-08-docs.md`](_posts/2026-05-08-docs.md) (`/en/docs/`), [`_posts/2026-05-08-docs-ar.md`](_posts/2026-05-08-docs-ar.md) (`/ar/docs/`). Use `~p"/docs"` in HEEx so links follow the active locale.

## Drafts

Drafts and WIP: `_drafts` and `_wip` (`config/dev.exs`, `config/prod.exs`).
