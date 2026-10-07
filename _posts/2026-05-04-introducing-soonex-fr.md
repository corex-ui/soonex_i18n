---
layout: SoonexI18n.PostLayout
title: Voici Soonex
date: 2026-05-04 09:00:00 +0000
permalink: /fr/blog/introducing-soonex/
description: Un kit de page de lancement pour les équipes Phoenix. HTML statique, composants Corex accessibles et une liste d'attente prête dès le premier jour.
image: /images/covers/waves.jpg
image_alt: Vagues de dégradé violet et rose
tags:
  - Lancement
  - Produit
sitemap:
  priority: 0.9
  changefreq: monthly
---

Chaque produit commence par une page qui annonce « bientôt ». C'est souvent la première chose que les gens voient, et souvent la moins soignée : un modèle générique, un formulaire qui ne mène nulle part et un contraste que personne n'a vérifié.

Soonex est notre réponse. C'est un kit de page de lancement construit sur [Tableau](https://github.com/elixir-tools/tableau) et [Corex](https://hexdocs.pm/corex), pour que les équipes Phoenix publient un site « bientôt disponible » soigné et accessible avec les outils qu'elles utilisent déjà.

## Ce que vous obtenez

- **Une page d'accueil complète** : hero avec compte à rebours, aperçu de composants en direct, fonctionnalités, méthode, FAQ et un bandeau final d'inscription.
- **Quatre thèmes** : neo, uno, duo et leo, chacun avec des modes clair et sombre générés à partir de quelques couleurs de base.
- **Une liste d'attente fonctionnelle** : champ e-mail validé, sélection du rôle, interrupteur d'inscription et notification, prête à être reliée à votre fournisseur.
- **Un journal** : articles Markdown avec tags, RSS et pagination, pour que vos premiers abonnés suivent la construction.
- **Des réglages d'accessibilité** : taille du texte, contraste, animations, anneau de focus et soulignement des liens, enregistrés sur l'appareil du visiteur.
- **Trois langues** : anglais, français et arabe avec mise en page de droite à gauche, traduits avec Gettext et servis sous `/en/`, `/fr/` et `/ar/`.

## Pourquoi du statique

Une page de lancement doit s'afficher instantanément et ne rien coûter à héberger. Tableau génère du HTML simple dans `_site/`, que vous pouvez publier sur GitHub Pages, Netlify, Cloudflare Pages ou n'importe quel CDN. Les hooks Corex hydratent les parties interactives dans le navigateur, si bien que les onglets, accordéons et listes déroulantes se comportent comme de vrais widgets.

## Pour commencer

```bash
git clone https://github.com/corex-ui/soonex_i18n.git
cd soonex_i18n
mix setup
mix server
```

Ouvrez ensuite `http://localhost:4999`. De là, [Un bloc de config, quatre thèmes](../one-config-four-themes/) explique la personnalisation, et [Publier sur GitHub Pages](../shipping-to-github-pages/) couvre le déploiement.
