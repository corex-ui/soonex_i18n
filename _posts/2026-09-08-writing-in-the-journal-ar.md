---
layout: SoonexI18n.PostLayout
title: الكتابة في المدوّنة
date: 2026-09-08 09:00:00 +0000
permalink: /ar/blog/writing-in-the-journal/
description: دليل أسلوب لمقالات المدوّنة يعرض كل ميزات Markdown التي يدعمها Soonex.
image: /images/covers/dusk.jpg
image_alt: تلال مجردة بلون بنفسجي ومرجاني تحت كرة متوهجة
tags:
  - المدوّنة
  - أدلة
sitemap:
  priority: 0.6
  changefreq: monthly
---

مقالات المدوّنة ملفات Markdown داخل `_posts/` تحتوي على `layout: SoonexI18n.PostLayout` في الترويسة. أنشئ مقالًا جديدًا بالأمر:

```bash
mix soonex_i18n.gen.post My first update
```

تكتب المهمة ملفًا لكل لغة، مع اللاحقتين `-fr` و`-ar` للترجمات، ولكل ملف رابط دائم خاص به تحت `/<locale>/blog/`. ترجم النص والوسوم في كل ملف.

يصلح هذا المقال أيضًا مرجعًا لكل ما يدعمه مسار معالجة Markdown.

## الترويسة

```yaml
---
layout: SoonexI18n.PostLayout
title: تحديثي الأول
date: 2026-09-08 09:00:00 +0000
permalink: /ar/blog/my-first-update/
description: جملة واحدة للبطاقات ونتائج البحث.
image: /images/covers/dusk.jpg
image_alt: صِف الصورة لقارئات الشاشة
tags:
  - الإطلاق
---
```

## النص

استخدم **الخط العريض** و*المائل* و***كليهما*** و`الشيفرة المضمّنة` و~~الشطب~~. تعمل الروابط بصيغة [روابط Markdown](https://hexdocs.pm/corex)، وتتحول العناوين المجردة إلى روابط تلقائيًا: https://hexdocs.pm/mdex.

## القوائم

1. اكتب المقال
2. عاينه باستخدام `mix server`
3. أنشئ الإيداع وادفعه

- [x] اختيار صورة الغلاف
- [x] وصف أقل من 160 حرفًا
- [ ] المشاركة مع قائمة الانتظار

## الاقتباسات والتنبيهات

> انشر الصفحة التي تودّ أن تصل إليها.

> [!NOTE]
> تقدّم الملاحظات سياقًا مفيدًا.

> [!TIP]
> تقترح النصائح طريقة أفضل لإنجاز أمر ما.

> [!WARNING]
> تنبّه التحذيرات إلى ما قد يسوء.

## الجداول

| الأمر | الغرض |
| --- | --- |
| `mix server` | خادم تطوير مع إعادة تحميل حية |
| `mix assets.build` | إعادة بناء CSS وJavaScript |
| `MIX_ENV=prod mix build` | بناء الإنتاج داخل `_site/` |

## الشيفرة

```elixir
defmodule SoonexI18n.Launch do
  @target ~U[2026-12-01 00:00:00Z]

  def countdown_ms do
    max(DateTime.diff(@target, DateTime.utc_now(), :millisecond), 0)
  end
end
```

## الصور

![شعار Elixir](../../../images/tech/elixir.svg)

## الحواشي

يوجد تاريخ الإطلاق في وحدة واحدة[^launch].

[^launch]: تغذّي `SoonexI18n.Launch` شارة الواجهة الافتتاحية والعدّاد التنازلي معًا.

## HTML خام

<details>
<summary>اختصارات لوحة المفاتيح</summary>
<p>استخدم <kbd>Tab</kbd> للتنقل بين عناصر التحكم و<kbd>Enter</kbd> لتفعيلها.</p>
</details>
