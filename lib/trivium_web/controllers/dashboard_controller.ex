defmodule TriviumWeb.DashboardController do
  use TriviumWeb, :controller

  alias Trivium.Private

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    tokens = Private.list_tokens(conn)
    # payment = Dashboard.get_user_payment(conn)

    # Other = crap.list
    render(conn, "index.html", user: user, tokens: tokens)
  end
end
