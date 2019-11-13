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
    # plug Phoenix.LiveView.Flash
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler

    # error_handler: TriviumWeb.AuthErrorHandler
  end

  # pipeline :not_authenticated do
  #   plug Pow.Plug.RequireNotAuthenticated,
  #     error_handler: TriviumWeb.AuthErrorHandler
  # end

  pipeline :api do
    plug :accepts, ["json"]
    # plug Trivium.Plug.RateLimit, %{interval_seconds: 1, max_requests: 5}
    plug Trivium.Plug.VerifyRequest
  end

  scope "/" do
    pipe_through :browser
    pow_routes()
    pow_extension_routes()
  end

  scope "/", TriviumWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/contact", PageController, :index
    get "/about", PageController, :index
    get "/legal", PageController, :index
    get "/docs", DocsController, :index
  end

  scope "/", TriviumWeb do
    pipe_through [:browser, :protected]

    get "/dashboard", DashboardController, :index
    # resources "/user", UserController, only: [:show, :update]
    scope "/user" do
      get "/:id", UserController, :show
      post "/:id", UserController, :update
      put "/:id", UserController, :update
    end

    resources "/token", TokensController, only: [:index, :create, :delete]
    # resources "/plans", PlanController, only: [:index, :show]

    scope "/plans" do
      get "/", PlanController, :index
      get "/:id", PlanController, :show
      post "/:id", PlanController, :update_plan_for_user
    end

    scope "/payment" do
      resources "/", PaymentController
    end

    delete "/logout", SessionController, :delete, as: :logout
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
