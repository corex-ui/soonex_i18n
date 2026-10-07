# AGENTS.md

## Cursor Cloud specific instructions

Soonex i18n is an Elixir **Tableau** static-site generator (Corex UI components, Tailwind v4, esbuild)
that builds every page in English, French, and Arabic. Standard commands live in `README.md` and
`mix.exs` aliases — prefer those; the notes below only cover non-obvious cloud gotchas.

### Toolchain activation
- Elixir/OTP versions are pinned in `.tool-versions` (Erlang 28.3.1, Elixir 1.19.5-otp-28). Use
 **mise** (`mise install`) or **asdf** if present. There is no `assets/package.json`; Node is not
 required for builds.
- If a command reports `mix: command not found` (e.g. in a bare non-login shell), activate the
 toolchain first: `eval "$(mise activate bash)"` or `. "$HOME/.asdf/asdf.sh"`.
- `mix setup` also runs `mix localize.download_locales`. Without that data, date formatting and
 text direction fall back to ISO dates and `ltr`.

### Running / building
- Dev server: `mix server` (alias: port check, then `tableau.server`) → site at
 `http://localhost:4999` (`/`, `/en/`, `/fr/`, `/ar/`, plus `/<locale>/blog`, `/<locale>/tags`).
 In dev it also starts Corex MCP at `http://localhost:4004/corex/mcp`.
- Adding a blog post: `mix soonex_i18n.gen.post "Title"` writes one Markdown file per locale under
 `_posts/` with `/<locale>/blog/<slug>/` permalinks and `layout: SoonexI18n.PostLayout`.
- Rebuild only assets: `mix assets.build`. Production build: `MIX_ENV=prod mix build` → `_site/`.
- After changing Corex config (`config :corex_design` in `config/config.exs`) run
 `mix corex.design.build`.

### Translations
- UI strings use the `~t` sigil (`use SoonexI18n.GettextSigil`); links use the locale-aware `~p`
 sigil (`use SoonexI18n.Routes`). Every `~p` path needs a route in `SoonexI18nWeb.Router`.
- After adding strings run `mix gettext.extract --merge`, then fill `msgstr` in
 `priv/gettext/{fr,ar}/LC_MESSAGES/default.po`. Remove `#, fuzzy` flags after review or the
 entries are ignored.
- `~t` cannot be used in compile-time `use Tableau.Page` options (e.g. `title:`).

### Lint / test
- Lint: `mix credo`.
- Tests: `mix test` (the `test` alias first runs `pre.test`, which builds the static site into
 `_site/`, then runs ExUnit). The suite is a **Wallaby** browser accessibility check
 (`test/soonex_i18n/home_a11y_test.exs`) on `/`, `/en/`, `/fr/`, and `/ar/`, driving headless
 Chrome via chromedriver against a Bandit server on port 4999.
- Set `SOONEX_TEST_PORT` to run the tests on another port when 4999 is taken.
- If you upgrade Chrome, replace `/usr/local/bin/chromedriver` with the matching version from
 Chrome for Testing, or Wallaby tests will fail to start a session.

### Gotchas
- Live reload needs `inotify-tools`. `mix server` fails fast on Linux when `inotifywait` is missing.
- Port 4999 is shared by the dev server and the test harness. Stop `mix server` before running
 `mix test`, or use `SOONEX_TEST_PORT`.
- Corex Design already mirrors `hero-*` icons inside its recipes in RTL. Adding
 `rtl:-scale-x-100` to those icons flips them back; only use it outside Corex recipes.
