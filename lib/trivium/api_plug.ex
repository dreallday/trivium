defmodule Trivium.Plug.VerifyRequest do
  import Plug.Conn
  import Ecto.Query, warn: false
  alias Trivium.Repo
  alias Trivium.Private.Token

  defmodule IncompleteRequestError do
    @moduledoc """
    Error raised when a required field is missing.
    """

    defexception message: ""
  end

  def init(options), do: options

  def call(%Plug.Conn{params: params} = conn, _opts) do
    key = params["key"]

    case Trivium.Verify.verify(key) do
      {:ok, :exists} ->
        conn

      {:error, :unauthorized} ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{error: "invalid key"})
        |> halt()

      _ ->
        conn
        |> put_status(401)
        |> Phoenix.Controller.json(%{error: "invalidd key"})
        |> halt()
    end
  end
end
