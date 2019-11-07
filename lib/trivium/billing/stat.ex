defmodule Trivium.Billing.Stat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Trivium.Users.User
  alias Trivium.Private.Token
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "stats" do
    # field :key, :string
    belongs_to(:token, Token, type: :string, references: :token, foreign_key: :key)
    field :called_at, :naive_datetime
    field :request_path, :string
    field :query_string, :string
    field :user_agent, :string
    belongs_to(:user, User, type: :binary_id)

    # timestamps()
  end

  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [:key, :request_path, :query_string, :user_agent, :called_at])
    |> validate_required([:key, :request_path])
  end
end
