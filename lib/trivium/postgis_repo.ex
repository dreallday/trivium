defmodule Trivium.PostGIS.Repo do
  use Ecto.Repo,
    otp_app: :trivium,
    adapter: Ecto.Adapters.Postgres
end
