defmodule TriviumWeb.Router do
  use TriviumWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :trivium

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    # plug Trivium.Plug.RateLimit, %{interval_seconds: 1, max_requests: 5}
    plug Trivium.Plug.VerifyRequest
  end

  scope "/", TriviumWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/register" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  scope "/", TriviumWeb do
    pipe_through [:browser, :protected]

    scope "/dashboard" do
      get "/", DashboardController, :index
      resources "/token", TokensController, only: [:index, :create, :delete]
    end

    # Dashboard get "/dashboard", DashboardController, :index

    # User Preferences
  end

  scope "/api", TriviumWeb do
    scope "/v0" do
      resources "/interest", UserController, only: [:create]
    end

    # https://github.com/danschultzer/pow/blob/master/guides/api.md
    # :crypto.hmac(:sha, "secret", "data") |> Base.encode16(case: :lower)
    scope "/v1" do
      pipe_through :api
      get "/test", ApiController, :test
      get "/snap", ApiController, :snap_to_road
      post "/snap", ApiController, :snap_to_road
      get "/speed", ApiController, :get_speed_limit
      post "/speed", ApiController, :get_speed_limit
    end
  end
end
