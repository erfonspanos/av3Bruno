defmodule Av3Api.Repo.Migrations.CreateLanguages do
  use Ecto.Migration

  def change do
    create table(:languages) do
      add :name, :string
      add :code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
