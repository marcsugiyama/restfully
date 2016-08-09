defmodule Restfully.AtomController do
  use Restfully.Web, :controller

  def bomb(conn, _) do
    atom_bomb
    render(conn, "show.json", status: "ok")
  end
  
  defp atom_bomb do
    spawn_link &make_atoms/0
  end

  defp make_atoms do
    %{"entries" => count_s, "limit" => limit_s} = Regex.named_captures(~r/index_table:atom_tab.size: \d+.limit: (?<limit>\d+).entries: (?<entries>\d+)/su, :erlang.system_info(:info))
    make_atoms(String.to_integer(count_s), String.to_integer(limit_s) - 10000)
  end
  
  def make_atoms(count, limit) when count < limit do
    batch = 10000
    make_atoms(batch)
    :timer.sleep(100)
    make_atoms(count + batch, limit)
  end

  def make_atoms(_, _) do
    :ok
  end

  def make_atoms(0) do
    :ok
  end

  def make_atoms(count) do
    make_atom
    make_atoms(count - 1)
  end

  def make_atom do
    # unique atom
    String.to_atom("atom_#{Integer.to_string(unique_posint)}")
  end

  def unique_posint do
    :erlang.unique_integer([:positive])
  end
end
