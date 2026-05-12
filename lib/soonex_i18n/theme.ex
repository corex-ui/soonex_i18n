defmodule SoonexI18n.Theme do
  @moduledoc false

  @themes ~w(neo uno duo leo)
  @default_theme "neo"

  def themes, do: @themes

  def default_theme, do: @default_theme

  def head_script do
    themes_json = Jason.encode!(themes())
    default_theme_json = Jason.encode!(default_theme())

    Phoenix.HTML.raw("""
    <script>
      try {
        const themes = #{themes_json};
        const dt = #{default_theme_json};
        const t = localStorage.getItem("data-theme");
        const theme = themes.includes(t) ? t : dt;
        document.documentElement.setAttribute("data-theme", theme);
      } catch (_) {}
    </script>
    """)
  end

  def current(assigns) do
    list = themes()
    d = default_theme()

    case Map.get(assigns, :theme) do
      t when is_binary(t) ->
        if(t in list, do: t, else: d)

      _ ->
        d
    end
  end

  def select_items do
    themes()
    |> Enum.map(fn t -> %{value: t, label: String.capitalize(t)} end)
    |> Corex.List.new()
  end
end
