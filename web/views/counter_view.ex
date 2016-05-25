defmodule Restfully.CounterView do
  use Restfully.Web, :view

  def render("index.json", %{counters: counters}) do
    %{data: render_many(counters, Restfully.CounterView, "counter.json")}
  end

  def render("show.json", %{counter: counter}) do
    %{data: render_one(counter, Restfully.CounterView, "counter.json")}
  end

  def render("counter.json", %{counter: counter}) do
    %{id: counter.id,
      name: counter.name,
      count: counter.count}
  end
end
