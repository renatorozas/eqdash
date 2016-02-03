defmodule Eqdash.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :alert, :string
      add :associated_event_ids, :string
      add :cdi, :decimal
      add :code, :string
      add :detail, :string
      add :event_id, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :magnitude, :decimal
      add :magnitude_type, :string
      add :mmi, :decimal
      add :net, :string
      add :place, :string
      add :sig, :integer
      add :sources, :string
      add :status, :string
      add :time, :datetime
      add :tsunami, :boolean, default: false
      add :type, :string
      add :tz_offset, :integer
      add :updated, :datetime

      timestamps
    end

  end
end
