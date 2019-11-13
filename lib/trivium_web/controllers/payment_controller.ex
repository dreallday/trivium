defmodule TriviumWeb.PaymentController do
  use TriviumWeb, :controller

  alias Trivium.Billing
  alias Trivium.Billing.Payment

  def index(conn, _params) do
    # payments = Billing.list_payments()
    render(conn, "index.html", payments: %{})
  end

  def new(conn, _params) do
    changeset = Billing.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset)
  end

  # %{"stripeToken" => "tok_1Fe6lFBOlG8oDPhTlz3KT3j3"}
  def create(conn, %{"stripeToken" => stripe_token}) do
    user = Pow.Plug.current_user(conn)

    case Billing.create_payment(user, %{payment_id: stripe_token}) do
      {:ok, user} ->
        user |> IO.inspect(label: "updated user")
        user.payment_id |> IO.inspect(label: "updated user payment_id")
        user |> Billing.stripe_update_payment_method()

        conn
        |> put_flash(:info, "Payment created successfully.")
        |> sync_user(user)
        |> redirect(to: Routes.payment_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        # render(conn, "new.html", changeset: changeset)
        render(conn, "index.html", payments: %{})
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    changeset = Billing.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Billing.get_payment!(id)

    case Billing.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Billing.get_payment!(id)
    {:ok, _payment} = Billing.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: Routes.payment_path(conn, :index))
  end
end
