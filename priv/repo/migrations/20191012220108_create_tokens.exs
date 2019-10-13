defmodule Trivium.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:token, :string)
      add(:label, :string)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end
  end
end
