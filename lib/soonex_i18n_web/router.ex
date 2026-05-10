defmodule SoonexI18nWeb.Router do
  @moduledoc false

  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", SoonexI18nWeb do
    pipe_through(:browser)

    get("/", PageController, :page)
    get("/docs", PageController, :page)
  end

  scope "/:locale", SoonexI18nWeb do
    pipe_through(:browser)

    get("/", PageController, :page)
    get("/docs", PageController, :page)
  end
end
