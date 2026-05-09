defmodule SoonexI18n.MDExConverter do
  @moduledoc false

  alias SoonexI18n.Markdown.CodeBlocks

  def convert(_filepath, _front_matter, body, %{site: %{config: config}}) do
    html = MDEx.to_html!(body, config.markdown[:mdex])
    CodeBlocks.transform(html)
  end
end
