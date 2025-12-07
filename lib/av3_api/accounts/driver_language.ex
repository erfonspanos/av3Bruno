defmodule Av3Api.Accounts.DriverLanguage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "driver_languages" do
    # Define o relacionamento com as outras tabelas
    belongs_to :driver, Av3Api.Accounts.Driver
    belongs_to :language, Av3Api.General.Language

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver_language, attrs) do
    driver_language
    |> cast(attrs, [:driver_id, :language_id])
    |> validate_required([:driver_id, :language_id])
    # Garante a unicidade também no nível da aplicação
    |> unique_constraint([:driver_id, :language_id])
  end
end
