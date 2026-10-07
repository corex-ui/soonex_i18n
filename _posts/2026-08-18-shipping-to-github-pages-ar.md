---
layout: SoonexI18n.PostLayout
title: النشر على GitHub Pages
date: 2026-08-18 09:00:00 +0000
permalink: /ar/blog/shipping-to-github-pages/
description: حدّد عنوانك العام، وابنِ الموقع في _site/، ودع CI تتحقق من كل عملية نشر.
image: /images/covers/orbit.jpg
image_alt: دوائر متداخلة بلون أزرق مخضر مع إضاءة برتقالية ناعمة على الحافة
tags:
  - الإطلاق
  - الهندسة
sitemap:
  priority: 0.8
  changefreq: monthly
---

يُخرج Soonex مجلدًا من الملفات الثابتة، لذا فالنشر في معظمه هو إخباره بالمكان الذي سيعيش فيه.

## 1. حدّد عنوانك العام

تقرأ عمليات البناء للإنتاج المتغير `SOONEX_PUBLIC_URL` لتوليد الروابط القانونية ووسوم Open Graph وروابط hreflang ومسارات الملفات. إذا كان موقعك تحت مسار فرعي، مثل صفحة مشروع على GitHub، تُطبَّق البادئة تلقائيًا.

```bash
export SOONEX_PUBLIC_URL="https://example.github.io/my-launch"
```

من دونه، تعود عمليات البناء إلى عنوان العرض التجريبي `https://corex-ui.github.io/soonex_i18n`.

## 2. البناء

```bash
MIX_ENV=prod mix build
```

يُصرِّف هذا الأمر المشروع، ويبني CSS الخاص بـ Corex، ويولّد كل صفحة بكل لغة عبر Tableau، ثم يصغّر CSS وJavaScript داخل `_site/`.

> [!IMPORTANT]
> إذا غيّرت الروابط الدائمة، فاحذف `_site/` قبل البناء حتى لا تُنشر صفحات قديمة.

## 3. النشر باستخدام GitHub Actions

يتضمن المستودع سير عمل اثنين:

1. **CI** (`.github/workflows/ci.yml`) يشغّل الاختبارات، بما فيها تدقيق axe، مع كل دفع وطلب سحب.
2. **Deploy** (`.github/workflows/deploy.yml`) ينشر `_site/` على GitHub Pages، ولكن فقط بعد نجاح CI على الفرع `main`.

في إعدادات المستودع، اضبط **Pages > Source** على **GitHub Actions**. هذا كل ما في الأمر.

## استضافات أخرى

تعمل أي استضافة للمواقع الثابتة. وجّهها إلى `_site/` بعد البناء، وتأكد من تقديم `404.html` للصفحات غير الموجودة.
