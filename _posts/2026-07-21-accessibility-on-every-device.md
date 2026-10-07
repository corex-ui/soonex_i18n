---
layout: SoonexI18n.PostLayout
title: Accessibility on every device
date: 2026-07-21 09:00:00 +0000
permalink: /en/blog/accessibility-on-every-device/
description: Text size, contrast, motion, focus, and link underline controls that visitors set once and keep.
image: /images/covers/haze.jpg
image_alt: Soft blurred purple and blue gradient
tags:
  - Accessibility
sitemap:
  priority: 0.8
  changefreq: monthly
---

People read the web in different ways. Soonex ships the Corex accessibility panel so visitors can adjust the page to suit them, without an account and without a backend.

## The controls

Open the person icon in the bottom corner of any page:

- **Text size** scales the whole interface, not just body copy.
- **Contrast** switches to a higher-contrast palette generated from the same theme.
- **Motion** reduces animation, including smooth scrolling and card hover effects.
- **Focus** makes the keyboard focus ring more prominent.
- **Link underline** underlines every link for easier scanning.

Preferences are stored in `localStorage` under `phx:a11y` and applied by a small head script before the page paints, so there is no flash of the default style.

## Respecting system settings

Soonex also follows `prefers-reduced-motion` and the visitor's light or dark preference until they pick a mode themselves.

## Configuring it

The panel lives in `lib/soonex_i18n/accessibility.ex`. After changing accessibility options in your Corex config, rebuild the design assets:

```bash
mix corex.design.build
```

> [!NOTE]
> Accessibility settings count as necessary preferences, so they are saved even when a visitor declines optional cookies.
