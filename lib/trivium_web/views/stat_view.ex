defmodule TriviumWeb.StatView do
  use TriviumWeb, :view
  alias TriviumWeb.StatView

  def render("index.json", %{stats: stats}) do
    %{data: render_many(stats, StatView, "stat.json")}
  end

  def render("show.json", %{stat: stat}) do
    %{data: render_one(stat, StatView, "stat.json")}
  end

  def render("stat.json", %{stat: stat}) do
    %{id: stat.id,
      endpoint: stat.endpoint,
      key: stat.key,
      user_agent: stat.user_agent}
  end
end
