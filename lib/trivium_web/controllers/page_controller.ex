defmodule TriviumWeb.PageController do
  use TriviumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
