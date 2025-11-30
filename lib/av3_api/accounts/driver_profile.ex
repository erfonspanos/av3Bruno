defmodule Av3Api.Accounts.DriverProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "driver_profiles" do
    field :license_number, :string
    field :license_expiry, :date
    field :background_check_ok, :boolean, default: false
    belongs_to :driver, Av3Api.Accounts.Driver

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver_profile, attrs) do
    driver_profile
    |> cast(attrs, [:license_number, :license_expiry, :background_check_ok, :driver_id])
    |> validate_required([:license_number, :license_expiry, :driver_id])
    |> unique_constraint(:driver_id)
  end
end
