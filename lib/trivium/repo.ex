defmodule Trivium.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :trivium,
    adapter: Ecto.Adapters.Postgres
end

defmodule Trivium.Repo.GIS do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :trivium,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end
