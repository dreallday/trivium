defmodule TriviumWeb.Pow.Plug.Token do
  @moduledoc false
  use Pow.Plug.Base

  alias Trivium.Users.User
  @session_key :pow_user_token
  @salt "j1-f9zmakd"
  @max_age 86400

  def fetch(conn, config) do
    conn = Plug.Conn.fetch_session(conn)
    token = Plug.Conn.get_session(conn, @session_key)

    TriviumWeb.Endpoint
    |> Phoenix.Token.verify(@salt, token, max_age: @max_age)
    |> maybe_load_user(conn)
  end

  defp maybe_load_user({:ok, user_id}, conn), do: {conn, Trivium.Repo.get(User, user_id)}
  defp maybe_load_user({:error, _any}, conn), do: {conn, nil}

  def create(conn, user, config) do
    token = Phoenix.Token.sign(TriviumWeb.Endpoint, @salt, user.id)

    conn =
      conn
      |> Plug.Conn.fetch_session()
      |> Plug.Conn.put_session(@session_key, token)

    {conn, user}
  end

  def delete(conn, config) do
    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.delete_session(@session_key)
  end
end
