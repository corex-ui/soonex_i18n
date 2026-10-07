defmodule SoonexI18n.HomePage.Journal do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  import SoonexI18n.Layouts.Section, only: [block: 1]

  alias SoonexI18n.Layouts.Shell

  attr(:posts, :list, default: [])

  def journal(assigns) do
    posts =
      assigns.posts
      |> List.wrap()
      |> Enum.sort_by(& &1[:date], {:desc, DateTime})
      |> Enum.take(3)

    assigns = assign(assigns, :highlight_posts, posts)

    ~H"""
    <.block
      id="journal"
      section="journal"
      labelledby="soonex-journal-heading"
      eyebrow={~t"Journal"}
      tone={:surface}
      heading_size={:large}
    >
      <:title>
        {~t"Notes from the build."}
      </:title>
      <:lede>
        {~t"Short dispatches on design tokens, accessibility, and shipping static sites with Phoenix tooling."}
      </:lede>
      <:actions>
        <.navigate to={~p"/blog"} class="link ui-accent">
          {~t"Read the journal"} <.heroicon name="hero-arrow-up-right" />
        </.navigate>
      </:actions>
      <div :if={@highlight_posts == []} class={"#{Shell.panel()} text-ink-muted"}>
        <p class="m-0 text-sm/6">{~t"No posts yet."}</p>
      </div>
      <div
        :if={@highlight_posts != []}
        class="grid grid-cols-1 gap-6 md:grid-cols-3"
      >
        <article
          :for={post <- @highlight_posts}
          class={"#{Shell.tile()} soonex-card-motion relative h-full bg-root"}
        >
          <div :if={post[:image]} class="relative aspect-[16/10] overflow-hidden">
            <img
              src={SoonexI18n.Public.path(post[:image])}
              alt=""
              width="1600"
              height="1000"
              loading="lazy"
              decoding="async"
              class="absolute inset-0 size-full object-cover"
            />
          </div>
          <div class="flex flex-1 flex-col p-6 sm:p-8">
            <p :if={date_label(post)} class={Shell.eyebrow()}>{date_label(post)}</p>
            <h3 class="display mt-3 text-xl font-medium tracking-tight text-ink">
              <.navigate
                to={SoonexI18n.Public.path(post.permalink)}
                class="after:absolute after:inset-0"
              >
                {post[:title] || ~t"Untitled"}
              </.navigate>
            </h3>
            <p :if={post[:description]} class="mt-3 flex-auto text-sm/6 text-ink-muted">
              {post[:description]}
            </p>
            <p class="mt-6 flex items-center gap-1 text-sm/6 font-medium text-ink" aria-hidden="true">
              {~t"Read post"} <.heroicon name="hero-arrow-up-right" class="size-4 rtl:-scale-x-100" />
            </p>
          </div>
        </article>
      </div>
    </.block>
    """
  end

  defp date_label(%{date: %DateTime{} = date}), do: SoonexI18n.Locale.format_date(date)
  defp date_label(_), do: nil
end
