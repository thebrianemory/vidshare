defmodule VideoShareWeb.Router do
  use VideoShareWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(VideoShare.Plugs.SetUser)
  end

  pipeline :auth do
    plug(VideoShareWeb.Plugs.RequireAuth)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", VideoShareWeb do
    pipe_through([:browser, :auth])

    resources("/videos", VideoController, only: [:new, :create])
  end

  scope "/", VideoShareWeb do
    # Use the default browser stack
    pipe_through(:browser)

    resources("/videos", VideoController, only: [:index, :show, :delete])
    get("/", PageController, :index)
  end

  scope "/auth", VideoShareWeb do
    pipe_through(:browser)

    get("/signout", AuthController, :delete)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :new)
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideoShareWeb do
  #   pipe_through :api
  # end
end
