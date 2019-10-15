defmodule Trivium.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias Trivium.Private.Token

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    pow_user_fields()
    has_many(:tokens, Token)
    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end
end


# Repo.all(from(u in User, where: u.id == 1, preload: :tokens))