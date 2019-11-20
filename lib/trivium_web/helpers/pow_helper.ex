defmodule TriviumWeb.PowHelper do
  @moduledoc false
  @spec sync_user(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def sync_user(conn, user) do
    config = Pow.Plug.fetch_config(conn)
    plug = Pow.Plug.get_plug(config)

    plug.do_create(conn, user, config)
  end
end
