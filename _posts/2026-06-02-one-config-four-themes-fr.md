---
layout: SoonexI18n.PostLayout
title: Un bloc de config, quatre thèmes
date: 2026-06-02 09:00:00 +0000
permalink: /fr/blog/one-config-four-themes/
description: Comment Soonex transforme quelques couleurs de base en quatre thèmes complets, lisibles en mode clair comme en mode sombre.
image: /images/covers/spectrum.jpg
image_alt: Formes fluides abstraites bleues, orange et jaunes
tags:
  - Design
  - Thèmes
sitemap:
  priority: 0.8
  changefreq: monthly
---

Soonex n'a aucune feuille de style de thème à maintenir. Toute l'apparence vient d'un seul bloc dans `config/config.exs`, que Corex Design transforme en tokens et en CSS de composants.

## Des graines, pas des palettes

Chaque thème déclare quelques couleurs de base. Corex en génère l'échelle complète, y compris les paires encre, surface, bordure et accent, et vérifie que le texte reste lisible sur son fond.

```elixir
config :corex_design,
  default_theme: :neo,
  themes: %{
    neo: %{seeds: %{accent: "#7c5cff"}},
    uno: %{seeds: %{accent: "#0f766e"}}
  }
```

Après modification, régénérez le CSS :

```bash
mix corex.design.build
```

## Ce que vous pouvez modifier

| Clé | Ce qu'elle contrôle |
| --- | --- |
| `seeds` | Couleurs de base à partir desquelles la palette est générée |
| `colors.light` / `colors.dark` | Surcharges par mode pour des tokens précis |
| `dimensions.radius` | Arrondi des angles dans tous les composants |
| `dimensions.font` | Piles de polices |
| `typography` | Échelle typographique et graisses |

## Essayez en direct

Ouvrez **Options du modèle** dans le coin inférieur de n'importe quelle page pour passer de neo à uno, duo ou leo, ou basculer entre les modes clair et sombre. Votre choix est enregistré localement et vous suit sur tout le site.

> [!TIP]
> Conservez les cibles de contraste générées par Corex. Si une couleur paraît trop forte, ajustez la graine plutôt que de surcharger des tokens de texte.
