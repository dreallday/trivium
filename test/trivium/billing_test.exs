defmodule Trivium.BillingTest do
  use Trivium.DataCase

  alias Trivium.Billing

  describe "stats" do
    alias Trivium.Billing.Stat

    @valid_attrs %{endpoint: "some endpoint", key: "some key", user_agent: "some user_agent"}
    @update_attrs %{endpoint: "some updated endpoint", key: "some updated key", user_agent: "some updated user_agent"}
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
end
