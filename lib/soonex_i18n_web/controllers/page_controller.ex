defmodule SoonexI18nWeb.PageController do
  @moduledoc false

  use Phoenix.Controller, formats: [:html]

  def page(conn, _params), do: send_resp(conn, 200, "")
end
