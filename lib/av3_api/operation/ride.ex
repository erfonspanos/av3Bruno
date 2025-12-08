defmodule Av3Api.Operation.Ride do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rides" do
    field :origin_lat, :float
    field :origin_lng, :float
    field :dest_lat, :float
    field :dest_lng, :float

    field :status, :string, default: "SOLICITADA"
    field :price_estimate, :float
    field :final_price, :float

    field :requested_at, :utc_datetime
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime

    belongs_to :user, Av3Api.Accounts.User
    belongs_to :driver, Av3Api.Accounts.Driver
    belongs_to :vehicle, Av3Api.Fleet.Vehicle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ride, attrs) do
    ride
    |> cast(attrs, [
      :origin_lat, :origin_lng, :dest_lat, :dest_lng,
      :price_estimate, :final_price, :status,
      :requested_at, :started_at, :ended_at,
      :user_id, :driver_id, :vehicle_id
    ])
    |> validate_required([:origin_lat, :origin_lng, :dest_lat, :dest_lng, :user_id])
    |> validate_inclusion(:status, ["SOLICITADA", "ACEITA", "EM_ANDAMENTO", "FINALIZADA", "CANCELADA"])
  end
end
