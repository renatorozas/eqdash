defmodule Eqdash.Repo.Migrations.AddTitleToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :title, :string
    end
  end
end
