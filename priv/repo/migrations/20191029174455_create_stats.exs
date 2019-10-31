defmodule Trivium.Repo.Migrations.CreateStats do
  use Ecto.Migration

  def change do
    create table(:stats, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      # add(:key, references(:tokens, type: :uuid, on_delete: :delete_all))
      add(:key, :string)
      add(:request_path, :string)
      add(:query_string, :string)
      add(:user_agent, :string)
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all))

      timestamps()
    end
  end
end
