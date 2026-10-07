---
layout: SoonexI18n.PostLayout
title: Écrire dans le journal
date: 2026-09-08 09:00:00 +0000
permalink: /fr/blog/writing-in-the-journal/
description: Un guide de style pour les articles du journal, avec chaque fonctionnalité Markdown prise en charge par Soonex.
image: /images/covers/dusk.jpg
image_alt: Collines abstraites violettes et corail sous une sphère lumineuse
tags:
  - Journal
  - Guides
sitemap:
  priority: 0.6
  changefreq: monthly
---

Les articles du journal sont des fichiers Markdown dans `_posts/` avec `layout: SoonexI18n.PostLayout` dans le front matter. Créez-en un avec :

```bash
mix soonex_i18n.gen.post My first update
```

La tâche écrit un fichier par langue, avec les suffixes `-fr` et `-ar` pour les traductions, chacun avec son propre permalien `/<locale>/blog/`. Traduisez le texte et les tags dans chaque fichier.

Cet article sert aussi de référence pour tout ce que le pipeline Markdown prend en charge.

## Front matter

```yaml
---
layout: SoonexI18n.PostLayout
title: Ma première mise à jour
date: 2026-09-08 09:00:00 +0000
permalink: /fr/blog/my-first-update/
description: Une phrase pour les cartes et les résultats de recherche.
image: /images/covers/dusk.jpg
image_alt: Décrivez l'image pour les lecteurs d'écran
tags:
  - Lancement
---
```

## Texte

Utilisez le **gras**, l'*italique*, les ***deux***, le `code en ligne` et le ~~barré~~. Les liens fonctionnent en [liens Markdown](https://hexdocs.pm/corex) et les URL nues deviennent des liens : https://hexdocs.pm/mdex.

## Listes

1. Écrire l'article
2. Le prévisualiser avec `mix server`
3. Commiter et pousser

- [x] Image de couverture choisie
- [x] Description de moins de 160 caractères
- [ ] Partagé avec la liste d'attente

## Citations et alertes

> Publiez la page sur laquelle vous aimeriez arriver.

> [!NOTE]
> Les notes apportent un contexte utile.

> [!TIP]
> Les astuces suggèrent une meilleure façon de faire.

> [!WARNING]
> Les avertissements signalent ce qui pourrait mal tourner.

## Tableaux

| Commande | Rôle |
| --- | --- |
| `mix server` | Serveur de dev avec rechargement à chaud |
| `mix assets.build` | Régénère le CSS et le JavaScript |
| `MIX_ENV=prod mix build` | Build de production dans `_site/` |

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

![Logo Elixir](../../../images/tech/elixir.svg)

## Notes de bas de page

La date de lancement se trouve dans un seul module[^launch].

[^launch]: `SoonexI18n.Launch` alimente à la fois le badge du hero et le compte à rebours.

## HTML brut

<details>
<summary>Raccourcis clavier</summary>
<p>Utilisez <kbd>Tab</kbd> pour passer d'un contrôle à l'autre et <kbd>Entrée</kbd> pour les activer.</p>
</details>
