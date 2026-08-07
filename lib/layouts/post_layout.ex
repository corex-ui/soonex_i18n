defmodule SoonexI18n.PostLayout do
  @moduledoc false

  use Tableau.Layout, layout: SoonexI18n.RootLayout
  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil
  use SoonexI18n.Routes

  alias SoonexI18n.Layouts.Shell

  def template(assigns) do
    page = assigns.page
    title = page[:title] || Gettext.gettext(SoonexI18n.Gettext, "Post")
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
    <article class={"#{Shell.stage()} flex min-h-dvh flex-col gap-space-xl pt-size-xl pb-size-xl"}>
      <nav class="blog__nav" aria-label={~t"Post"}>
        <.navigate to={~p"/blog"} class="link ui-nav w-fit">
          <.heroicon name="hero-arrow-left" /> {~t"Back to blog"}
        </.navigate>
      </nav>

      <header class="blog__hero blog__hero--post" aria-labelledby="post-heading">
        <div class="blog__head">
          <p :if={@post_date_label} class="blog__eyebrow">{@post_date_label}</p>
          <h1 id="post-heading" class="blog__display">{@post_title}</h1>
          <p :if={@post_description} class="blog__lede">{@post_description}</p>
          <div class="blog__meta">
            <ul
              :if={@post_tags != []}
              class="m-0 flex list-none flex-wrap gap-space-sm p-0"
            >
              <li :for={tag <- @post_tags}>
                <span class="badge ui-size-sm">{tag}</span>
              </li>
            </ul>
          </div>
        </div>
      </header>

      <div class="typo markdown prose max-w-none">
        {{:safe, render(@inner_content)}}
      </div>
    </article>
    """
  end
end
