defmodule SoonexI18n.Markdown.BlockRenderer do
  @moduledoc false

  use Gettext, backend: SoonexI18n.Gettext

  alias Phoenix.HTML

  def render_fence_html(code, language, clipboard_id) do
    ensure_makeup_apps()
    highlighted = highlight_to_string(code, language)
    label = gettext("Copy code") |> html_body()
    tid = "#{clipboard_id}-src"
    tid_attr = tid |> HTML.html_escape() |> HTML.safe_to_string()
    textarea_body = code |> HTML.html_escape() |> HTML.safe_to_string()

    ~s"""
    <div class="relative">
      <pre class="code max-w-none" data-scope="code" data-part="root" tabindex="0">
        <code data-scope="code" data-part="content">#{highlighted}</code>
      </pre>
      <textarea id="#{tid_attr}" readonly tabindex="-1" aria-hidden="true" style="position:absolute;left:-9999px;width:1px;height:1px;opacity:0">#{textarea_body}</textarea>
      <button type="button" class="clipboard clipboard--sm absolute top-2 right-2 z-10" aria-label="#{html_attr(label)}" onclick="(function(){var t=document.getElementById('#{tid_attr}');if(t){t.select();void navigator.clipboard.writeText(t.value);}})()">#{label}</button>
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

  defp html_body(s), do: s |> HTML.html_escape() |> HTML.safe_to_string()

  defp html_attr(s), do: s |> HTML.html_escape() |> HTML.safe_to_string()

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
