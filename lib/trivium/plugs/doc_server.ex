defmodule Trivium.DocServer do
  @moduledoc false
  use Plug.Builder

  plug Plug.Static,
    at: "/",
    from: {:trivium, "priv/static/doc"}
end
