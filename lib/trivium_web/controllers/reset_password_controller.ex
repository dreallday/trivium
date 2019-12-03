defmodule TriviumWeb.ResetPasswordController do
  use TriviumWeb, :controller

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    case PowResetPassword.Plug.user_from_token(conn, id) do
      nil ->
        conn
        |> put_flash(:error, "invalid token")
        |> redirect(to: Routes.reset_password_path(conn, :new))
        |> halt()

      user ->
        changeset =
          PowResetPassword.Plug.change_user(conn)
          |> IO.inspect(label: "change_user changeset")

        user |> IO.inspect(label: "user email")

        conn
        |> PowResetPassword.Plug.assign_reset_password_user(user)
        |> render("edit.html", changeset: changeset, id: id)
    end
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> PowResetPassword.Plug.create_reset_token(user_params)
    |> case do
      {:ok, %{token: token, user: _user}, conn} ->
        # Send e-mail
        token |> IO.inspect(label: "reset token")

        conn
        |> put_flash(:info, 'Check your email to reset password')
        |> redirect(to: Routes.reset_password_path(conn, :new))

      {:error, _changeset, conn} ->
        conn
        |> put_flash(:info, 'Check your email to reset password')
        |> redirect(to: Routes.reset_password_path(conn, :new))
    end
  end

  def update(conn, %{"user" => user_params}) do
    conn.assigns |> IO.inspect(label: "user params from update")
    PowResetPassword.Plug.update_user_password(conn, user_params) |> IO.inspect(label: "fuck you")
    # # {:ok, conn} = Pow.Plug.clear_authenticated_user(conn)
    redirect(conn, to: Routes.login_path(conn, :new))
  end
end
