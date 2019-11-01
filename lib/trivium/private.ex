defmodule Trivium.Private do
  @moduledoc """
  The Private context.
  """

  import Ecto.Query, warn: false
  alias Trivium.Repo
  alias Trivium.Private.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens(conn) do
    user = Pow.Plug.current_user(conn)
    #   from(r in Resource, preload: [foo: ^not_deleted(Foo), bar: ^not_deleted(Bar)])
    # |> Repo.all()

    from(t in Token, where: [user_id: ^user.id])
    |> not_deleted()
    |> Repo.all()
  end

  def list_token_number(conn) do
    user = Pow.Plug.current_user(conn)

    from(t in Token, where: [user_id: ^user.id], select: count(t.id))
    |> not_deleted()
    |> Repo.one()
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(conn, attrs \\ %{}) do
    user =
      conn
      |> Pow.Plug.current_user()
      |> IO.inspect(label: "create_token user")

    # user.token_limit 
    # |> IO.inspect(label: "create_token user")
    used_tokens = list_token_number(conn)
    # |> IO.inspect(label: "create_token list_tokens")
    available_tokens = user.token_limit - used_tokens
    # |> IO.inspect(label: "create_token user")

    cond do
      available_tokens > 0 ->
        # available_tokens |> IO.inspect(label: "> 0")

        %Token{
          user_id: user.id,
          token:
            :crypto.hmac(
              :sha,
              "herpaderp",
              :crypto.strong_rand_bytes(6) |> Base.encode16(case: :lower)
            )
            |> Base.encode16(case: :lower)
        }
        |> Token.changeset(attrs)
        |> Repo.insert()

      available_tokens == 0 ->
        # available_tokens |> IO.inspect(label: " = 0")
        {:token_error, "#{used_tokens}/#{user.token_limit} tokens used, can't create any more"}

      true ->
        available_tokens |> IO.inspect(label: "hax")
        {:token_error, "Hax"}
    end

    # |> IO.inspect(label: "about to create token")
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    token
    |> Token.delete()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{source: %Token{}}

  """
  def change_token(%Token{} = token) do
    Token.changeset(token, %{})
  end

  defp not_deleted(query) do
    from(q in query, where: is_nil(q.deleted_at))
  end
end
