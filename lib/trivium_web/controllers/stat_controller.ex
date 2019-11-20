defmodule TriviumWeb.StatController do
  @moduledoc false
  use TriviumWeb, :controller

  alias Trivium.Billing
  alias Trivium.Billing.Stat

  action_fallback TriviumWeb.FallbackController

  def index(conn, _params) do
    stats = Billing.list_stats()
    render(conn, "index.json", stats: stats)
  end

  def create(conn, %{"stat" => stat_params}) do
    with {:ok, %Stat{} = stat} <- Billing.create_stat(stat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.stat_path(conn, :show, stat))
      |> render("show.json", stat: stat)
    end
  end

  def show(conn, %{"id" => id}) do
    stat = Billing.get_stat!(id)
    render(conn, "show.json", stat: stat)
  end

  def update(conn, %{"id" => id, "stat" => stat_params}) do
    stat = Billing.get_stat!(id)

    with {:ok, %Stat{} = stat} <- Billing.update_stat(stat, stat_params) do
      render(conn, "show.json", stat: stat)
    end
  end

  def delete(conn, %{"id" => id}) do
    stat = Billing.get_stat!(id)

    with {:ok, %Stat{}} <- Billing.delete_stat(stat) do
      send_resp(conn, :no_content, "")
    end
  end
end
