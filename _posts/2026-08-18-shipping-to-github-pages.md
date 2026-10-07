---
layout: SoonexI18n.PostLayout
title: Shipping to GitHub Pages
date: 2026-08-18 09:00:00 +0000
permalink: /en/blog/shipping-to-github-pages/
description: Set your public URL, build into _site/, and let CI gate every deploy.
image: /images/covers/orbit.jpg
image_alt: Overlapping teal circles with a soft orange edge light
tags:
  - Launch
  - Engineering
sitemap:
  priority: 0.8
  changefreq: monthly
---

Soonex builds to a folder of static files, so deploying is mostly about telling it where it will live.

## 1. Set your public URL

Production builds read `SOONEX_PUBLIC_URL` to generate canonical links, Open Graph tags, hreflang links, and asset paths. If your site lives under a subpath, such as a GitHub project page, the prefix is applied automatically.

```bash
export SOONEX_PUBLIC_URL="https://example.github.io/my-launch"
```

Without it, builds fall back to the demo URL `https://corex-ui.github.io/soonex_i18n`.

## 2. Build

```bash
MIX_ENV=prod mix build
```

This compiles the project, builds Corex design CSS, renders every page in every language with Tableau, and minifies CSS and JavaScript into `_site/`.

> [!IMPORTANT]
> If you change permalinks, delete `_site/` before building so stale pages are not published.

## 3. Deploy with GitHub Actions

The repo includes two workflows:

1. **CI** (`.github/workflows/ci.yml`) runs the test suite, including the axe audit, on every push and pull request.
2. **Deploy** (`.github/workflows/deploy.yml`) publishes `_site/` to GitHub Pages, but only after CI succeeds on `main`.

In your repository settings, set **Pages > Source** to **GitHub Actions**. That is the whole setup.

## Other hosts

Any static host works. Point it at `_site/` after running the build, and make sure `404.html` is served for missing pages.
