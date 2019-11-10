defmodule Trivium.Repo do
  use Ecto.Repo,
    otp_app: :trivium,
    adapter: Ecto.Adapters.Postgres
end

defmodule Trivium.Repo.GIS do
  use Ecto.Repo,
    otp_app: :trivium,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end
