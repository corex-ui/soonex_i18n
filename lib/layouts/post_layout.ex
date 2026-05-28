defmodule SoonexI18n.PostLayout do
  @moduledoc false

  use Tableau.Layout, layout: SoonexI18n.RootLayout
  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  def template(assigns) do
    page = assigns.page
    title = page[:title] || ~t"Post"
    description = page[:description]
    date = page[:date]

    date_label =
      case date do
        %DateTime{} -> Calendar.strftime(date, "%Y-%m-%d")
        _ -> nil
      end

    tags =
      page
      |> Map.get(:tags, [])
      |> List.wrap()
      |> Enum.filter(&is_binary/1)

    assigns =
      assigns
      |> Map.put(:post_title, title)
      |> Map.put(:post_description, description)
      |> Map.put(:post_date_label, date_label)
      |> Map.put(:post_tags, tags)

    ~H"""
    <article class="blog blog--post">
      <header class="blog__post-hero" aria-labelledby="post-heading">
        <div class="blog__inner blog__post-hero__inner">
          <div class="blog__post-toolbar">
            <.navigate to={~p"/"} class="blog__back link link--accent">
              <.heroicon name="hero-arrow-left" class="blog__back__icon" />
              {~t"Back to home"}
            </.navigate>
          </div>
          <div class="blog__post-head">
            <div :if={@post_date_label} class="blog__post-meta">
              <p class="blog__eyebrow">{@post_date_label}</p>
            </div>
            <h1 id="post-heading" class="blog__display">{@post_title}</h1>
            <p :if={@post_description} class="blog__lede blog__lede--post">{@post_description}</p>
            <ul
              :if={@post_tags != []}
              class="blog__post-tags m-0 flex list-none flex-wrap gap-space-sm p-0"
            >
              <li :for={tag <- @post_tags}>
                <span class="badge badge--muted badge--sm">{tag}</span>
              </li>
            </ul>
          </div>
        </div>
      </header>
      <section class="blog__post-body" aria-label={~t"Article"}>
        <div class="blog__inner">
          <div class="blog__article-shell typo markdown prose max-w-none">
            {{:safe, render(@inner_content)}}
          </div>
        </div>
      </section>
    </article>
    """
  end
end
