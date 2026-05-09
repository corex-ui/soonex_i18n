defmodule Mix.Tasks.SoonexI18nI18n.Palette do
  @moduledoc false

  use Mix.Task

  alias SoonexI18n.Palette
  alias SoonexI18n.Palette.Config

  @shortdoc "Generate theme color JSON from SoonexI18n.Palette.Config"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")
    root = File.cwd!()
    design = Path.join(root, "assets/corex/design")
    cfg = Config.defaults()

    File.write!(
      Path.join(design, "palette_config.json"),
      Jason.encode!(cfg, pretty: true) <> "\n"
    )

    Palette.run(design_dir: design, config: cfg)
  end
end
