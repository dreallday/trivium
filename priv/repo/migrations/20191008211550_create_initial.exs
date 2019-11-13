defmodule Trivium.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    # Plan
    create table(:plans, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:is_trial, :boolean, default: false)
      add(:trial_begins_at, :naive_datetime)
      add(:trial_ends_at, :naive_datetime)
      add(:plan_id, :string, comment: "Stripe Plan ID")
      add(:price, :integer)
      add(:price_per_call, :integer)
      add(:request_limit, :integer)
      add(:request_limit_interval, :integer)
      add(:request_per_day, :integer)
      add(:user_limit, :integer, default: -1)

      timestamps()
    end

    create(unique_index(:plans, [:plan_id]))

    # Users 
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:email, :string, null: false)
      add(:password_hash, :string)
      add(:email_confirmation_token, :string)
      add(:email_confirmed_at, :utc_datetime)
      add(:unconfirmed_email, :string)
      add(:deleted_at, :naive_datetime)
      add(:token_limit, :integer, default: 1)
      add(:cus_id, :string, comment: "Stripe Customer ID")
      add(:payment_id, :string, comment: "Stripe Payment ID")
      add(:current_plan, references(:plans, type: :uuid))

      add(:disabled_at, :naive_datetime)
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:email_confirmation_token]))
    # Landing Users - Might not need this
    create table(:landing) do
      add(:name, :string)
      add(:email, :string)

      timestamps()
    end

    # Tokens
    create table(:tokens, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:token, :string)
      add(:label, :string)
      add(:user_id, references(:users, type: :uuid))

      timestamps()
      add(:deleted_at, :naive_datetime)
    end

    create(unique_index(:tokens, [:token]))

    # Stats Gathering
    create table(:stats, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:called_at, :naive_datetime)
      # add(:key, references(:tokens, type: :uuid, on_delete: :delete_all))
      add(:key, :string)
      add(:request_path, :string)
      add(:query_string, :string)
      add(:user_agent, :string)
      add(:user_id, references(:users, type: :uuid))

      # timestamps()
    end

    # Invoices
    create table(:invoices, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :uuid))

      timestamps()
    end
  end
end
