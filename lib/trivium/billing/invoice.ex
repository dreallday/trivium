defmodule Trivium.Billing.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "invoices" do
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [])
    |> validate_required([])
  end
end
