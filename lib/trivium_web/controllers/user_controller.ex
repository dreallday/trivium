defmodule TriviumWeb.UserController do
  use TriviumWeb, :controller

  # plug :reload_user

  alias Trivium.Accounts
  alias Trivium.Users.User

  action_fallback TriviumWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     # |> put_resp_header("location", Routes.user_path(conn, :show, user))
  #     # |> render("show.json", user: user)
  #     |> send_resp(200, "ok")
  #   end
  # end

  def show(conn, _) do
    user = Pow.Plug.current_user(conn)
    changeset = Accounts.change_user(user)
    render(conn, "show.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    # user = Accounts.get_user!(id)
    user_params |> IO.inspect(label: "on user update")
    user = Pow.Plug.current_user(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      # render(conn, "show.json", user: user)
      conn
      |> put_flash(:info, "Updated Successfully")
      |> sync_user(user)
      |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end
  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  # defp reload_user(conn, _opts) do
  #   config = Pow.Plug.fetch_config(conn)
  #   user = Pow.Plug.current_user(conn, config)
  #   reloaded_user = Accounts.get_user!(user.id)
  #   # MyApp.Repo.get!(MyApp.User, user.id)

  #   Pow.Plug.assign_current_user(conn, reloaded_user, config)
  # end
end
