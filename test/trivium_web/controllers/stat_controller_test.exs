defmodule TriviumWeb.StatControllerTest do
  use TriviumWeb.ConnCase

  alias Trivium.Billing
  alias Trivium.Billing.Stat

  @create_attrs %{
    endpoint: "some endpoint",
    key: "some key",
    user_agent: "some user_agent"
  }
  @update_attrs %{
    endpoint: "some updated endpoint",
    key: "some updated key",
    user_agent: "some updated user_agent"
  }
  @invalid_attrs %{endpoint: nil, key: nil, user_agent: nil}

  def fixture(:stat) do
    {:ok, stat} = Billing.create_stat(@create_attrs)
    stat
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stats", %{conn: conn} do
      conn = get(conn, Routes.stat_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create stat" do
    test "renders stat when data is valid", %{conn: conn} do
      conn = post(conn, Routes.stat_path(conn, :create), stat: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.stat_path(conn, :show, id))

      assert %{
               "id" => id,
               "endpoint" => "some endpoint",
               "key" => "some key",
               "user_agent" => "some user_agent"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.stat_path(conn, :create), stat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stat" do
    setup [:create_stat]

    test "renders stat when data is valid", %{conn: conn, stat: %Stat{id: id} = stat} do
      conn = put(conn, Routes.stat_path(conn, :update, stat), stat: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.stat_path(conn, :show, id))

      assert %{
               "id" => id,
               "endpoint" => "some updated endpoint",
               "key" => "some updated key",
               "user_agent" => "some updated user_agent"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, stat: stat} do
      conn = put(conn, Routes.stat_path(conn, :update, stat), stat: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stat" do
    setup [:create_stat]

    test "deletes chosen stat", %{conn: conn, stat: stat} do
      conn = delete(conn, Routes.stat_path(conn, :delete, stat))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.stat_path(conn, :show, stat))
      end
    end
  end

  defp create_stat(_) do
    stat = fixture(:stat)
    {:ok, stat: stat}
  end
end
