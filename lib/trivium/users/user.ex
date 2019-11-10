defmodule Trivium.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    pow_user_fields()
    has_many(:tokens, Trivium.Private.Token)
    field :token_limit, :integer
    field :cus_id, :string
    field :disabled_at, :naive_datetime
    belongs_to(:plan, Trivium.Billing.Plan, foreign_key: :current_plan, type: :binary_id)
    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:token_limit, :cus_id, :disabled_at, :current_plan])
  end

  def user_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :current_plan])
  end

  def plan_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:current_plan])
    |> validate_required([:current_plan])
  end
end

# Repo.all(from(u in User, where: u.id == 1, preload: :tokens))
