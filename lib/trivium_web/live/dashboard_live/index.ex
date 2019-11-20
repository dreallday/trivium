defmodule TriviumWeb.DashboardLive.Index do
  @moduledoc false
  use Phoenix.LiveView
  alias Trivium.Private
  alias Trivium.Billing

  def mount(_session, socket) do
    user = Pow.Plug.current_user(socket)
    tokens = Private.list_tokens(socket)
    plan = Billing.get_plan(user.current_plan)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    Greetings from Live View
    """
  end
end
