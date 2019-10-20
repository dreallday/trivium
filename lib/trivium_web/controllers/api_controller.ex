defmodule TriviumWeb.ApiController do
  use TriviumWeb, :controller

  def test(conn, _params) do
    send_resp(conn, 200, Ecto.UUID.generate())
  end
end
