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
  def list_tokens(conn \\ nil) do
    user = conn |> Pow.Plug.current_user()
    Repo.all(Token, user_id: user.id)
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
    user = conn |> Pow.Plug.current_user()

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
    |> IO.inspect(label: "about to create token")
    |> Token.changeset(attrs)
    |> Repo.insert()
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
    Repo.delete(token)
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
end
