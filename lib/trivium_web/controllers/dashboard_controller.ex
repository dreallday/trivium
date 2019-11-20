defmodule TriviumWeb.DashboardController do
  @moduledoc false
  use TriviumWeb, :controller
  # alias Phoenix.LiveView
  # alias TriviumWeb.DashboardLive.Index

  alias Trivium.Private
  alias Trivium.Billing

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    # |> IO.inspect(label: "Current User")
    tokens = Private.list_tokens(conn)
    plan = Billing.get_plan(user.current_plan)

    payment =
      Billing.get_payment!(user.cus_id, user.payment_id)
      |> IO.inspect(label: "Billing.get_payment")

    # Other = crap.list
    render(conn, "index.html", user: user, tokens: tokens, plan: plan, payment: payment)
    # LiveView.Controller.live_render(conn, Index, ser: user, tokens: tokens, plan: plan)
  end
end
