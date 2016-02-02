defmodule Eqdash.Event do
  use Eqdash.Web, :model

  alias Eqdash.Repo

  @derive {Poison.Encoder, only: [:event_id, :latitude, :longitude, :magnitude, :place]}
  schema "events" do
    field :alert, :string
    field :cdi, :decimal
    field :code, :string
    field :detail, :string
    field :event_id, :string
    field :associated_event_ids, :string
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
    field :time, Ecto.DateTime
    field :tsunami, :boolean, default: false
    field :type, :string
    field :tz, :integer
    field :updated, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(
    code
    event_id
  )
  @optional_fields ~w(
    alert
    cdi
    detail
    associated_event_ids
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
    time
    tsunami
    type
    tz
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

  def get_by_event_id(event_id) do
    query = from e in Eqdash.Event, where: e.event_id == ^event_id

    Repo.all(query)
  end

  def latest(limit) do
    query = from e in Eqdash.Event,
            order_by: [desc: :time],
            limit: ^limit

    Repo.all(query)
  end
end
