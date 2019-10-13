defmodule Trivium.Private.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Trivium.Users.User
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tokens" do
    field :token, :string
    field :label, :string
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id, :label])
    |> validate_required([:token, :user_id])
  end
end
