defmodule SoonexI18n.HomePage.Highlights do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  attr(:posts, :list, default: [])

  def highlights(assigns) do
    locale = Gettext.get_locale(SoonexI18n.Gettext)
    locale_prefix = "/#{locale}/"

    posts =
      assigns.posts
      |> List.wrap()
      |> Enum.filter(fn post ->
        permalink = post[:permalink] || post["permalink"] || ""
        String.starts_with?(permalink, locale_prefix)
      end)
      |> Enum.sort_by(& &1[:date], {:desc, DateTime})
      |> Enum.take(3)

    assigns =
      assigns
      |> assign(:tech, tech_items())
      |> assign(:highlight_posts, posts)

    ~H"""
    <section
      id="highlights"
      class={"#{Shell.section()} border-y border-border bg-root"}
      aria-labelledby="soonex_i18n-highlights-heading"
    >
      <div class={"#{Shell.stage()} home-stack flex flex-col"}>
        <div class="mx-auto flex w-full max-w-2xl flex-col items-center gap-size-md text-center lg:mx-0 lg:items-start lg:text-start">
          <h2 id="soonex_i18n-highlights-heading" class={Shell.section_heading()}>
            {~t"Lorem ipsum"} <span class="text-brand-text">{~t"dolor sit"}</span>
          </h2>
          <p class={Shell.lede()}>
            {~t"Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
          </p>
        </div>

        <div class="home-highlights-marquee flex flex-col gap-size-sm py-size-sm">
          <.marquee
            id="soonex_i18n-tech-marquee"
            class="marquee ui-accent ui-width-full max-w-none"
            duration={32}
            spacing="3.5rem"
            pause_on_interaction={true}
            items={@tech}
          >
            <:item :let={item}>
              <span class="inline-flex h-11 items-center justify-center px-space-sm" title={item.name}>
                <img
                  src={SoonexI18n.Public.path(item.src)}
                  alt={item.name}
                  height="44"
                  class="pointer-events-none h-11 w-auto object-contain"
                  loading="lazy"
                />
              </span>
            </:item>
          </.marquee>
        </div>

        <ul :if={@highlight_posts != []} class="blog__grid m-0 list-none p-0">
          <li :for={post <- @highlight_posts}>
            <.navigate to={SoonexI18n.Public.path(post.permalink)} class={"#{Shell.card()}"}>
              <div class="blog__card__top">
                <p :if={post_date_label(post)} class="blog__card__date">{post_date_label(post)}</p>
                <span :if={is_nil(post_date_label(post))}></span>
                <.heroicon name="hero-arrow-right" class="blog__card__arrow" />
              </div>
              <h3 class="blog__card__title">{post[:title] || ~t"Untitled"}</h3>
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

        <ul :if={@highlight_posts == []} class="blog__grid m-0 list-none p-0">
          <li>
            <.navigate to={~p"/blog"} class={"#{Shell.card()}"}>
              <div class="blog__card__top">
                <p class="blog__card__date">{~t"Journal"}</p>
                <.heroicon name="hero-arrow-right" class="blog__card__arrow" />
              </div>
              <h3 class="blog__card__title">{~t"Ipsum dolor sit amet consectetur adipiscing"}</h3>
              <p class="blog__card__excerpt">
                {~t"Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
              </p>
            </.navigate>
          </li>
        </ul>
      </div>
    </section>
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

  defp tech_items do
    [
      %{name: "Elixir", src: "/images/tech/elixir.svg"},
      %{name: "Phoenix", src: "/images/tech/phoenix.svg"},
      %{name: "Tableau", src: "/images/tech/tableau.jpg"},
      %{name: "Tailwind", src: "/images/tech/tailwind.svg"},
      %{name: "Hex", src: "/images/tech/hex.svg"},
      %{name: "TypeScript", src: "/images/tech/typescript.svg"},
      %{name: "Zag.js", src: "/images/tech/zag.webp"},
      %{name: "Ecto", src: "/images/tech/ecto.png"}
    ]
  end
end
