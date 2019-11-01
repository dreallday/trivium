defmodule TriviumWeb.ApiController do
  use TriviumWeb, :controller
  alias Trivium.PostGIS

  def test(conn, _params) do
    send_resp(conn, 200, Ecto.UUID.generate())
  end

  def snap_to_road(conn, params) do
    # params |> IO.inspect(label: "snap params")

    case PostGIS.snap_to_road(params) do
      {:ok, snapped} ->
        render(conn, "snapped_points.json", points: snapped)

      {:error, error} ->
        render(conn, "error.json", error)
    end

    #  |> IO.inspect(label: "snap results")

    # render(conn, "snapped_points.json", points: snapped)
  end

  def get_speed_limit(conn, params) do
    case PostGIS.get_speed_limit(params) do
      {:ok, speedlimits} ->
        render(conn, "speed_limits.json", points: speedlimits)

      {:error, error} ->
        render(conn, "error.json", error)
    end

    # |> IO.inspect(label: "get_speed_limit")
    # render(conn, "speed_limits.json", points: speedlimits)
  end
end
