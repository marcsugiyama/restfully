defmodule Restfully.MostlyController do
  use Restfully.Web, :controller

  def index(conn, _params) do
    # call that occasionally fails
    Restfully.Mostly.call()
    render(conn, "index.json", status: "ok")
  end
end
