ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Eqdash.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Eqdash.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Eqdash.Repo)

