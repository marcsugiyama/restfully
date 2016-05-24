ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Restfully.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Restfully.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Restfully.Repo)

