defmodule Av3Api.Repo.Migrations.CreateDriverLanguages do
  use Ecto.Migration

  def change do
    create table(:driver_languages) do
      # Cria as chaves estrangeiras para ligar Motorista e Idioma
      add :driver_id, references(:drivers, on_delete: :delete_all)
      add :language_id, references(:languages, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    # Índices para busca rápida
    create index(:driver_languages, [:driver_id])
    create index(:driver_languages, [:language_id])

    # REGRA DE OURO: Garante que não existam duplicatas (O mesmo motorista não pode ter o mesmo idioma 2x)
    create unique_index(:driver_languages, [:driver_id, :language_id])
  end
end
