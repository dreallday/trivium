defmodule Trivium.Billing do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Trivium.Repo

  alias Trivium.Users.User
  alias Trivium.Billing.Stat
  alias Trivium.Billing.Payment

  @doc """
  Returns the list of stats.

  ## Examples

      iex> list_stats()
      [%Stat{}, ...]

  """
  def list_stats do
    Repo.all(Stat)
  end

  @doc """
  Gets a single stat.

  Raises `Ecto.NoResultsError` if the Stat does not exist.

  ## Examples

      iex> get_stat!(123)
      %Stat{}

      iex> get_stat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stat!(id), do: Repo.get!(Stat, id)

  @doc """
  Creates a stat.

  ## Examples

      iex> create_stat(%{field: value})
      {:ok, %Stat{}}

      iex> create_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stat(attrs \\ %{}) do
    %Stat{}
    |> Stat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stat.

  ## Examples

      iex> update_stat(stat, %{field: new_value})
      {:ok, %Stat{}}

      iex> update_stat(stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stat(%Stat{} = stat, attrs) do
    stat
    |> Stat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stat.

  ## Examples

      iex> delete_stat(stat)
      {:ok, %Stat{}}

      iex> delete_stat(stat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stat(%Stat{} = stat) do
    Repo.delete(stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stat changes.

  ## Examples

      iex> change_stat(stat)
      %Ecto.Changeset{source: %Stat{}}

  """
  def change_stat(%Stat{} = stat) do
    Stat.changeset(stat, %{})
  end

  alias Trivium.Billing.Plan

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans()
      [%Plan{}, ...]

  """
  def list_plans do
    Repo.all(Plan)
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(123)
      %Plan{}

      iex> get_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan(id) when not is_nil(id) do
    get_plan!(id)
  end

  def get_plan(id) when is_nil(id) do
    nil
  end

  def get_plan!(id), do: Repo.get!(Plan, id)

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(%{field: value})
      {:ok, %Plan{}}

      iex> create_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Plan{} = plan, attrs) do
    plan
    |> Plan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Plan.

  ## Examples

      iex> delete_plan(plan)
      {:ok, %Plan{}}

      iex> delete_plan(plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Plan{} = plan) do
    Repo.delete(plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(plan)
      %Ecto.Changeset{source: %Plan{}}

  """
  def change_plan(%Plan{} = plan) do
    Plan.changeset(plan, %{})
  end

  alias Trivium.Billing.Invoice

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices do
    Repo.all(Invoice)
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{source: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice) do
    Invoice.changeset(invoice, %{})
  end

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    raise "TODO"
  end

  def get_payment!(stripe_user_id, token)
      when not is_nil(stripe_user_id)
      when not is_nil(token) do
    case stripe_user_id
         |> Stripe.Customer.retrieve() do
      {:ok, stripe_user} ->
        stripe_user.sources |> Map.fetch!(:data) |> List.first()

      {:error, _} ->
        nil
    end
  end

  def get_payment!(_, _), do: nil

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, ...}

  """
  def create_payment(%User{} = user, attrs \\ %{}) do
    user
    |> User.update_payment_changeset(attrs)
    |> Repo.update()
  end

  def get_or_create_stripe_customer(user, token) do
    cus_id =
      case user.cus_id |> is_nil() do
        true ->
          create_stripe_customer(user, token)

        false ->
          update_stripe_customer(user, token)
      end

    user
    |> User.update_payment_changeset(%{cus_id: cus_id, payment_id: token})
    |> Repo.update()
    |> IO.inspect(label: "get_or_create_stripe_customer")
  end

  def update_stripe_customer(user, token) do
    # user |> IO.inspect(label: "update_stripe_customer")

    case Stripe.Customer.update(user.cus_id, %{source: token}) do
      {:ok, user} ->
        %{id: stripe_customer_id} = user
        stripe_customer_id

      {:error, _} ->
        nil
    end
  end

  def create_stripe_customer(user, token) do
    user |> IO.inspect(label: "create_stripe_customer")

    case Stripe.Customer.create(%{email: user.email, source: token}) do
      {:ok, %{id: stripe_customer_id}} ->
        stripe_customer_id

      {:error, _} ->
        nil
    end
  end

  def delete_payment(%Payment{} = payment) do
    raise "TODO"
  end

  def change_payment(%Payment{} = payment) do
    raise "TODO"
  end
end
