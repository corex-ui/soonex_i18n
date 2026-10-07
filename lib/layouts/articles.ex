defmodule SoonexI18n.Layouts.Articles do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  import SoonexI18n.Layouts.Media, only: [photo: 1]

  alias SoonexI18n.Layouts.Shell
  alias SoonexI18n.Locale

  attr(:posts, :list, required: true)
  attr(:empty, :string, default: nil)
  attr(:pager_id, :string, default: nil)
  attr(:page_size, :integer, default: 3)

  def cards(assigns) do
    ~H"""
    <div :if={@posts == []} class={"#{Shell.panel()} p-8 text-ink-muted"}>
      <p class="m-0">{@empty || ~t"No posts yet."}</p>
    </div>
    <div
      :if={@posts != []}
      class="grid grid-cols-1 gap-4 sm:grid-cols-2"
      data-soonex-page-list={@pager_id}
      data-page-size={@page_size}
    >
      <article
        :for={{post, index} <- Enum.with_index(@posts)}
        class={"#{Shell.frame()} soonex-card-motion flex flex-col overflow-hidden bg-surface"}
        data-soonex-page-item
        hidden={index >= @page_size}
      >
        <div :if={cover(post)} class="relative aspect-[16/10] overflow-hidden">
          <.photo src={cover(post).src} alt={cover(post).alt} width={1400} height={900} />
        </div>
        <div class="flex flex-1 flex-col p-8">
          <p :if={date_label(post)} class={Shell.eyebrow()}>{date_label(post)}</p>
          <h2 class="display mt-2 text-xl font-semibold tracking-tight text-ink sm:text-2xl">
            <.navigate to={SoonexI18n.Public.path(post.permalink)} class="link ui-nav">
              {post[:title] || ~t"Untitled"}
            </.navigate>
          </h2>
          <p :if={post[:description]} class="mt-3 flex-auto text-sm/6 text-ink-muted">
            {post[:description]}
          </p>
          <div :if={post_tags(post) != []} class="mt-6 flex flex-wrap gap-2">
            <span :for={tag <- post_tags(post)} class="badge ui-size-sm">{tag}</span>
          </div>
        </div>
      </article>
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:count, :integer, required: true)
  attr(:page_size, :integer, default: 6)

  def pager(assigns) do
    ~H"""
    <div class="mt-12 flex justify-center">
      <.pagination
        id={@id}
        class="pagination ui-brand ui-size-sm"
        count={@count}
        dir={Locale.dir(Locale.current())}
        page_size={@page_size}
        type={:button}
        on_page_change_client="soonex:page-change"
      >
        <:prev_trigger>
          <.heroicon name="hero-chevron-left" />
        </:prev_trigger>
        <:next_trigger>
          <.heroicon name="hero-chevron-right" />
        </:next_trigger>
        <:ellipsis>
          <.heroicon name="hero-ellipsis-horizontal" />
        </:ellipsis>
      </.pagination>
    </div>
    """
  end

  defp cover(post) do
    src = post[:image]

    if is_binary(src) and src != "" do
      %{src: src, alt: post[:image_alt] || post[:title] || ~t"Journal cover"}
    end
  end

  defp date_label(%{date: %DateTime{} = date}), do: Locale.format_date(date)
  defp date_label(_), do: nil

  defp post_tags(post) do
    post
    |> Map.get(:tags, [])
    |> List.wrap()
    |> Enum.filter(&is_binary/1)
  end
end
