defmodule TriviumWeb.PageController do
  use TriviumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "pindex.html")
  end
end
