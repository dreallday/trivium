defmodule Trivium.Users do
  use Pow.Ecto.Context,
    repo: Trivium.Repo,
    user: Trivium.Users.User

  def create(params) do
    pow_create(params)
  end

  def get_by(clauses) do
    clauses
    |> pow_get_by()
    |> preload_plan()
  end

  defp preload_plan(nil), do: nil

  defp preload_plan(user) do
    Trivium.Repo.preload(user, [:current_plan, :plan])
  end
end
