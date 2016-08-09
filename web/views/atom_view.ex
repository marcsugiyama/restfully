defmodule Restfully.AtomView do
  use Restfully.Web, :view

  def render("show.json", %{status: status}) do
    %{data: %{status: status}}
  end
end
