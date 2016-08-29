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
    plug Restfully.StatsPlug
  end

  scope "/", Restfully do
    pipe_through :api

    resources "/counters", CounterController, except: [:new, :edit]
    get "/counters/:id/next", CounterController, :next
    get "/counters/:id/incr", CounterController, :incr
    get "/ets/bomb", EtsController, :bomb
    get "/ets/defuse", EtsController, :defuse
    get "/process/bomb", ProcessController, :bomb
    get "/process/defuse", ProcessController, :defuse
    get "/atom/bomb", AtomController, :bomb
    put "/delay/:key/:value", DelayController, :set_delay
    get "/mostly", MostlyController, :index
  end
end
