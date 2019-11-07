defmodule Trivium.BillingTest do
  use Trivium.DataCase

  alias Trivium.Billing

  describe "stats" do
    alias Trivium.Billing.Stat

    @valid_attrs %{endpoint: "some endpoint", key: "some key", user_agent: "some user_agent"}
    @update_attrs %{
      endpoint: "some updated endpoint",
      key: "some updated key",
      user_agent: "some updated user_agent"
    }
    @invalid_attrs %{endpoint: nil, key: nil, user_agent: nil}

    def stat_fixture(attrs \\ %{}) do
      {:ok, stat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_stat()

      stat
    end

    test "list_stats/0 returns all stats" do
      stat = stat_fixture()
      assert Billing.list_stats() == [stat]
    end

    test "get_stat!/1 returns the stat with given id" do
      stat = stat_fixture()
      assert Billing.get_stat!(stat.id) == stat
    end

    test "create_stat/1 with valid data creates a stat" do
      assert {:ok, %Stat{} = stat} = Billing.create_stat(@valid_attrs)
      assert stat.endpoint == "some endpoint"
      assert stat.key == "some key"
      assert stat.user_agent == "some user_agent"
    end

    test "create_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_stat(@invalid_attrs)
    end

    test "update_stat/2 with valid data updates the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{} = stat} = Billing.update_stat(stat, @update_attrs)
      assert stat.endpoint == "some updated endpoint"
      assert stat.key == "some updated key"
      assert stat.user_agent == "some updated user_agent"
    end

    test "update_stat/2 with invalid data returns error changeset" do
      stat = stat_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_stat(stat, @invalid_attrs)
      assert stat == Billing.get_stat!(stat.id)
    end

    test "delete_stat/1 deletes the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{}} = Billing.delete_stat(stat)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_stat!(stat.id) end
    end

    test "change_stat/1 returns a stat changeset" do
      stat = stat_fixture()
      assert %Ecto.Changeset{} = Billing.change_stat(stat)
    end
  end

  describe "plans" do
    alias Trivium.Billing.Plan

    @valid_attrs %{name: "some name", price: 42, price_per_call: 42, user_limit: 42}
    @update_attrs %{name: "some updated name", price: 43, price_per_call: 43, user_limit: 43}
    @invalid_attrs %{name: nil, price: nil, price_per_call: nil, user_limit: nil}

    def plan_fixture(attrs \\ %{}) do
      {:ok, plan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_plan()

      plan
    end

    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Billing.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = plan_fixture()
      assert Billing.get_plan!(plan.id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      assert {:ok, %Plan{} = plan} = Billing.create_plan(@valid_attrs)
      assert plan.name == "some name"
      assert plan.price == 42
      assert plan.price_per_call == 42
      assert plan.user_limit == 42
    end

    test "create_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_plan(@invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{} = plan} = Billing.update_plan(plan, @update_attrs)
      assert plan.name == "some updated name"
      assert plan.price == 43
      assert plan.price_per_call == 43
      assert plan.user_limit == 43
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_plan(plan, @invalid_attrs)
      assert plan == Billing.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{}} = Billing.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Billing.change_plan(plan)
    end
  end

  describe "invoices" do
    alias Trivium.Billing.Invoice

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_invoice()

      invoice
    end

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Billing.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Billing.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Billing.create_invoice(@valid_attrs)
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{} = invoice} = Billing.update_invoice(invoice, @update_attrs)
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_invoice(invoice, @invalid_attrs)
      assert invoice == Billing.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Billing.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Billing.change_invoice(invoice)
    end
  end
end
