# Soonex i18n

Soonex i18n is the multi-locale edition of [Soonex](https://github.com/corex-ui/soonex), a launch page kit for Phoenix teams. It builds a coming-soon site as static HTML with [Tableau](https://github.com/elixir-tools/tableau), styles it with [Corex](https://hexdocs.pm/corex) design tokens, hydrates accessible Corex components in the browser, and ships every page in English, French, and Arabic (right-to-left).

**Live demo:** [corex-ui.github.io/soonex_i18n](https://corex-ui.github.io/soonex_i18n)

## Features

- **Three locales:** every page is built under `/en/`, `/fr/`, and `/ar/`. The default locale is also served at `/`. Arabic renders right-to-left with a self-hosted Noto Sans Arabic font.
- **Gettext everywhere:** UI strings use the `~t` sigil and live in `priv/gettext/`. Corex component labels (pagination, timer, clipboard) are translated through the same files.
- **Localized metadata:** `<html lang dir>`, `hreflang` alternates with `x-default`, `og:locale`, and dates formatted per locale with [Localize](https://hexdocs.pm/localize).
- **Language switcher:** in **Template Options**, next to the theme and mode controls. It keeps the visitor on the same page in the new language.
- **Landing page:** hero with launch countdown, tech marquee, live component preview, capabilities grid, workflow tabs, proof section, journal highlights, FAQ, and a closing waitlist band.
- **Four themes:** `neo`, `uno`, `duo`, and `leo`, each with light and dark modes generated from color seeds in `config :corex_design`.
- **Waitlist form:** email, role select, and opt-in switch with toast feedback. It stores nothing until you connect a provider.
- **Journal:** translated Markdown posts per locale, with cover images, tags, RSS (`/feed.xml`), sitemap, and pagination.
- **Accessibility panel:** text size, contrast, motion, focus ring, and link underline, saved in the visitor's browser.
- **Cookie consent and privacy page:** optional categories stay off unless the visitor allows them.
- **No Node toolchain:** Tailwind v4 and esbuild run as Mix tasks. There is no `package.json`.

## Requirements

- Erlang/OTP 28 and Elixir 1.19 (pinned in [`.tool-versions`](.tool-versions); the project supports Elixir `~> 1.17` and CI also runs 1.17 and 1.18)
- Hex packages `corex`, `corex_design`, and `corex_mcp` at `~> 0.2`
- Linux only: `inotify-tools` for live reload in the dev server
- For `mix test`: Google Chrome and a matching `chromedriver`

## Quick start

```shell
git clone https://github.com/corex-ui/soonex_i18n.git
cd soonex_i18n
mix setup
mix server
```

`mix setup` fetches dependencies, downloads Localize locale data, and builds the Corex design CSS.

Open [http://localhost:4999](http://localhost:4999), or go straight to [`/fr/`](http://localhost:4999/fr/) or [`/ar/`](http://localhost:4999/ar/). The dev server watches `lib/`, `_posts/`, `_data/`, and `assets/` and reloads on change.

In development, Corex MCP also runs at `http://localhost:4004/corex/mcp`. See [`.cursor/mcp.json`](.cursor/mcp.json) for an editor configuration example.

## Commands

| Command | What it does |
| --- | --- |
| `mix setup` | Fetch dependencies, download locale data, and build Corex design CSS |
| `mix server` | Check that ports 4999 and 4004 are free, then start the Tableau dev server |
| `mix assets.build` | Rebuild Corex design CSS, Tailwind, and esbuild output |
| `mix corex.design.build` | Regenerate design tokens and component CSS after changing `config :corex_design` |
| `mix gettext.extract --merge` | Extract new `~t` strings and merge them into every locale's `.po` file |
| `MIX_ENV=prod mix build` | Production build into `_site/` with minified CSS and JavaScript |
| `mix test` | Build the site, then run the Wallaby axe accessibility check on `/`, `/en/`, `/fr/`, and `/ar/` |
| `mix credo` | Lint |
| `mix soonex_i18n.gen.post My title` | Create a new post in `_posts/` in all three locales |

## Project structure

```text
config/config.exs          Tableau, Tailwind, esbuild, Localize locales, and config :corex_design (themes)
lib/pages/home_page.ex     Home page section order; one page module per locale
lib/pages/home/            One module per home section (hero, logos, showcase, features, ...)
lib/layouts/               Root layout, nav, footer, post layout, Shell and Section helpers
lib/soonex_i18n/locale.ex  Current locale, text direction, path swapping, date formatting
lib/soonex_i18n/routes.ex  Locale-aware ~p sigil
lib/soonex_i18n/launch.ex  Launch date used by the hero badge and countdown
priv/gettext/              default.pot plus en, fr, and ar translations
assets/css/                Tailwind entry, fonts, and small host helpers
assets/js/site.js          Corex hooks, theme, mode, and locale persistence, waitlist toast
extra/                     Static files copied to the site root (images, fonts, favicons)
_posts/                    Journal posts (Markdown), one file per locale
test/                      Wallaby accessibility tests
```

## Internationalization

### How locales work

Tableau renders static files, so there is no request or `conn`. Each page is generated once per locale with its own permalink (`/en/blog`, `/fr/blog`, `/ar/blog`). [`SoonexI18n.Locale`](lib/soonex_i18n/locale.ex) reads the locale from the page permalink, and [`RootLayout`](lib/layouts/root_layout.ex) sets the Gettext locale before rendering.

The locales built are the ones with a directory in `priv/gettext/`. Localize data for them is listed in `config :localize` in [`config/config.exs`](config/config.exs). Keep `default_locale` a valid BCP 47 tag (the template uses `"en"`) so builds do not depend on `LANG`.

### Writing translatable HEEx

- **Strings:** add `use SoonexI18n.GettextSigil` and write `~t"Join the waitlist"`. Interpolations need a binding name: `~t"Doors open #{date = Launch.label()}"`. Use `ngettext/3` for plurals.
- **Links:** add `use SoonexI18n.Routes` and write `~p"/blog"`. The current locale and the production path prefix are applied automatically. Every `~p` path needs a matching route in [`SoonexI18nWeb.Router`](lib/soonex_i18n_web/router.ex). See [Phoenix VerifiedRoutes: localized routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes).
- **Dates:** `SoonexI18n.Locale.format_date(date)` or `format_date(date, :MMMMd)`.

After adding or changing strings, run `mix gettext.extract --merge` and fill in the new `msgstr` entries in `priv/gettext/fr/` and `priv/gettext/ar/`. English entries can stay empty; Gettext falls back to the `msgid`.

### Right-to-left layout

The root layout sets `dir="rtl"` for Arabic. To keep layouts mirroring correctly:

- Use logical Tailwind utilities (`ms-*`, `pe-*`, `start-*`, `border-e`) rather than `left` and `right` variants.
- Pass `dir={SoonexI18n.Locale.dir(SoonexI18n.Locale.current())}` to Corex components that position content (select, tabs, pagination, accordion, marquee).
- Corex Design already mirrors `hero-*` icons inside its `button`, `link`, and component recipes. Only add `rtl:-scale-x-100` to directional icons outside those recipes.
- Code blocks stay left-to-right (`.markdown pre` in [`assets/css/prose.css`](assets/css/prose.css)).

### Adding a language

1. Add the code to `supported_locales` in `config :localize` and run `mix localize.download_locales`.
2. Run `mix gettext.merge priv/gettext --locale <code>` and translate the new `priv/gettext/<code>/LC_MESSAGES/default.po`.
3. Add translated posts with `/<code>/blog/<slug>/` permalinks.
4. Text direction is read from CLDR data, so right-to-left languages such as Hebrew or Persian need no extra configuration. If the theme fonts don't cover the script, add a font in [`assets/css/fonts.css`](assets/css/fonts.css) the way Noto Sans Arabic is added.
5. Add the locale's home page to [`test/soonex_i18n/home_a11y_test.exs`](test/soonex_i18n/home_a11y_test.exs).

## Customizing

### Brand and SEO

- Logo lockup: [`lib/layouts/brand.ex`](lib/layouts/brand.ex) and [`extra/images/logo.svg`](extra/images/logo.svg)
- Page titles and meta descriptions (translated): [`lib/layouts/root_layout.ex`](lib/layouts/root_layout.ex)
- Open Graph image: [`extra/images/og.svg`](extra/images/og.svg)

### Launch date

Change `@target` in [`lib/soonex_i18n/launch.ex`](lib/soonex_i18n/launch.ex). The hero badge and countdown both read it, and the label is formatted for the active locale.

### Themes

Each theme in `config :corex_design` (in [`config/config.exs`](config/config.exs)) accepts `seeds`, `colors.light` and `colors.dark`, `dimensions.radius`, `dimensions.font`, and `typography`, plus top-level `scales`. After editing, run:

```shell
mix corex.design.build
```

Keep styling in Corex `ui-*` modifiers and design tokens in HEEx. [`assets/css/hosts.css`](assets/css/hosts.css) and [`assets/css/chrome.css`](assets/css/chrome.css) only hold small layout helpers.

### Home sections

Sections live in [`lib/pages/home/`](lib/pages/home/) and are composed in [`lib/pages/home_page.ex`](lib/pages/home_page.ex). Shared spacing and type classes are in [`lib/layouts/shell.ex`](lib/layouts/shell.ex), and [`lib/layouts/section.ex`](lib/layouts/section.ex) provides the `block` component with `:root`, `:surface`, `:inverse`, and `:photo` tones.

Photos live in [`extra/images/photos/`](extra/images/photos/) and post covers in [`extra/images/covers/`](extra/images/covers/).

### Waitlist

The form is in [`lib/pages/home/waitlist.ex`](lib/pages/home/waitlist.ex) and the toast in [`assets/js/waitlist.js`](assets/js/waitlist.js). Point the form at your email provider or endpoint before launch; field names are `waitlist[email]`, `waitlist[role]`, and `waitlist[notes]`.

### Journal

Posts are Markdown files in [`_posts/`](_posts/) with `layout: SoonexI18n.PostLayout`. Each translation is its own file (`my-post.md`, `my-post-fr.md`, `my-post-ar.md`) with a locale-prefixed `permalink` such as `/fr/blog/my-post/`. Blog, tag, and home listings only show posts whose permalink matches the page's locale. Keep the slug identical across translations so the language switcher lands on the matching post.

Front matter supports `title`, `date`, `permalink`, `description`, `image`, `image_alt`, `tags`, and `sitemap`. Use relative links between posts (`../other-post/`) and to images (`../../../images/...`) so they keep working under a deploy subpath. The post [Writing in the journal](_posts/2026-09-08-writing-in-the-journal.md) shows every supported Markdown feature. In development only, drafts in `_drafts/`, work-in-progress pages in `_wip/`, and future-dated posts are rendered too.

### Accessibility and cookies

The accessibility panel is configured in [`lib/soonex_i18n/accessibility.ex`](lib/soonex_i18n/accessibility.ex), and cookie consent in [`lib/soonex_i18n/cookie_consent.ex`](lib/soonex_i18n/cookie_consent.ex). Update [`lib/pages/privacy_page.ex`](lib/pages/privacy_page.ex) for your jurisdiction.

## Deploying

1. Set `SOONEX_PUBLIC_URL` to your production origin. Subpaths such as `https://example.github.io/my-launch` are supported; asset and locale paths are prefixed automatically. Without it, builds use `https://corex-ui.github.io/soonex_i18n`.
2. Run `MIX_ENV=prod mix build`. If you changed permalinks, delete `_site/` first.
3. Publish `_site/` to any static host. [`lib/pages/not_found_page.ex`](lib/pages/not_found_page.ex) generates `404.html`.

For GitHub Pages, [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) deploys on pushes to `main` after [CI](.github/workflows/ci.yml) passes. Set **Settings > Pages > Source** to **GitHub Actions**.

## Renaming the project

1. Commit your work first; the rename cannot be undone automatically.
2. Run `mix project.rename your_app` (snake_case). See [`lib/mix/tasks/project.rename.ex`](lib/mix/tasks/project.rename.ex).
3. Run `mix format` and `mix compile`.

Only the `layout:` line in `_posts/*.md` is rewritten; post bodies are left as they are.

## Troubleshooting

**Port 4999 is already in use.** `mix server` and `mix test` both use port 4999 by default. Stop the other process, or run the tests on another port with `SOONEX_TEST_PORT=4998 mix test`.

```shell
ss -ltnp 'sport = :4999'          # Linux
lsof -nP -iTCP:4999 -sTCP:LISTEN  # macOS
```

**A string shows in English on the French or Arabic page.** Run `mix gettext.extract --merge` and translate the new entry. Entries marked `#, fuzzy` are ignored until you review them and remove the flag.

**Dates or locale names are missing.** Run `mix localize.download_locales`.

**Live reload does not work on Linux.** Install `inotify-tools` and restart the dev server.

**Wallaby cannot start a session.** Chrome and `chromedriver` must match versions. You can point at specific binaries with `WALLABY_CHROME_BINARY` and `WALLABY_CHROMEDRIVER_PATH`.

**Styles look stale after a Corex upgrade.** Run `mix corex.design.build`; generated CSS lives in `assets/corex/` (gitignored).

## Credits

Photography is from [Unsplash](https://unsplash.com) under the [Unsplash License](https://unsplash.com/license).

| File | Photographer |
| --- | --- |
| `photos/hero.jpg` | [Andrew Kliatskyi](https://unsplash.com/@kirp) |
| `photos/texture.jpg` | [Adrien Olichon](https://unsplash.com/@adrienolichon) |
| `photos/ribbons.jpg` | [Milad Fakurian](https://unsplash.com/@fakurian) |
| `photos/closing.jpg` | [Pawel Czerwinski](https://unsplash.com/@pawel_czerwinski) |
| `covers/waves.jpg` | [Milad Fakurian](https://unsplash.com/@fakurian) |
| `covers/spectrum.jpg` | [Milad Fakurian](https://unsplash.com/@fakurian) |
| `covers/haze.jpg` | [MagicPattern](https://unsplash.com/@magicpattern) |
| `covers/dusk.jpg` | [Martin Martz](https://unsplash.com/@martz90) |
| `covers/orbit.jpg` | [Martin Martz](https://unsplash.com/@martz90) |
| `covers/current.jpg` | [Martin Martz](https://unsplash.com/@martz90) |

Tool logos in `extra/images/tech/` come from [Simple Icons](https://simpleicons.org) (CC0), except `tableau.jpg`, which is the [Tableau project](https://github.com/elixir-tools/tableau) logo.

The Arabic typeface is [Noto Sans Arabic](https://fonts.google.com/noto/specimen/Noto+Sans+Arabic) under the [SIL Open Font License](https://openfontlicense.org).

## License

This repository does not include a license file yet. Add one before you redistribute a fork.
