defmodule Trivium.Users do
  use Pow.Ecto.Context,
    repo: Trivium.Repo,
    user: Trivium.Users.User

  # def authenticate(params, config) do
  #   params |> IO.inspect(label: "authenticate params")
  #   pow_authenticate(params)
  # end

  def create(params) do
    params |> IO.inspect(label: "user create params")
    pow_create(params)
  end

  def get_by(clauses) do
    clauses
    |> IO.inspect(label: "get_by clauses")
    |> pow_get_by()
    |> preload_plan()
  end

  defp preload_plan(nil), do: nil

  defp preload_plan(user) do
    Trivium.Repo.preload(user, [:current_plan, :plan])
  end
end
