defmodule SoonexI18n.Markdown.BlockRenderer do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use SoonexI18n.GettextSigil

  attr(:code, :string, required: true)
  attr(:language, :atom, required: true)
  attr(:clipboard_id, :string, required: true)

  def fence(assigns) do
    ~H"""
    <div class="relative">
      <.code class="code max-w-none" language={@language} code={@code} />
      <.clipboard
        id={@clipboard_id}
        class="clipboard ui-size-sm absolute top-2 end-2 z-10"
        value={@code}
        input={false}
        trigger_aria_label={~t"Copy code"}
      >
        <:copy>
          <.heroicon name="hero-clipboard" />
        </:copy>
        <:copied>
          <.heroicon name="hero-check" />
        </:copied>
      </.clipboard>
    </div>
    """
  end

  attr(:code, :string, required: true)
  attr(:language, :atom, required: true)

  def inline(assigns) do
    ~H"""
    <.code class="code" inline language={@language} code={@code} />
    """
  end

  def render_fence_html(code, language, clipboard_id) do
    ensure_makeup_apps()

    %{__changed__: %{}, code: code, language: language, clipboard_id: clipboard_id}
    |> fence()
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
  end

  def render_inline_html(code, language) do
    ensure_makeup_apps()

    %{__changed__: %{}, code: code, language: language}
    |> inline()
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
  end

  defp ensure_makeup_apps do
    Enum.each(
      [
        :makeup_elixir,
        :makeup_eex,
        :makeup_html,
        :makeup_css,
        :makeup_js,
        :makeup_syntect
      ],
      &Application.ensure_all_started/1
    )
  end
end
