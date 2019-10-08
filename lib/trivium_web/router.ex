defmodule TriviumWeb.Router do
  use TriviumWeb, :router
  use Pow.Phoenix.Router

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
  end

  scope "/protected", TriviumWeb do
    pipe_through [:browser, :protected]
    get "/hi", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TriviumWeb do
  #   pipe_through :api
  # end
end
