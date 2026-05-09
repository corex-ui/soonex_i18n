defmodule Mix.Tasks.SoonexI18n.MdexWarmup do
  @moduledoc false

  use Mix.Task

  @shortdoc false

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.config")
    Application.ensure_all_started(:telemetry)
    {:ok, _} = Application.ensure_all_started(:mdex)
    {:ok, config} = Tableau.Config.get()
    _ = MDEx.to_html!("#", config.markdown[:mdex])
    :ok
  end
end
