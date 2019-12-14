defmodule Trivium.Billing.Plan do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "plans" do
    field :name, :string
    field :description, :string
    field :is_trial, :boolean
    field :trial_begins_at, :naive_datetime
    field :trial_ends_at, :naive_datetime
    # Stripe API Plan ID
    field :default, :boolean
    field :plan_id, :string
    field :price, :integer
    field :price_per_call, :integer
    field :user_limit, :integer
    field :request_limit, :integer
    field :request_limit_interval, :integer
    field :request_per_day, :integer
    has_many(:users, Trivium.Users.User, foreign_key: :id)
    field :disabled_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [])

    # |> validate_required([:name, :price, :price_per_call, :user_limit])
  end
end
