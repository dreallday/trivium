defmodule Trivium.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:landing) do
      add :name, :string
      add :email, :string

      timestamps()
    end

  end
end
