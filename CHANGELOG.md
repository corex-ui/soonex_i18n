# Changelog

## 0.2.0

- Upgrade to Corex 0.2 (`corex`, `corex_design`, `corex_mcp`); replace Designex with `mix corex.design.build`.
- Bump Tableau to `~> 0.30`.
- Align homepage/chrome/blog UI with Soonex (no Pricing; no TagExtension); locale blog indexes and Gettext UI chrome.
- Migrate component modifiers to shared `ui-*` classes and token renames (`bg-surface`, `text-brand-text`).
- Require Elixir `~> 1.17`.
- Publish GitHub Pages only via `deploy.yml` after CI succeeds on `main` (remove ungated `pages.yml`).

## 0.1.0

Initial Soonex i18n template release.
