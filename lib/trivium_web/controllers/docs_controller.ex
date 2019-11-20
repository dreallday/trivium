defmodule TriviumWeb.DocsController do
  @moduledoc false
  use TriviumWeb, :controller

  plug :action

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, "priv/static/doc/index.html")

    # conn
    # |> put_layout(false)
    # |> render("doc/index.html")
  end
end
