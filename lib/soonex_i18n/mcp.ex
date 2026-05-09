defmodule SoonexI18n.Mcp do
  @moduledoc false

  use Plug.Builder

  plug(Corex.MCP)

  plug(:not_found)

  defp not_found(conn, _) do
    if conn.halted? do
      conn
    else
      conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(404, "Not found")
    end
  end
end
