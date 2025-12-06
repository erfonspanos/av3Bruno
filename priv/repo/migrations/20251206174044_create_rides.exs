defmodule Av3Api.Repo.Migrations.CreateRides do
  use Ecto.Migration

  def change do
    create table(:rides) do
      add :origin_lat, :float
      add :origin_lng, :float
      add :dest_lat, :float
      add :dest_lng, :float
      add :price_estimate, :float
      add :final_price, :float
      # Define o estado inicial padrão conforme requisito do PDF
      add :status, :string, default: "SOLICITADA"
      add :requested_at, :utc_datetime
      add :started_at, :utc_datetime
      add :ended_at, :utc_datetime

      # O Passageiro é obrigatório na criação
      add :user_id, references(:users, on_delete: :nothing), null: false

      # Motorista e Veículo são OPCIONAIS no início (null: true)
      # Pois a corrida nasce sem eles e só é preenchida ao aceitar
      add :driver_id, references(:drivers, on_delete: :nothing), null: true
      add :vehicle_id, references(:vehicles, on_delete: :nothing), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:rides, [:user_id])
    create index(:rides, [:driver_id])
    create index(:rides, [:vehicle_id])
  end
end
