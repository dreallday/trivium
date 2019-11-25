defmodule TriviumWeb.PlanController do
  @moduledoc false
  use TriviumWeb, :controller

  alias Trivium.Accounts
  alias Trivium.Billing
  alias Trivium.Billing.Plan

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    plans = Billing.list_plans()
    render(conn, "index.html", plans: plans, user: user)
  end

  def new(conn, _params) do
    changeset = Billing.change_plan(%Plan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"plan" => plan_params}) do
    case Billing.create_plan(plan_params) do
      {:ok, plan} ->
        conn
        |> put_flash(:info, "Plan created successfully.")
        |> redirect(to: Routes.plan_path(conn, :show, plan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    plan = Billing.get_plan!(id)
    render(conn, "show.html", user: user, plan: plan)
  end

  def edit(conn, %{"id" => id}) do
    plan = Billing.get_plan!(id)
    changeset = Billing.change_plan(plan)
    render(conn, "edit.html", plan: plan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Billing.get_plan!(id)

    case Billing.update_plan(plan, plan_params) do
      {:ok, plan} ->
        conn
        |> put_flash(:info, "Plan updated successfully.")
        |> redirect(to: Routes.plan_path(conn, :show, plan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", plan: plan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Billing.get_plan!(id)
    {:ok, _plan} = Billing.delete_plan(plan)

    conn
    |> put_flash(:info, "Plan deleted successfully.")
    |> redirect(to: Routes.plan_path(conn, :index))
  end

  def update_plan_for_user(conn, %{"id" => id}) do
    # id |> IO.inspect(label: "plan id")
    user = Pow.Plug.current_user(conn) |> IO.inspect(label: "user")
    plan = Billing.get_plan(id) |> IO.inspect(label: "plan")

    {:ok, updated_user} =
      Accounts.change_user_plan(user, plan) |> IO.inspect(label: "updated user")

    conn
    |> put_flash(:info, "Plan-ed successfully.")
    |> sync_user(updated_user)
    |> redirect(to: Routes.plan_path(conn, :index))
  end
end
