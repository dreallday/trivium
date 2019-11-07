defmodule TriviumWeb.ApiView do
  use TriviumWeb, :view
  alias TriviumWeb.ApiView

  def render("snapped_points.json", %{points: points}) do
    # points |> IO.inspect(label: "derp")
    %{
      #     # speedLimits: [
      #     #   %{
      #     #     speedLimit: 0,
      #     #     units: "LT"
      #     #   }
      #     # ],
      snappedPoints: render_many(points, ApiView, "point.json", as: :point)
    }
  end

  def render("speed_limits.json", %{points: points}) do
    %{
      speedLimits: render_many(points, ApiView, "speedlimit.json", as: :point),
      snappedPoints: render_many(points, ApiView, "point.json", as: :point)
    }
  end

  # def render("show.json", %{point: point}) do
  #   %{data: render_one(point, ApiView, "point.json")}
  # end

  def render("point.json", %{point: point}) do
    %{
      id: point["id"],
      location: %{
        latitude: point["latitude"],
        longitude: point["longitude"]
      },
      distance: point["distance"]
    }
  end

  def render("speedlimit.json", %{point: point}) do
    [speedlimit, units] =
      case point["maxspeed"] || point["maxspeed_advisory"] do
        x when is_nil(x) -> [nil, nil]
        x -> x |> String.split(" ")
      end
      # |> IO.inspect(label: "get_speed_limit")

    %{
      id: point["id"],
      speedLimit: speedlimit,
      units: units
    }
  end

  def render("error.json", error) do
    error |> IO.inspect(label: "api view error")
    %{}
  end
end
