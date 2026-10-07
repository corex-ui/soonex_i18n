---
layout: SoonexI18n.PostLayout
title: Static HTML with live components
date: 2026-06-30 09:00:00 +0000
permalink: /en/blog/static-html-live-components/
description: Tableau renders the page, Corex hooks bring the widgets to life, and no Phoenix server runs in production.
image: /images/covers/current.jpg
image_alt: Dark teal abstract curves with a warm orange glow
tags:
  - Engineering
sitemap:
  priority: 0.8
  changefreq: monthly
---

Soonex pages are plain HTML files. Yet the tabs switch, the accordion expands, the select opens, and the countdown ticks. Here is how that works.

## Rendering with Tableau

Each section of the home page is a HEEx function component under `lib/pages/home/`. Tableau calls them at build time and writes the result to `_site/`. Blog posts are Markdown files in `_posts/` rendered through the same layout.

## Hydrating with Corex

Corex components render markup with `phx-hook` attributes. In the browser, `assets/js/site.js` registers the matching hooks, and each one attaches a [Zag](https://zagjs.com) state machine that handles keyboard navigation, focus, and ARIA state.

```javascript
import { Marquee } from "corex/marquee"
```

Most hooks load lazily, so the first paint only pays for what is on screen. The marquee loads eagerly because it sits near the top of the page.

## No Node toolchain

Tailwind and esbuild run as Mix tasks with pinned binaries. There is no `package.json`, and CI never runs `npm install`.

```bash
mix assets.build   # Corex design CSS, Tailwind, esbuild
mix build          # full production build into _site/
```

## Checked on every run

`mix test` builds the site, starts a local server, and runs an axe accessibility audit on the home page in English and Arabic in headless Chrome. If a change breaks contrast or semantics, the suite fails before anything ships.
