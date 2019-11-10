defmodule TriviumWeb.DashboardController do
  use TriviumWeb, :controller
  # alias Phoenix.LiveView
  # alias TriviumWeb.DashboardLive.Index

  alias Trivium.Private
  alias Trivium.Billing


  def index(conn, _params) do

    user = Pow.Plug.current_user(conn)
    tokens = Private.list_tokens(conn)
    plan = Billing.get_plan(user.current_plan)
    # payment = Dashboard.get_user_payment(conn)

    # Other = crap.list
    render(conn, "index.html", user: user, tokens: tokens, plan: plan)
    # LiveView.Controller.live_render(conn, Index, ser: user, tokens: tokens, plan: plan)
  end
end
