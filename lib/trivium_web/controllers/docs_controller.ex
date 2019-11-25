defmodule TriviumWeb.DocsController do
  @moduledoc false
  use TriviumWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, Application.app_dir(:trivium, "docs/index.html"))
  end
end
