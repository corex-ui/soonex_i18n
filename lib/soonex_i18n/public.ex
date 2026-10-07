defmodule SoonexI18n.Public do
  @moduledoc false

  def path(path) when is_binary(path) do
    SoonexI18nWeb.Endpoint.path(path)
  end

  def asset(path) when is_binary(path) do
    case Application.get_env(:soonex_i18n, :asset_version) do
      version when is_binary(version) and version != "" -> path(path) <> "?v=" <> version
      _ -> path(path)
    end
  end
end
