defmodule Restfully.PageController do
  use Restfully.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
