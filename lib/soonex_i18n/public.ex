defmodule SoonexI18n.Public do
  @moduledoc false

  def path(path) when is_binary(path) do
    SoonexI18nWeb.Endpoint.path(path)
  end
end
