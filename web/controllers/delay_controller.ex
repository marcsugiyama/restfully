defmodule Restfully.DelayController do
  use Restfully.Web, :controller

  def set_delay(conn, %{"key" => keystring, "value" => value}) do
    Restfully.Sleep.set_delay(key(keystring), String.to_integer(value))
    render(conn, "show.json", status: "ok")
  end

  defp key("http_millis") do
    :http_millis
  end
  defp key("delay_millis") do
    :delay_millis
  end
end
