# Changelog

## 0.3.0

- Port the Soonex 0.3.0 redesign: editorial home page (photo hero with countdown, live preview, capabilities grid, workflow tabs, proof section, journal cards, FAQ, closing waitlist band), Unsplash photography, official JavaScript and Tableau logos, and Corex Design as the only styling layer (four themes with light and dark modes).
- Translate all new UI copy into French and Arabic with `~t`; translate Corex default component labels through the project Gettext backend (`SoonexI18n.CorexStrings`).
- Replace the journal with six posts, each available in English, French, and Arabic, using locale-prefixed permalinks and relative internal links.
- Add per-locale tags index (`/:locale/tags`) and privacy page (`/:locale/privacy`); drop the `/docs` example pages.
- Add `hreflang` alternates with `x-default`, `og:locale`, and locale-aware date formatting (`SoonexI18n.Locale.format_date/2`).
- Improve right-to-left support: logical spacing utilities, `dir` on Corex components, left-to-right code blocks, and a self-hosted Noto Sans Arabic font.
- Add the accessibility panel and cookie consent from Soonex, with a language switcher in Template Options.
- Drop `assets/package.json`, Lenis, and the landing scripts; CI and deploy no longer run `npm ci`.
- Drop `:corex_design` from Mix `compilers`; pin `corex`, `corex_design`, and `corex_mcp` to `~> 0.2` (0.2.2); upgrade `a11y_audit` to 0.5.0, `phoenix_live_view` to 1.2.12, and `usage_rules` to 1.2.8.
- Add `mix server` (port check, then `tableau.server`) and `mix soonex_i18n.gen.post`, which creates a post in every locale.
- Run the Wallaby axe check on `/`, `/en/`, `/fr/`, and `/ar/`, and assert the Arabic page is right-to-left; `SOONEX_TEST_PORT` overrides the test port.
- Version `site.css` and `site.js` URLs in production builds (`?v=` plus the commit SHA, or the build time outside GitHub Actions) so visitors get new styles after a deploy without a hard refresh.
- Rewrite the README and add AGENTS.md.

## 0.2.0

- Upgrade to Corex 0.2 (`corex`, `corex_design`, `corex_mcp`); replace Designex with `mix corex.design.build`.
- Bump Tableau to `~> 0.30`.
- Align homepage/chrome/blog UI with Soonex (no Pricing; no TagExtension); locale blog indexes and Gettext UI chrome.
- Migrate component modifiers to shared `ui-*` classes and token renames (`bg-surface`, `text-brand-text`).
- Require Elixir `~> 1.17`.
- Publish GitHub Pages only via `deploy.yml` after CI succeeds on `main` (remove ungated `pages.yml`).

## 0.1.0

Initial Soonex i18n template release.
