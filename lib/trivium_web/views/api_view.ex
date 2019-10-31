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

  # def render("show.json", %{point: point}) do
  #   %{data: render_one(point, ApiView, "point.json")}
  # end

  def render("point.json", %{point: point}) do
    %{
      location: %{
        latitude: point["latitude"],
        longitude: point["longitude"]
      },
      distance: point["distance"]
    }
  end
end
