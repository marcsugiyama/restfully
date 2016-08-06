defmodule Restfully.EtsController do
  use Restfully.Web, :controller

  def bomb(conn, _) do
    Restfully.Ets.bomb
    render(conn, "show.json", status: "ok")
  end

  def defuse(conn, _) do
    Restfully.Ets.defuse
    render(conn, "show.json", status: "ok")
  end

end
