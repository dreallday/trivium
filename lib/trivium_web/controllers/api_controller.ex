defmodule TriviumWeb.ApiController do
  use TriviumWeb, :controller
  alias Trivium.PostGIS
  alias Trivium.PostGIS.Repo

  def test(conn, _params) do
    send_resp(conn, 200, Ecto.UUID.generate())
  end

  def snap_to_road(conn, params) do
    # params |> IO.inspect(label: "snap params")

    {:ok, snapped} = PostGIS.snap_to_road(params)
    #  |> IO.inspect(label: "snap results")

    # snapped = %{
    #   lat: 41.823007601638416,
    #   lon: -71.41251482256106
    # }

    render(conn, "snapped_points.json", points: snapped)
    # send_resp(conn, 200, Ecto.UUID.generate())
  end

  def get_speed_limit(conn, params) do
    {:ok, speedlimits} = PostGIS.get_speed_limit(params)
    # |> IO.inspect(label: "get_speed_limit")
    render(conn, "speed_limits.json", points: speedlimits)
  end
end
