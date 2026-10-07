defmodule SoonexI18n.BlogIndexPage do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.Layouts.Articles, only: [cards: 1, pager: 1]

  alias SoonexI18n.Layouts.Shell

  def template(assigns) do
    posts = SoonexI18n.Locale.local_posts(Map.get(assigns, :posts, []), assigns.page)

    assigns =
      assigns
      |> Map.put(:sorted_posts, posts)
      |> Map.put(:blog_count, length(posts))

    ~H"""
    <article class={"#{Shell.section()} bg-root"}>
      <div class={Shell.stage()}>
        <.layout_heading class="layout-heading" subtitle_tag="p">
          <:title>{~t"Journal"}</:title>
          <:subtitle>
            {~t"Shipping notes for Corex, the waitlist, and launch prep."}
            {ngettext("%{count} post.", "%{count} posts.", @blog_count)}
          </:subtitle>
          <:actions>
            <.navigate to={~p"/"} class="button ui-ghost ui-size-sm">
              <.heroicon name="hero-arrow-left" /> {~t"Home"}
            </.navigate>
            <.navigate to={~p"/tags"} class="button ui-ghost ui-size-sm">
              {~t"Tags"}
            </.navigate>
          </:actions>
        </.layout_heading>

        <div class="mt-16">
          <.cards posts={@sorted_posts} pager_id="soonex-blog-pagination" page_size={3} />
          <.pager id="soonex-blog-pagination" count={@blog_count} page_size={3} />
        </div>
      </div>
    </article>
    """
  end
end

for locale <- SoonexI18n.Locale.locales() do
  Module.create(
    Module.concat(SoonexI18n.BlogIndexPage, String.upcase(locale)),
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote("/#{locale}/blog"),
        title: "Journal",
        page_kind: :blog_index,
        sitemap: %{priority: 0.7, changefreq: "weekly"}

      def template(assigns), do: SoonexI18n.BlogIndexPage.template(assigns)
    end,
    __ENV__
  )
end
