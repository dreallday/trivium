defmodule Trivium.Private.Token do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Trivium.Users.User
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tokens" do
    field :token, :string
    field :label, :string
    field :deleted_at, :naive_datetime
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:user_id, :label, :deleted_at])
    |> validate_required([:token, :user_id])
  end

  def delete(token) do
    attrs = %{
      deleted_at: DateTime.utc_now()
    }

    token
    |> cast(attrs, [:deleted_at])
    |> validate_required([:token, :deleted_at])
  end
end
