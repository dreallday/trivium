defmodule TriviumWeb.TokensController do
  use TriviumWeb, :controller

  alias Trivium.Private
  alias Trivium.Private.Token

  def index(conn, _params) do
    tokens = Private.list_tokens(conn)
    render(conn, "index.html", tokens: tokens)
  end

  def new(conn, _params) do
    changeset = Private.change_token(%Token{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, _) do
    case Private.create_token(conn) do
      {:ok, tokens} ->
        conn
        |> put_flash(:info, "Token #{tokens.token} created successfully.")
        |> redirect(to: Routes.tokens_path(conn, :index, Private.list_tokens(conn)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tokens = Private.get_token!(id)
    render(conn, "show.html", tokens: tokens)
  end

  def edit(conn, %{"id" => id}) do
    tokens = Private.get_token!(id)
    changeset = Private.change_token(tokens)
    render(conn, "edit.html", tokens: tokens, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tokens" => tokens_params}) do
    tokens = Private.get_token!(id)

    case Private.update_token(tokens, tokens_params) do
      {:ok, tokens} ->
        conn
        |> put_flash(:info, "Token updated successfully.")
        |> redirect(to: Routes.tokens_path(conn, :index, tokens))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tokens: tokens, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tokens = Private.get_token!(id)
    {:ok, _tokens} = Private.delete_token(tokens)

    conn
    |> put_flash(:info, "Token deleted successfully.")
    |> redirect(to: Routes.tokens_path(conn, :index))
  end
end
