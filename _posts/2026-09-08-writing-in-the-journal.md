---
layout: SoonexI18n.PostLayout
title: Writing in the journal
date: 2026-09-08 09:00:00 +0000
permalink: /en/blog/writing-in-the-journal/
description: A style guide for journal posts, showing every Markdown feature the Soonex pipeline renders.
image: /images/covers/dusk.jpg
image_alt: Purple and coral abstract hills under a glowing sphere
tags:
  - Journal
  - Guides
sitemap:
  priority: 0.6
  changefreq: monthly
---

Journal posts are Markdown files in `_posts/` with `layout: SoonexI18n.PostLayout` in the front matter. Generate a new one with:

```bash
mix soonex_i18n.gen.post My first update
```

The task writes one file per locale, with `-fr` and `-ar` suffixes for the translations, each with its own `/<locale>/blog/` permalink. Translate the copy and tags in each file.

This post doubles as a reference for everything the Markdown pipeline supports.

## Front matter

```yaml
---
layout: SoonexI18n.PostLayout
title: My first update
date: 2026-09-08 09:00:00 +0000
permalink: /en/blog/my-first-update/
description: One sentence for cards and search results.
image: /images/covers/dusk.jpg
image_alt: Describe the image for screen readers
tags:
  - Launch
---
```

## Text

Use **bold**, *italic*, ***both***, `inline code`, and ~~strikethrough~~. Links work as [Markdown links](https://hexdocs.pm/corex) and bare URLs autolink: https://hexdocs.pm/mdex.

## Lists

1. Write the post
2. Preview it with `mix server`
3. Commit and push

- [x] Cover image chosen
- [x] Description under 160 characters
- [ ] Shared with the waitlist

## Quotes and alerts

> Ship the page you would want to land on.

> [!NOTE]
> Notes call out useful context.

> [!TIP]
> Tips suggest a better way to do something.

> [!WARNING]
> Warnings flag something that could go wrong.

## Tables

| Command | Purpose |
| --- | --- |
| `mix server` | Dev server with live reload |
| `mix assets.build` | Rebuild CSS and JavaScript |
| `MIX_ENV=prod mix build` | Production build into `_site/` |

## Code

```elixir
defmodule SoonexI18n.Launch do
  @target ~U[2026-12-01 00:00:00Z]

  def countdown_ms do
    max(DateTime.diff(@target, DateTime.utc_now(), :millisecond), 0)
  end
end
```

## Images

![Elixir logo](../../../images/tech/elixir.svg)

## Footnotes

The launch date lives in one module[^launch].

[^launch]: `SoonexI18n.Launch` feeds both the hero badge and the countdown timer.

## Raw HTML

<details>
<summary>Keyboard shortcuts</summary>
<p>Use <kbd>Tab</kbd> to move between controls and <kbd>Enter</kbd> to activate them.</p>
</details>
