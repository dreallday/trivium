defmodule TriviumWeb.DocsController do
  use TriviumWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> render("doc/index.html")
  end
end
