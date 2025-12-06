defmodule Av3Api.Fleet.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :plate, :string
    field :model, :string
    field :color, :string
    field :seats, :integer
    field :active, :boolean, default: true

    # Relacionamento com a tabela drivers
    belongs_to :driver, Av3Api.Accounts.Driver

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:plate, :model, :color, :seats, :active, :driver_id])
    |> validate_required([:plate, :model, :color, :seats, :driver_id])
    # O PDF não pede explicitamente, mas placa única é bom senso:
    |> unique_constraint(:plate)
  end
end
