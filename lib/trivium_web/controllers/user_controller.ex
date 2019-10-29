defmodule TriviumWeb.UserController do
  use TriviumWeb, :controller

  alias Trivium.Accounts
  alias Trivium.Accounts.LandingUser

  action_fallback TriviumWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %LandingUser{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      # |> render("show.json", user: user)
      |> send_resp(200, "ok")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %LandingUser{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %LandingUser{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
