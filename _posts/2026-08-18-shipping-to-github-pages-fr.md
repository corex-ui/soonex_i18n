---
layout: SoonexI18n.PostLayout
title: Publier sur GitHub Pages
date: 2026-08-18 09:00:00 +0000
permalink: /fr/blog/shipping-to-github-pages/
description: Définissez votre URL publique, construisez dans _site/ et laissez la CI valider chaque déploiement.
image: /images/covers/orbit.jpg
image_alt: Cercles bleu sarcelle superposés avec une douce lumière orange sur le bord
tags:
  - Lancement
  - Ingénierie
sitemap:
  priority: 0.8
  changefreq: monthly
---

Soonex produit un dossier de fichiers statiques : déployer, c'est surtout lui dire où il va vivre.

## 1. Définir votre URL publique

Les builds de production lisent `SOONEX_PUBLIC_URL` pour générer les liens canoniques, les balises Open Graph, les liens hreflang et les chemins des assets. Si votre site est servi sous un sous-chemin, comme une page de projet GitHub, le préfixe est appliqué automatiquement.

```bash
export SOONEX_PUBLIC_URL="https://example.github.io/my-launch"
```

Sans cette variable, le build utilise l'URL de démo `https://corex-ui.github.io/soonex_i18n`.

## 2. Construire

```bash
MIX_ENV=prod mix build
```

Cette commande compile le projet, génère le CSS Corex, rend chaque page dans chaque langue avec Tableau, puis minifie le CSS et le JavaScript dans `_site/`.

> [!IMPORTANT]
> Si vous modifiez des permaliens, supprimez `_site/` avant le build pour ne pas publier de pages obsolètes.

## 3. Déployer avec GitHub Actions

Le dépôt contient deux workflows :

1. **CI** (`.github/workflows/ci.yml`) lance la suite de tests, audit axe compris, à chaque push et pull request.
2. **Deploy** (`.github/workflows/deploy.yml`) publie `_site/` sur GitHub Pages, mais seulement après la réussite de la CI sur `main`.

Dans les réglages du dépôt, choisissez **Pages > Source** puis **GitHub Actions**. C'est tout.

## Autres hébergeurs

N'importe quel hébergeur statique convient. Pointez-le vers `_site/` après le build et vérifiez que `404.html` est servi pour les pages introuvables.
