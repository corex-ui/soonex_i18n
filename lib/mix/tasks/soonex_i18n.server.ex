defmodule Mix.Tasks.SoonexI18n.Server do
  @shortdoc "Check ports 4999/4004, then start mix tableau.server"

  @moduledoc """
  Wrapper around `mix tableau.server` that fails with a process listing when
  Tableau’s site port (4999) or Corex MCP (4004) is already bound.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("soonex_i18n.port_check", [])
    warn_missing_inotify!()
    Mix.Task.run("tableau.server", args)
  end

  defp warn_missing_inotify! do
    if :os.type() == {:unix, :linux} and is_nil(System.find_executable("inotifywait")) do
      Mix.raise("""
      inotify-tools is required for Tableau live reload on Linux.

      Without `inotifywait`, the dev server starts but live-reload websockets crash with:

          GenServer.call(:web_dev_utils_file_watcher, :subscribe, 5000)

      Install it, then retry:

          sudo apt-get install -y inotify-tools
      """)
    end
  end
end
