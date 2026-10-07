---
layout: SoonexI18n.PostLayout
title: One config block, four themes
date: 2026-06-02 09:00:00 +0000
permalink: /en/blog/one-config-four-themes/
description: How Soonex turns a handful of color seeds into four complete themes with readable light and dark modes.
image: /images/covers/spectrum.jpg
image_alt: Abstract blue, orange, and yellow fluid shapes
tags:
  - Design
  - Themes
sitemap:
  priority: 0.8
  changefreq: monthly
---

Soonex has no theme stylesheets to maintain. The whole look comes from one block in `config/config.exs`, which Corex Design turns into tokens and component CSS.

## Seeds, not palettes

Each theme declares a few seed colors. Corex generates the full scale from them, including the ink, surface, border, and accent pairs, and checks that text stays readable against its background.

```elixir
config :corex_design,
  default_theme: :neo,
  themes: %{
    neo: %{seeds: %{accent: "#7c5cff"}},
    uno: %{seeds: %{accent: "#0f766e"}}
  }
```

After editing, rebuild the generated CSS:

```bash
mix corex.design.build
```

## What you can change

| Key | What it controls |
| --- | --- |
| `seeds` | Base colors the palette is generated from |
| `colors.light` / `colors.dark` | Per-mode overrides for specific tokens |
| `dimensions.radius` | Corner rounding across components |
| `dimensions.font` | Font family stacks |
| `typography` | Type scale and weights |

## Try it live

Open **Template Options** in the bottom corner of any page to switch between neo, uno, duo, and leo, or flip between light and dark mode. Your choice is saved locally, so it sticks as you move around the site.

> [!TIP]
> Keep the contrast targets that Corex generates. If a color feels too strong, adjust the seed instead of overriding individual text tokens.
