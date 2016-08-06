defmodule Restfully.ProcessController do
  use Restfully.Web, :controller

  def bomb(conn, _) do
    Restfully.Process.bomb
    render(conn, "show.json", status: "ok")
  end

  def defuse(conn, _) do
    Restfully.Process.defuse
    render(conn, "show.json", status: "ok")
  end

end
