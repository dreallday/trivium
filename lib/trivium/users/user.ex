defmodule Trivium.Users.User do
  @moduledoc false
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    pow_user_fields()
    field :name, :string
    field :token_limit, :integer
    field :cus_id, :string
    field :payment_id, :string
    has_many(:tokens, Trivium.Private.Token)
    belongs_to(:plan, Trivium.Billing.Plan, foreign_key: :current_plan, type: :binary_id)
    timestamps()
    field :disabled_at, :naive_datetime
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:name, :token_limit, :cus_id, :disabled_at, :current_plan, :payment_id])
    # |> Ecto.Changeset.validate_required([:custom])
    # |> cast(attrs, [:token_limit, :cus_id, :disabled_at, :current_plan])
  end

  # def user_changeset(user, attrs \\ %{}) do
  #   user
  #   |> cast(attrs, [:name, :token_limit, :cus_id, :disabled_at, :current_plan])
  # end

  def plan_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:current_plan])
    |> validate_required([:current_plan])
  end

  def update_payment_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:cus_id, :payment_id])
    |> validate_required([:payment_id])
  end
end

# Repo.all(from(u in User, where: u.id == 1, preload: :tokens))
