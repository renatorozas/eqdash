defmodule Eqdash.Router do
  use Eqdash.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Eqdash do
    pipe_through :browser # Use the default browser stack

    get "/", EventController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Eqdash do
  #   pipe_through :api
  # end
end
