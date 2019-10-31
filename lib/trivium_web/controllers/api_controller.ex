defmodule TriviumWeb.ApiController do
  use TriviumWeb, :controller
  alias Trivium.PostGIS
  alias Trivium.PostGIS.Repo

  def test(conn, _params) do
    send_resp(conn, 200, Ecto.UUID.generate())
  end

  def snap_to_road(conn, params) do
    # params |> IO.inspect(label: "snap params")

    snapped = PostGIS.snap_to_road(params)
    #  |> IO.inspect(label: "snap results")

    # snapped = %{
    #   lat: 41.823007601638416,
    #   lon: -71.41251482256106
    # }

    render(conn, "snapped_points.json", points: snapped)
    # send_resp(conn, 200, Ecto.UUID.generate())
  end
end
