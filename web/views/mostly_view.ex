defmodule Restfully.MostlyView do
  use Restfully.Web, :view

  def render("index.json", %{status: status}) do
    %{data: %{status: status}}
  end
end
