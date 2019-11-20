defmodule Trivium.Cache do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :trivium,
    adapter: Nebulex.Adapters.Local
end
