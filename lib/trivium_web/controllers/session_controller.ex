defmodule TriviumWeb.SessionController do
  use TriviumWeb, :controller

  def new(conn, _params) do
    changeset =
      Pow.Plug.change_user(conn)
      |> IO.inspect(label: "login changeset")

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> verify_confirmed()

    # |> case do
    #   {:ok, conn} ->
    #     conn
    #     |> put_flash(:info, "Welcome back!")
    #     |> redirect(to: Routes.dashboard_path(conn, :index))

    #   {:error, conn} ->
    #     changeset = Pow.Plug.change_user(conn, conn.params["user"])

    #     conn
    #     |> put_flash(:info, "Invalid email or password")
    #     |> render("new.html", changeset: changeset)
    # end
  end

  def delete(conn, _params) do
    {:ok, conn} = Pow.Plug.clear_authenticated_user(conn)

    redirect(conn, to: Routes.dashboard_path(conn, :index))
  end

  defp verify_confirmed({:ok, conn}) do
    conn
    |> Pow.Plug.current_user()
    |> email_confirmed?()
    |> case do
      true ->
        conn
        # |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      false ->
        conn
        |> Pow.Plug.clear_authenticated_user()
        # |> put_flash(:info, "Your e-mail address has not been confirmed.")
        |> redirect(to: Routes.login_path(conn, :new))
    end
  end

  defp verify_confirmed({:error, conn}) do
    changeset = Pow.Plug.change_user(conn, conn.params["user"])

    conn
    |> put_flash(:info, "Invalid email or password")
    |> render("new.html", changeset: changeset)
  end

  defp email_confirmed?(%{
         email_confirmed_at: nil,
         email_confirmation_token: token,
         unconfirmed_email: nil
       })
       when not is_nil(token),
       do: false

  defp email_confirmed?(_user), do: true
end
