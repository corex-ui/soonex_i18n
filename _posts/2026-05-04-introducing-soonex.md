---
layout: SoonexI18n.PostLayout
title: Introducing Soonex
date: 2026-05-04 09:00:00 +0000
permalink: /en/blog/introducing-soonex/
description: A launch page kit for Phoenix teams. Static HTML, accessible Corex components, and a waitlist that works on day one.
image: /images/covers/waves.jpg
image_alt: Flowing purple and pink gradient waves
tags:
  - Launch
  - Product
sitemap:
  priority: 0.9
  changefreq: monthly
---

Every product starts with a page that says "soon." It is usually the first thing people see, and it is often the least considered: a stock template, a form that goes nowhere, and contrast nobody checked.

Soonex is our answer. It is a launch page kit built on [Tableau](https://github.com/elixir-tools/tableau) and [Corex](https://hexdocs.pm/corex), so Phoenix teams can ship a polished, accessible coming-soon site with the tools they already use.

## What you get

- **A complete landing page**: hero with countdown, live component preview, capabilities, workflow, FAQ, and a closing waitlist band.
- **Four themes**: neo, uno, duo, and leo, each with light and dark modes generated from a few color seeds.
- **A working waitlist**: validated email field, role select, opt-in switch, and toast feedback, ready to connect to your provider.
- **A journal**: Markdown posts with tags, RSS, and pagination, so early followers can watch you build.
- **Accessibility controls**: text size, contrast, motion, focus ring, and link underline, saved on the visitor's device.
- **Three languages**: English, French, and Arabic with right-to-left layout, translated with Gettext and served under `/en/`, `/fr/`, and `/ar/`.

## Why static

A launch page should load instantly and cost nothing to host. Tableau renders plain HTML into `_site/`, which you can publish to GitHub Pages, Netlify, Cloudflare Pages, or any CDN. Corex hooks hydrate the interactive parts in the browser, so tabs, accordions, and selects still behave like real widgets.

## Getting started

```bash
git clone https://github.com/corex-ui/soonex_i18n.git
cd soonex_i18n
mix setup
mix server
```

Then open `http://localhost:4999`. From there, [One config block, four themes](../one-config-four-themes/) walks through branding, and [Shipping to GitHub Pages](../shipping-to-github-pages/) covers deployment.
