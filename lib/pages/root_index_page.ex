defmodule SoonexI18n.RootIndexPage do
  @moduledoc false

  use Tableau.Page,
    layout: SoonexI18n.RootLayout,
    permalink: "/",
    title: "Soonex",
    page_kind: :home,
    sitemap: %{priority: 1.0, changefreq: "weekly"}

  use Phoenix.Component

  def template(assigns), do: SoonexI18n.HomePage.template(assigns)
end
