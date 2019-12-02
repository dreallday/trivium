defmodule Trivium.KeyVerify do
  @moduledoc false
  use GenServer

  import Ecto.Query, warn: false
  alias Trivium.Repo
  alias Trivium.Cache
  alias Trivium.Private.Token

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = %{}
    {:ok, state}
  end

  def verify(key) do
    GenServer.call(__MODULE__, {:sync_verify, key})
  end

  # def verify(pid, key) do
  #   GenServer.call(pid, {:sync_verify, key})
  # end

  def handle_call({:sync_verify, key}, _from, state) do
    # new_state = f(state, args)
    # response = verify_request!(key)
    # |> IO.inspect(label: "genserver key")
    {:reply, verify_request!(key), state}
  end

  defp verify_request!(key) do
    case get(key) do
      {:error, :not_found} ->
        set(key)

      {:ok, _token} ->
        {:ok, :exists}
    end
  end

  defp not_deleted(query) do
    from(q in query, where: is_nil(q.deleted_at))
  end

  def set(key) do
    case from(t in Token, where: [token: ^key])
         |> not_deleted()
         |> Repo.one() do
      %Token{token: token} ->
        Cache.set(token, ttl: 3600)
        {:ok, :exists}

      _ ->
        {:error, :unauthorized}
    end
  end

  defp get(token) do
    case Cache.get(token) do
      nil -> {:error, :not_found}
      token -> {:ok, token}
    end
  end
end
