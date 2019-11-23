defmodule TriviumWeb.Router do
  @moduledoc false
  use TriviumWeb, :router
  use Pow.Phoenix.Router
  # use Pow.Extension.Phoenix.Router, otp_app: :trivium

  # plug(Plug.Static, at: "/", from: :trivium)

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  forward "/docs", Trivium.DocServer

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug Phoenix.LiveView.Flash

    # plug Plug.Static.IndexHtml, at: "/"
    # plug Plug.Static, at: "/", from: {:trivium, "priv/trivium/build/"}
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      # error_handler: Pow.Phoenix.PlugErrorHandler
      error_handler: TriviumWeb.AuthErrorHandler

    # error_handler: TriviumWeb.AuthErrorHandler
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: TriviumWeb.AuthErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Trivium.Plug.RateLimit, %{interval_seconds: 1, max_requests: 5}
    plug Trivium.Plug.VerifyRequest
  end

  # scope "/" do
  #   pipe_through [:browser, :not_authenticated]
  #   # pow_routes()
  #   pow_extension_routes()
  # end

  scope "/", TriviumWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    resources "/contact", ContactController, only: [:create, :index]
    get "/about", PageController, :index
    get "/legal", PageController, :index
    get "/faq", PageController, :index
    get "/plans", PlanController, :index
  end

  scope "/", TriviumWeb do
    pipe_through [:browser, :not_authenticated]

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup
    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
  end

  scope "/", TriviumWeb do
    pipe_through [:browser, :protected]

    get "/dashboard", DashboardController, :index
    # resources "/user", UserController, only: [:show, :update]
    scope "/user/:id" do
      get "/", UserController, :show
      post "/", UserController, :update
      put "/", UserController, :update

      post "/plan/select/:id", PlanController, :update_plan_for_user
      resources "/token", TokensController, only: [:create, :delete]
      resources "/payment", PaymentController, only: [:index, :create, :update]
    end

    # , only: [:index, :create, :delete]

    # resources "/token", TokensController, only: [:index, :create, :delete]
    # resources "/plans", PlanController, only: [:index, :show]

    scope "/plans" do
      get "/:id", PlanController, :show
      # post "/:id", PlanController, :update_plan_for_user
    end

    get "/logout", SessionController, :delete, as: :logout
    delete "/logout", SessionController, :delete, as: :logout
  end

  scope "/api", TriviumWeb do
    pipe_through :api
    # scope "/v0" do
    #   resources "/interest", UserController, only: [:create]
    # end

    # https://github.com/danschultzer/pow/blob/master/guides/api.md
    # :crypto.hmac(:sha, "secret", "data") |> Base.encode16(case: :lower)
    scope "/v1" do
      get "/test", ApiController, :test
      get "/snap", ApiController, :snap_to_road
      post "/snap", ApiController, :snap_to_road
      get "/speed", ApiController, :get_speed_limit
      post "/speed", ApiController, :get_speed_limit
    end
  end
end
