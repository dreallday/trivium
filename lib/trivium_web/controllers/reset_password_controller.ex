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
        changeset = PowResetPassword.Plug.change_user(conn)

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
      {:ok, %{token: token, user: user}, conn} ->
        # Send e-mail
        token |> IO.inspect(label: "reset token")

        # Trivium.PowMailer.cast(%{
        #   user: user,
        #   subject: "Password Reset",
        #   text: "https://trivium.gg/forgot/#{token}",
        #   html: "<a href='https://trivium.gg/forgot/#{token}'>Reset Password</a>"
        # })
        Trivium.PowMailer.password_reset(%{
          user: user,
          reset_token: token
        })
        |> Trivium.PowMailer.process()

        conn
        |> put_flash(:info, 'Check your email to reset password')
        |> redirect(to: Routes.reset_password_path(conn, :new))

      {:error, _changeset, conn} ->
        conn
        |> put_flash(:info, 'Check your email to reset password!')
        |> redirect(to: Routes.reset_password_path(conn, :new))
    end
  end

  def update(conn, %{"user" => user_params} = params) do
    params |> IO.inspect(label: "params from update")

    case PowResetPassword.Plug.user_from_token(conn, params["id"]) do
      nil ->
        conn
        |> put_flash(:error, "invalid token")
        |> redirect(to: Routes.reset_password_path(conn, :new))
        |> halt()

      user ->
        conn
        |> PowResetPassword.Plug.assign_reset_password_user(user)
        |> PowResetPassword.Plug.update_user_password(user_params)
        |> case do
          {:ok, _user, conn} ->
            redirect(conn, to: Routes.login_path(conn, :new))

          {:error, _changeset, conn} ->
            conn
            |> put_flash(:error, "Try Again")
            |> redirect(to: Routes.reset_password_path(conn, :new))
        end
    end
  end
end
