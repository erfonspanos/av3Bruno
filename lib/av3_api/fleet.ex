defmodule Av3Api.Fleet do
  @moduledoc """
  The Fleet context.
  """

  import Ecto.Query, warn: false
  alias Av3Api.Repo

  alias Av3Api.Fleet.Vehicle

  @doc """
  Returns the list of vehicles.
  """
  def list_vehicles do
    Repo.all(Vehicle)
  end

  # --- FUNÇÃO ADICIONADA PARA O CONTROLLER ---
  @doc """
  Returns the list of vehicles belonging to a specific driver.
  """
  def list_vehicles_by_driver(driver_id) do
    from(v in Vehicle, where: v.driver_id == ^driver_id)
    |> Repo.all()
  end
  # -------------------------------------------

  @doc """
  Gets a single vehicle.
  Raises `Ecto.NoResultsError` if the Vehicle does not exist.
  """
  def get_vehicle!(id), do: Repo.get!(Vehicle, id)

  @doc """
  Creates a vehicle.
  """
  def create_vehicle(attrs) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle.
  """
  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle.
  """
  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.
  """
  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end
end
