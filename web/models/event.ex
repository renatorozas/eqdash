defmodule Eqdash.Event do
  use Eqdash.Web, :model

  alias Eqdash.Repo

  @derive {
    Poison.Encoder, only: [
      :event_id,
      :latitude,
      :longitude,
      :magnitude,
      :place,
      :time_local
    ]
  }
  schema "events" do
    field :alert, :string
    field :associated_event_ids, :string
    field :cdi, :decimal
    field :code, :string
    field :detail, :string
    field :event_id, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :magnitude, :decimal
    field :magnitude_type, :string
    field :mmi, :decimal
    field :net, :string
    field :place, :string
    field :sig, :integer
    field :sources, :string
    field :status, :string
    field :time_local, Ecto.DateTime
    field :time_utc, Ecto.DateTime
    field :tsunami, :boolean, default: false
    field :type, :string
    field :tz_offset_secs, :integer
    field :updated, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(
    code
    event_id
  )
  @optional_fields ~w(
    alert
    associated_event_ids
    cdi
    detail
    latitude
    longitude
    magnitude
    magnitude_type
    mmi
    net
    place
    sig
    sources
    status
    time_local
    time_utc
    tsunami
    type
    tz_offset_secs
    updated
  )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def latest(limit) do
    query = from e in __MODULE__, order_by: [desc: :time_local], limit: ^limit
    Repo.all(query)
  end
end
