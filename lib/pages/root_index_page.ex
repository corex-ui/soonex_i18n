defmodule SoonexI18n.RootIndexPage do
  @moduledoc false

  use Tableau.Page,
    layout: SoonexI18n.RootLayout,
    permalink: "/",
    title: "SoonexI18n",
    page_kind: :home

  use Phoenix.Component

  def template(assigns), do: SoonexI18n.HomePage.template(assigns)
end
