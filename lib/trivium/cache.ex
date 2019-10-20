defmodule Trivium.Cache do
  use Nebulex.Cache,
    otp_app: :trivium,
    adapter: Nebulex.Adapters.Local
end
