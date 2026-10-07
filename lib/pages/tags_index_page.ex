defmodule SoonexI18n.TagsIndexPage do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.Layouts.Articles, only: [cards: 1]

  alias SoonexI18n.Layouts.Shell

  def template(assigns) do
    groups =
      assigns
      |> Map.get(:posts, [])
      |> SoonexI18n.Locale.local_posts(assigns.page)
      |> Enum.flat_map(fn post -> Enum.map(post_tags(post), &{&1, post}) end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.sort_by(fn {tag, posts} -> {-length(posts), tag} end)
      |> Enum.map(fn {tag, posts} -> %{label: tag, id: "tag-" <> slug(tag), posts: posts} end)

    assigns = Map.put(assigns, :tag_groups, groups)

    ~H"""
    <article class={"#{Shell.section()} bg-root"}>
      <div class={Shell.stage()}>
        <.layout_heading class="layout-heading" subtitle_tag="p">
          <:title>{~t"Tags"}</:title>
          <:subtitle>{~t"Browse the journal by topic"}</:subtitle>
          <:actions>
            <.navigate to={~p"/blog"} class="button ui-ghost ui-size-sm">
              <.heroicon name="hero-arrow-left" /> {~t"Journal"}
            </.navigate>
          </:actions>
        </.layout_heading>

        <div :if={@tag_groups == []} class={"#{Shell.panel()} mt-16 p-8 text-ink-muted"}>
          <p class="m-0">{~t"No tags yet."}</p>
        </div>

        <nav :if={@tag_groups != []} class="mt-12" aria-label={~t"Tags"}>
          <ul class="m-0 flex list-none flex-wrap gap-2 p-0">
            <li :for={group <- @tag_groups}>
              <.navigate to={"#" <> group.id} class="button ui-ghost ui-size-sm">
                {group.label}
                <span class="badge ui-size-sm">{length(group.posts)}</span>
              </.navigate>
            </li>
          </ul>
        </nav>

        <section
          :for={group <- @tag_groups}
          id={group.id}
          class="mt-16 scroll-mt-24"
          aria-labelledby={group.id <> "-heading"}
        >
          <h2
            id={group.id <> "-heading"}
            class="display m-0 text-2xl font-semibold tracking-tight text-ink"
          >
            {group.label}
          </h2>
          <p class="mt-2 text-sm/6 text-ink-muted">
            {ngettext("%{count} post", "%{count} posts", length(group.posts))}
          </p>
          <div class="mt-8">
            <.cards posts={group.posts} page_size={length(group.posts)} />
          </div>
        </section>
      </div>
    </article>
    """
  end

  defp post_tags(post) do
    post
    |> Map.get(:tags, [])
    |> List.wrap()
    |> Enum.filter(&is_binary/1)
  end

  defp slug(tag) do
    tag
    |> String.downcase()
    |> String.replace(~r/[^\p{L}\p{N}]+/u, "-")
    |> String.trim("-")
  end
end

for locale <- SoonexI18n.Locale.locales() do
  Module.create(
    Module.concat(SoonexI18n.TagsIndexPage, String.upcase(locale)),
    quote do
      use Tableau.Page,
        layout: SoonexI18n.RootLayout,
        permalink: unquote("/#{locale}/tags"),
        title: "Tags",
        page_kind: :tags_index,
        sitemap: %{priority: 0.5, changefreq: "weekly"}

      def template(assigns), do: SoonexI18n.TagsIndexPage.template(assigns)
    end,
    __ENV__
  )
end
