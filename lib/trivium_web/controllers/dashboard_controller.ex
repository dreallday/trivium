defmodule TriviumWeb.DashboardController do
  use TriviumWeb, :controller

  alias Trivium.Private

  def index(conn, _params) do
    conn |> IO.inspect(label: "Index: Conn")
    # Private.list_tokens(conn)

    dashboard = %{
      "sup" => "dawg"
    }

    render(conn, "index.html", dashboard: dashboard)
  end
end
