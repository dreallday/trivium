defmodule Trivium.Accounts.LandingUser do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "landing" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
  end
end
