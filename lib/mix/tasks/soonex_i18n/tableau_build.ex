defmodule Mix.Tasks.SoonexI18n.TableauBuild do
  @shortdoc "Builds the Tableau site with timeout: :infinity and visible progress"

  @moduledoc """
  Same pipeline as `mix tableau.build`, with three differences:

  * `Task.async_stream` for module discovery and page render uses
    `timeout: :infinity` (upstream defaults to 5 seconds, which is fragile on
    cold CI runners that lazy-load Rust NIFs in MDEx and makeup_syntect).
  * Module discovery is restricted to `:soonex_i18n` and `:tableau`. We do not
    need extension hooks from every loaded module to ship the site.
  * The task prints `[soonex_i18n.tableau_build] <step> <ms>` at every phase so
    a hung CI run shows exactly which phase stalled.
  """

  use Mix.Task

  alias Tableau.Graph.Nodable

  require Logger

  @site_apps [:soonex_i18n, :tableau]

  @impl Mix.Task
  def run(argv) do
    log("starting")
    Application.ensure_all_started(:telemetry)
    log("telemetry started")

    {:ok, config} = Tableau.Config.get()
    token = %{site: %{config: config}, graph: Graph.new()}
    log("config loaded out=#{inspect(config.out_dir)}")

    Mix.Task.run("app.start", [])
    log("app.start done")

    {opts, _argv} = OptionParser.parse!(argv, strict: [out: :string])
    out = opts[:out] || config.out_dir

    mods = discover_site_modules()
    log("site modules discovered count=#{length(mods)}")

    {:ok, config} = Tableau.Config.get()
    token = Map.put(token, :extensions, %{})

    token = mods |> extensions_for(:pre_build) |> run_extensions(:pre_build, token)
    log("pre_build extensions complete")

    token = mods |> extensions_for(:pre_render) |> run_extensions(:pre_render, token)
    log("pre_render extensions complete")

    graph = Tableau.Graph.insert(token.graph, mods)
    log("graph built")

    File.mkdir_p!(out)

    pages =
      for page <- Graph.vertices(graph), {:ok, :page} == Nodable.type(page) do
        {page, Map.new(Nodable.opts(page) || [])}
      end

    token = put_in(token.site[:pages], Enum.map(pages, fn {_mod, page} -> page end))
    log("rendering pages count=#{length(pages)}")

    total = length(pages)

    pages =
      pages
      |> Enum.with_index(1)
      |> Enum.map(fn {{mod, page}, idx} ->
        log("rendering #{idx}/#{total} #{describe_page(mod, page)}")

        {us, result} =
          :timer.tc(fn ->
            render_page_with_timeout(graph, mod, token, page, idx, total)
          end)

        log("rendered  #{idx}/#{total} #{describe_page(mod, page)} in #{div(us, 1000)} ms")
        result
      end)

    token = put_in(token.site[:pages], pages)
    token = mods |> extensions_for(:pre_write) |> run_extensions(:pre_write, token)
    log("pre_write extensions complete")

    for %{body: body, permalink: permalink} <- token.site[:pages] do
      file_path = build_file_path(out, permalink)
      File.mkdir_p!(Path.dirname(file_path))
      File.write!(file_path, body)
    end

    log("pages written")

    if File.exists?(config.include_dir) do
      File.cp_r!(config.include_dir, out)
    end

    token = mods |> extensions_for(:post_write) |> run_extensions(:post_write, token)
    log("done")
    token
  end

  @page_render_timeout_ms 90_000

  defp render_page_with_timeout(graph, mod, token, page, idx, total) do
    task =
      Task.async(fn ->
        try do
          content = Tableau.Document.render(graph, mod, token, page)
          permalink = Nodable.permalink(mod)
          {:ok, Map.merge(page, %{body: content, permalink: permalink})}
        rescue
          exception ->
            {:raise, TableauDevServer.BuildException,
             [page: page, exception: exception], __STACKTRACE__}
        end
      end)

    case Task.yield(task, @page_render_timeout_ms) do
      {:ok, {:ok, result}} ->
        result

      {:ok, {:raise, mod_to_raise, args, stacktrace}} ->
        reraise mod_to_raise, args, stacktrace

      {:exit, reason} ->
        raise "page render exited reason=#{inspect(reason)} page=#{describe_page(mod, page)}"

      nil ->
        info =
          Process.info(task.pid, [
            :current_stacktrace,
            :status,
            :message_queue_len,
            :reductions
          ])

        Task.shutdown(task, :brutal_kill)

        raise """
        page render timed out after #{@page_render_timeout_ms} ms.
        page #{idx}/#{total}: #{describe_page(mod, page)}
        process info: #{inspect(info, pretty: true, limit: :infinity, printable_limit: :infinity)}
        """
    end
  end

  defp log(msg) do
    IO.puts(:stderr, "[soonex_i18n.tableau_build] " <> msg)
  end

  defp describe_page(mod, page) do
    case page do
      %{permalink: permalink, file: file} -> "#{permalink} (#{file})"
      %{permalink: permalink} -> to_string(permalink)
      _ -> inspect(mod)
    end
  end

  defp discover_site_modules do
    @site_apps
    |> Enum.flat_map(fn app ->
      case :application.get_key(app, :modules) do
        {:ok, mods} -> mods
        _ -> []
      end
    end)
    |> Enum.uniq()
  end

  @file_extensions [".html"]
  defp build_file_path(out, permalink) do
    if Path.extname(permalink) in @file_extensions do
      Path.join(out, permalink)
    else
      Path.join([out, permalink, "index.html"])
    end
  end

  defp extensions_for(modules, type) do
    extensions =
      for mod <- modules, Code.ensure_loaded?(mod), function_exported?(mod, type, 1) do
        mod
      end

    Enum.sort_by(extensions, & &1.__tableau_extension_priority__())
  end

  defp run_extensions(extensions, type, token) do
    for module <- extensions, reduce: token do
      token ->
        raw_config =
          Map.merge(
            %{enabled: Tableau.Extension.enabled?(module)},
            :tableau |> Application.get_env(module, %{}) |> Map.new()
          )

        if raw_config[:enabled] do
          {:ok, config} = validate_config(module, raw_config)
          {:ok, key} = Tableau.Extension.key(module)
          token = put_in(token.extensions[key], %{config: config})

          case apply(module, type, [token]) do
            {:ok, token} ->
              token

            :error ->
              Logger.error("#{inspect(module)} failed to run")
              token
          end
        else
          token
        end
    end
  end

  defp validate_config(module, raw_config) do
    if function_exported?(module, :config, 1) do
      module.config(raw_config)
    else
      {:ok, raw_config}
    end
  end
end
