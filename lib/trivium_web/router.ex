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
    get "/dashboard", DashboardController, :index

    resources "/tokens", TokensController, only: [:index, :new, :create, :update, :delete]
    # Dashboard get "/dashboard", DashboardController, :index

    # User Preferences
  end

  # Other scopes may use custom stacks.
  # scope "/api", TriviumWeb do
  #   pipe_through :api
  # https://github.com/danschultzer/pow/blob/master/guides/api.md
  # :crypto.hmac(:sha, "secret", "data") |> Base.encode16(case: :lower)

  # end
end
