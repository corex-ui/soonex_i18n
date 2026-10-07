---
layout: SoonexI18n.PostLayout
title: L'accessibilité sur chaque appareil
date: 2026-07-21 09:00:00 +0000
permalink: /fr/blog/accessibility-on-every-device/
description: Taille du texte, contraste, animations, focus et soulignement des liens, réglés une fois et conservés par les visiteurs.
image: /images/covers/haze.jpg
image_alt: Dégradé flou et doux violet et bleu
tags:
  - Accessibilité
sitemap:
  priority: 0.8
  changefreq: monthly
---

Chacun lit le web à sa façon. Soonex intègre le panneau d'accessibilité Corex pour que les visiteurs adaptent la page à leurs besoins, sans compte et sans backend.

## Les réglages

Ouvrez l'icône de personne dans le coin inférieur de n'importe quelle page :

- **Taille du texte** agrandit toute l'interface, pas seulement le corps du texte.
- **Contraste** passe à une palette plus contrastée, générée à partir du même thème.
- **Animations** réduit les mouvements, y compris le défilement fluide et les effets au survol des cartes.
- **Focus** rend l'anneau de focus clavier plus visible.
- **Soulignement des liens** souligne chaque lien pour faciliter la lecture.

Les préférences sont stockées dans `localStorage` sous `phx:a11y` et appliquées par un petit script dans le `<head>` avant l'affichage, sans flash du style par défaut.

## Respect des réglages du système

Soonex suit aussi `prefers-reduced-motion` et la préférence claire ou sombre du visiteur, jusqu'à ce qu'il choisisse un mode lui-même.

## Configuration

Le panneau se trouve dans `lib/soonex_i18n/accessibility.ex`. Après avoir modifié les options d'accessibilité dans votre config Corex, régénérez les assets de design :

```bash
mix corex.design.build
```

> [!NOTE]
> Les réglages d'accessibilité comptent comme des préférences nécessaires : ils sont enregistrés même si le visiteur refuse les cookies optionnels.
