defmodule SoonexI18n.BlogIndexPage do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  def template(assigns) do
    locale = Gettext.get_locale(SoonexI18n.Gettext)
    locale_prefix = "/#{locale}/"

    posts =
      assigns
      |> Map.get(:posts, [])
      |> List.wrap()
      |> Enum.filter(fn post ->
        permalink = post[:permalink] || post["permalink"] || ""
        String.starts_with?(permalink, locale_prefix)
      end)
      |> Enum.sort_by(& &1[:date], {:desc, DateTime})

    assigns =
      assigns
      |> Map.put(:sorted_posts, posts)
      |> Map.put(:blog_count, length(posts))

    ~H"""
    <article class={"#{Shell.stage()} flex min-h-dvh flex-col gap-space-xl pt-size-xl pb-size-xl"}>
      <nav class="blog__nav" aria-label={~t"Blog"}>
        <.navigate to={~p"/"} class="link ui-nav w-fit">
          <.heroicon name="hero-arrow-left" /> {~t"Back to home"}
        </.navigate>
      </nav>

      <header class="blog__hero" aria-labelledby="blog-index-heading">
        <div class="blog__head">
          <p class="blog__eyebrow">{~t"Journal"}</p>
          <h1 id="blog-index-heading" class="blog__display">
            {~t"All"} <span class="blog__display__accent">{~t"posts"}</span>
          </h1>
          <p class="blog__lede">
            {~t"Markdown in"}
            <code class="rounded-md bg-surface px-space-xs py-space-xs text-sm">_posts/</code>
            {~t"— compiled by Tableau into static pages you can host anywhere."}
          </p>
          <p class="blog__meta">
            <span>
              {@blog_count} {if @blog_count == 1, do: ~t"post", else: ~t"posts"}
            </span>
          </p>
        </div>
      </header>

      <ul :if={@sorted_posts != []} class="blog__grid m-0 list-none p-0">
        <li :for={post <- @sorted_posts}>
          <.navigate to={SoonexI18n.Public.path(post.permalink)} class={"#{Shell.card()}"}>
            <div class="blog__card__top">
              <p :if={post_date_label(post)} class="blog__card__date">{post_date_label(post)}</p>
              <span :if={is_nil(post_date_label(post))}></span>
              <.heroicon name="hero-arrow-right" class="blog__card__arrow" />
            </div>
            <h2 class="blog__card__title">{post[:title] || ~t"Untitled"}</h2>
            <p :if={post[:description]} class="blog__card__excerpt">{post[:description]}</p>
            <ul
              :if={post_tags(post) != []}
              class="m-0 flex list-none flex-wrap gap-space-sm p-0 blog__card__tags"
            >
              <li :for={tag <- post_tags(post)}>
                <span class="badge ui-size-sm">{tag}</span>
              </li>
            </ul>
          </.navigate>
        </li>
      </ul>
      <p :if={@sorted_posts == []} class="m-0 text-ink-muted">
        {~t"No posts yet. Add Markdown files to"}
        <code class="rounded-md bg-surface px-space-xs py-space-xs text-sm">_posts/</code>
        {~t"to get started."}
      </p>
    </article>
    """
  end

  defp post_date_label(%{date: %DateTime{} = date}), do: Calendar.strftime(date, "%Y-%m-%d")
  defp post_date_label(_), do: nil

  defp post_tags(post) do
    post
    |> Map.get(:tags, [])
    |> List.wrap()
    |> Enum.filter(&is_binary/1)
  end
end

for locale <- SoonexI18n.Locale.locales() do
  mod = Module.concat(SoonexI18n.BlogIndexPage, String.upcase(locale))

  permalink = "/#{locale}/blog"

  title = "Blog"

  Module.create(
    mod,
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote(permalink),
        title: unquote(title),
        page_kind: :blog_index,
        sitemap: %{priority: 0.7, changefreq: "weekly"}

      def template(assigns), do: SoonexI18n.BlogIndexPage.template(assigns)
    end,
    __ENV__
  )
end
