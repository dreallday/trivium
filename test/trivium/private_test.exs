defmodule Trivium.PrivateTest do
  use Trivium.DataCase

  alias Trivium.Private

  describe "dashboard" do
    alias Trivium.Private.Dashboard

    @valid_attrs %{test: "some test"}
    @update_attrs %{test: "some updated test"}
    @invalid_attrs %{test: nil}

    def dashboard_fixture(attrs \\ %{}) do
      {:ok, dashboard} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Private.create_dashboard()

      dashboard
    end

    test "list_dashboard/0 returns all dashboard" do
      dashboard = dashboard_fixture()
      assert Private.list_dashboard() == [dashboard]
    end

    test "get_dashboard!/1 returns the dashboard with given id" do
      dashboard = dashboard_fixture()
      assert Private.get_dashboard!(dashboard.id) == dashboard
    end

    test "create_dashboard/1 with valid data creates a dashboard" do
      assert {:ok, %Dashboard{} = dashboard} = Private.create_dashboard(@valid_attrs)
      assert dashboard.test == "some test"
    end

    test "create_dashboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Private.create_dashboard(@invalid_attrs)
    end

    test "update_dashboard/2 with valid data updates the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{} = dashboard} = Private.update_dashboard(dashboard, @update_attrs)
      assert dashboard.test == "some updated test"
    end

    test "update_dashboard/2 with invalid data returns error changeset" do
      dashboard = dashboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Private.update_dashboard(dashboard, @invalid_attrs)
      assert dashboard == Private.get_dashboard!(dashboard.id)
    end

    test "delete_dashboard/1 deletes the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{}} = Private.delete_dashboard(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Private.get_dashboard!(dashboard.id) end
    end

    test "change_dashboard/1 returns a dashboard changeset" do
      dashboard = dashboard_fixture()
      assert %Ecto.Changeset{} = Private.change_dashboard(dashboard)
    end
  end

  describe "tokens" do
    alias Trivium.Private.Token

    @valid_attrs %{token: "some token", user_id: 42}
    @update_attrs %{token: "some updated token", user_id: 43}
    @invalid_attrs %{token: nil, user_id: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Private.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Private.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Private.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Private.create_token(@valid_attrs)
      assert token.token == "some token"
      assert token.user_id == 42
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Private.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, %Token{} = token} = Private.update_token(token, @update_attrs)
      assert token.token == "some updated token"
      assert token.user_id == 43
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Private.update_token(token, @invalid_attrs)
      assert token == Private.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Private.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Private.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Private.change_token(token)
    end
  end

  describe "tokens" do
    alias Trivium.Private.Tokens

    @valid_attrs %{token: "some token"}
    @update_attrs %{token: "some updated token"}
    @invalid_attrs %{token: nil}

    def tokens_fixture(attrs \\ %{}) do
      {:ok, tokens} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Private.create_tokens()

      tokens
    end

    test "list_tokens/0 returns all tokens" do
      tokens = tokens_fixture()
      assert Private.list_tokens() == [tokens]
    end

    test "get_tokens!/1 returns the tokens with given id" do
      tokens = tokens_fixture()
      assert Private.get_tokens!(tokens.id) == tokens
    end

    test "create_tokens/1 with valid data creates a tokens" do
      assert {:ok, %Tokens{} = tokens} = Private.create_tokens(@valid_attrs)
      assert tokens.token == "some token"
    end

    test "create_tokens/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Private.create_tokens(@invalid_attrs)
    end

    test "update_tokens/2 with valid data updates the tokens" do
      tokens = tokens_fixture()
      assert {:ok, %Tokens{} = tokens} = Private.update_tokens(tokens, @update_attrs)
      assert tokens.token == "some updated token"
    end

    test "update_tokens/2 with invalid data returns error changeset" do
      tokens = tokens_fixture()
      assert {:error, %Ecto.Changeset{}} = Private.update_tokens(tokens, @invalid_attrs)
      assert tokens == Private.get_tokens!(tokens.id)
    end

    test "delete_tokens/1 deletes the tokens" do
      tokens = tokens_fixture()
      assert {:ok, %Tokens{}} = Private.delete_tokens(tokens)
      assert_raise Ecto.NoResultsError, fn -> Private.get_tokens!(tokens.id) end
    end

    test "change_tokens/1 returns a tokens changeset" do
      tokens = tokens_fixture()
      assert %Ecto.Changeset{} = Private.change_tokens(tokens)
    end
  end
end
