defmodule TriviumWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias TriviumWeb.Router.Helpers, as: Routes

  def after_sign_in_path(conn), do: Routes.dashboard_path(conn, :index)
end
