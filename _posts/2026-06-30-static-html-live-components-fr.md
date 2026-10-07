---
layout: SoonexI18n.PostLayout
title: Du HTML statique avec des composants vivants
date: 2026-06-30 09:00:00 +0000
permalink: /fr/blog/static-html-live-components/
description: Tableau génère la page, les hooks Corex animent les widgets, et aucun serveur Phoenix ne tourne en production.
image: /images/covers/current.jpg
image_alt: Courbes abstraites bleu sarcelle avec une lueur orange chaude
tags:
  - Ingénierie
sitemap:
  priority: 0.8
  changefreq: monthly
---

Les pages Soonex sont de simples fichiers HTML. Pourtant les onglets changent, l'accordéon s'ouvre, la liste déroulante se déplie et le compte à rebours défile. Voici comment.

## Le rendu avec Tableau

Chaque section de la page d'accueil est un composant fonctionnel HEEx dans `lib/pages/home/`. Tableau les appelle au moment du build et écrit le résultat dans `_site/`. Les articles du journal sont des fichiers Markdown dans `_posts/`, rendus avec le même layout.

## L'hydratation avec Corex

Les composants Corex produisent du balisage avec des attributs `phx-hook`. Dans le navigateur, `assets/js/site.js` enregistre les hooks correspondants, et chacun attache une machine à états [Zag](https://zagjs.com) qui gère la navigation au clavier, le focus et les états ARIA.

```javascript
import { Marquee } from "corex/marquee"
```

La plupart des hooks se chargent à la demande : le premier affichage ne paie que ce qui est à l'écran. Le défilement de logos se charge immédiatement parce qu'il se trouve en haut de page.

## Pas de chaîne d'outils Node

Tailwind et esbuild tournent comme des tâches Mix avec des binaires épinglés. Il n'y a pas de `package.json`, et la CI ne lance jamais `npm install`.

```bash
mix assets.build   # CSS Corex, Tailwind, esbuild
mix build          # build de production complet dans _site/
```

## Vérifié à chaque exécution

`mix test` construit le site, démarre un serveur local et lance un audit d'accessibilité axe sur la page d'accueil, en anglais et en arabe, dans Chrome headless. Si un changement casse le contraste ou la sémantique, la suite échoue avant toute mise en ligne.
