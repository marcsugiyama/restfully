defmodule Restfully.Router do
  use Restfully.Web, :router

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

  scope "/", Restfully do
    pipe_through :api

    resources "/counters", CounterController, except: [:new, :edit]
    get "/counters/:id/next", CounterController, :next
  end
end
