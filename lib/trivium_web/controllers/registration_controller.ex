defmodule TriviumWeb.RegistrationController do
  @moduledoc false
  use TriviumWeb, :controller

  alias Trivium.Billing
  # alias Trivium.Billing.Plan
  # alias Trivium.Repo

  def new(conn, _params) do
    # We'll leverage [`Pow.Plug`](Pow.Plug.html), but you can also follow the classic Phoenix way:
    # changeset = MyApp.Users.User.changeset(%MyApp.Users.User{}, %{})

    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # We'll leverage [`Pow.Plug`](Pow.Plug.html), but you can also follow the classic Phoenix way:
    # user =
    #   %MyApp.Users.User{}
    #   |> MyApp.Users.User.changeset(user_params)
    #   |> MyApp.Repo.insert()
    trial_plan = Billing.get_default_plan()
    # Repo.get_by(Plan, is_trial: true)
    user_params = user_params |> Map.put("current_plan", trial_plan.id)

    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        PowEmailConfirmation.Plug.email_unconfirmed?(conn)
        |> IO.inspect(label: "email_unconfirmed?")

        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, changeset, conn} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
