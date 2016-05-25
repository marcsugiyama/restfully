defmodule Restfully.Repo.Migrations.CreateCounter do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :name, :string
      add :count, :integer

      timestamps
    end

  end
end
