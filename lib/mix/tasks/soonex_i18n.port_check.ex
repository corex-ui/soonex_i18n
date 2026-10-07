defmodule Mix.Tasks.SoonexI18n.PortCheck do
  @shortdoc "Fail fast when Tableau (4999) or Corex MCP (4004) ports are taken"

  @moduledoc """
  Tableau logs “server started on http://localhost:4999/” *before* Bandit binds.
  If something else already holds 4999 (another `mix tableau.server`, Wallaby,
  or `python -m http.server 4999`), you get `:eaddrinuse` a moment later.

  Corex MCP uses 4004 in `MIX_ENV=dev`.
  """

  use Mix.Task

  @site_port 4999
  @mcp_port 4004

  @impl Mix.Task
  def run(_args) do
    check!(@site_port, "Tableau dev server")
    check!(@mcp_port, "Corex MCP")
  end

  defp check!(port, label) do
    if listening?(port) do
      Mix.raise("""
      #{label} port #{port} is already in use.

      Tableau prints “server started” before it binds, so that log does not
      mean the port is free. Stop the other process, then retry:

          #{kill_hint(port)}

      Occupant:
      #{occupant(port)}
      """)
    end
  end

  defp listening?(port) do
    Enum.any?(
      [{127, 0, 0, 1}, {0, 0, 0, 0, 0, 0, 0, 1}],
      &connects?(&1, port)
    )
  end

  defp connects?(ip, port) do
    opts = [:binary, active: false, packet: :raw]

    case :gen_tcp.connect(ip, port, opts, 250) do
      {:ok, socket} ->
        :gen_tcp.close(socket)
        true

      {:error, _} ->
        false
    end
  end

  defp occupant(port) do
    cond do
      bin = System.find_executable("ss") ->
        cmd_out(bin, ["-ltnp", "sport = :#{port}"])

      bin = System.find_executable("lsof") ->
        cmd_out(bin, ["-nP", "-iTCP:#{port}", "-sTCP:LISTEN"])

      true ->
        "ss/lsof not found; try: lsof -nP -iTCP:#{port} -sTCP:LISTEN"
    end
  end

  defp cmd_out(bin, args) do
    case System.cmd(bin, args, stderr_to_stdout: true) do
      {out, _} ->
        out = String.trim(out)
        if out == "", do: "(no ss/lsof rows)", else: out
    end
  end

  defp kill_hint(port) do
    cond do
      System.find_executable("ss") ->
        "ss -ltnp 'sport = :#{port}'   # then: kill <pid>"

      System.find_executable("lsof") ->
        "kill $(lsof -t -iTCP:#{port} -sTCP:LISTEN)"

      true ->
        "lsof -nP -iTCP:#{port} -sTCP:LISTEN   # then: kill <pid>"
    end
  end
end
