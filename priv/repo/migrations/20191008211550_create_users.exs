defmodule Trivium.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:email, :string, null: false)
      add(:password_hash, :string)
      add(:email_confirmation_token, :string)
      add(:email_confirmed_at, :utc_datetime)
      add(:unconfirmed_email, :string)
      timestamps()
      add(:deleted_at, :naive_datetime)
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:email_confirmation_token]))
  end
end
