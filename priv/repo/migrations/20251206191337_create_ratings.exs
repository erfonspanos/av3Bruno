defmodule Av3Api.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :score, :integer
      add :comment, :text
      add :ride_id, references(:rides, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:ratings, [:ride_id])
  end
end
