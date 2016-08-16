defmodule Restfully.DelayController do
  use Restfully.Web, :controller

  def set_delay(conn, %{"key" => key, "value" => value}) do
    Restfully.Sleep.set_delay(String.to_existing_atom(key), String.to_integer(value))
    render(conn, "show.json", status: "ok")
  end
end
