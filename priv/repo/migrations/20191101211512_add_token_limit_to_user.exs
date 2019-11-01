defmodule Trivium.Repo.Migrations.AddTokenLimitToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:token_limit, :integer, default: 1)
    end
  end
end
