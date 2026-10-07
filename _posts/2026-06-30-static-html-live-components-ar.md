---
layout: SoonexI18n.PostLayout
title: HTML ثابت بمكوّنات حية
date: 2026-06-30 09:00:00 +0000
permalink: /ar/blog/static-html-live-components/
description: يولّد Tableau الصفحة، وتبثّ خطافات Corex الحياة في العناصر، ولا يعمل أي خادم Phoenix في بيئة الإنتاج.
image: /images/covers/current.jpg
image_alt: منحنيات مجردة بلون أزرق مخضر داكن مع توهج برتقالي دافئ
tags:
  - الهندسة
sitemap:
  priority: 0.8
  changefreq: monthly
---

صفحات Soonex ملفات HTML عادية. ومع ذلك تتبدّل علامات التبويب، وينفتح الأكورديون، وتنسدل القائمة، ويعدّ العدّاد التنازلي. إليك كيف يعمل ذلك.

## التوليد باستخدام Tableau

كل قسم من الصفحة الرئيسية مكوّن HEEx وظيفي داخل `lib/pages/home/`. يستدعيها Tableau وقت البناء ويكتب النتيجة في `_site/`. أما مقالات المدوّنة فهي ملفات Markdown داخل `_posts/` تُعرض بالقالب نفسه.

## التفعيل باستخدام Corex

تُخرج مكوّنات Corex ترميزًا يحمل سمات `phx-hook`. وفي المتصفح يسجّل `assets/js/site.js` الخطافات المطابقة، ويربط كل منها آلة حالات من [Zag](https://zagjs.com) تتولى التنقل بلوحة المفاتيح والتركيز وحالات ARIA.

```javascript
import { Marquee } from "corex/marquee"
```

تُحمَّل معظم الخطافات عند الحاجة، فلا يدفع العرض الأول إلا ثمن ما يظهر على الشاشة. ويُحمَّل شريط الشعارات مباشرة لأنه قريب من أعلى الصفحة.

## بلا أدوات Node

يعمل Tailwind وesbuild كمهام Mix بملفات تنفيذية مثبّتة الإصدار. لا يوجد `package.json`، ولا تشغّل بيئة CI الأمر `npm install` أبدًا.

```bash
mix assets.build   # Corex design CSS, Tailwind, esbuild
mix build          # full production build into _site/
```

## فحص في كل تشغيل

يبني `mix test` الموقع، ويشغّل خادمًا محليًا، ويُجري تدقيق إمكانية الوصول axe على الصفحة الرئيسية بالإنجليزية والعربية في Chrome دون واجهة. إذا أفسد تغيير ما التباين أو الدلالات، تفشل الاختبارات قبل أي نشر.
