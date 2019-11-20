defmodule TriviumWeb.PageController do
  @moduledoc false
  use TriviumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "pindex.html")
  end
end
