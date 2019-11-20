defmodule TriviumWeb.PlanView do
  @moduledoc false
  use TriviumWeb, :view

  def set_plan(conn, plan) do
    user = Pow.Plug.current_user(conn)

    %{
      current_plan: plan.id
    }
  end
end
