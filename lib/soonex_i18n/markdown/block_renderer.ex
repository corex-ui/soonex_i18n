defmodule SoonexI18n.Markdown.BlockRenderer do
  @moduledoc false

  use Phoenix.Component
  use Corex
  use Gettext, backend: SoonexI18n.Gettext

  alias Phoenix.HTML

  def render_fence_html(code, language, clipboard_id) do
    ensure_makeup_apps()
    highlighted = highlight_to_string(code, language)

    assigns =
      %{__changed__: %{}}
      |> assign(:clipboard_id, clipboard_id)
      |> assign(:raw_code, code)
      |> assign(:highlighted, HTML.raw(highlighted))
      |> assign(:aria_label, gettext("Copy code"))

    fence_block(assigns)
    |> HTML.html_escape()
    |> HTML.safe_to_string()
  end

  defp fence_block(assigns) do
    ~H"""
    <div class="relative">
      <pre class="code max-w-none" data-scope="code" data-part="root" tabindex="0">
        <code data-scope="code" data-part="content">{@highlighted}</code>
      </pre>
      <.clipboard
        id={@clipboard_id}
        value={@raw_code}
        class={["clipboard", "clipboard--sm", "absolute", "top-2", "right-2", "z-10"]}
        input={false}
        trigger_aria_label={@aria_label}
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

  def render_inline_html(code, language) do
    ensure_makeup_apps()
    highlighted = highlight_to_string(code, language)

    ~s"""
    <code class="code" data-scope="code" data-part="root"><span data-scope="code" data-part="content">#{highlighted}</span></code>
    """
  end

  defp highlight_to_string(code, language) do
    name = to_string(language)
    registry = Module.concat(["Elixir", "Makeup", "Registry"])
    makeup = Module.concat(["Elixir", "Makeup"])

    case registry.fetch_lexer_by_name(name) do
      {:ok, _} ->
        makeup.highlight_inner_html(code, lexer: name)

      :error ->
        code |> HTML.html_escape() |> HTML.safe_to_string()
    end
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
