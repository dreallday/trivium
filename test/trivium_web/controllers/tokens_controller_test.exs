defmodule TriviumWeb.TokensControllerTest do
  use TriviumWeb.ConnCase

  alias Trivium.Private

  @create_attrs %{token: "some token"}
  @update_attrs %{token: "some updated token"}
  @invalid_attrs %{token: nil}

  def fixture(:tokens) do
    {:ok, tokens} = Private.create_tokens(@create_attrs)
    tokens
  end

  describe "index" do
    test "lists all tokens", %{conn: conn} do
      conn = get(conn, Routes.tokens_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tokens"
    end
  end

  describe "new tokens" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tokens_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tokens"
    end
  end

  describe "create tokens" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tokens_path(conn, :create), tokens: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tokens_path(conn, :show, id)

      conn = get(conn, Routes.tokens_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tokens"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tokens_path(conn, :create), tokens: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tokens"
    end
  end

  describe "edit tokens" do
    setup [:create_tokens]

    test "renders form for editing chosen tokens", %{conn: conn, tokens: tokens} do
      conn = get(conn, Routes.tokens_path(conn, :edit, tokens))
      assert html_response(conn, 200) =~ "Edit Tokens"
    end
  end

  describe "update tokens" do
    setup [:create_tokens]

    test "redirects when data is valid", %{conn: conn, tokens: tokens} do
      conn = put(conn, Routes.tokens_path(conn, :update, tokens), tokens: @update_attrs)
      assert redirected_to(conn) == Routes.tokens_path(conn, :show, tokens)

      conn = get(conn, Routes.tokens_path(conn, :show, tokens))
      assert html_response(conn, 200) =~ "some updated token"
    end

    test "renders errors when data is invalid", %{conn: conn, tokens: tokens} do
      conn = put(conn, Routes.tokens_path(conn, :update, tokens), tokens: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tokens"
    end
  end

  describe "delete tokens" do
    setup [:create_tokens]

    test "deletes chosen tokens", %{conn: conn, tokens: tokens} do
      conn = delete(conn, Routes.tokens_path(conn, :delete, tokens))
      assert redirected_to(conn) == Routes.tokens_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.tokens_path(conn, :show, tokens))
      end
    end
  end

  defp create_tokens(_) do
    tokens = fixture(:tokens)
    {:ok, tokens: tokens}
  end
end
