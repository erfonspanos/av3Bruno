defmodule Av3ApiWeb.VehicleController do
  use Av3ApiWeb, :controller

  alias Av3Api.Fleet
  alias Av3Api.Fleet.Vehicle

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/drivers/:driver_id/vehicles
  def index(conn, %{"driver_id" => driver_id}) do
    vehicles = Fleet.list_vehicles_by_driver(driver_id)
    render(conn, :index, vehicles: vehicles)
  end

  # POST /api/v1/drivers/:driver_id/vehicles
  def create(conn, %{"driver_id" => driver_id} = params) do
    vehicle_params = Map.put(params, "driver_id", driver_id)

    with {:ok, %Vehicle{} = vehicle} <- Fleet.create_vehicle(vehicle_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/vehicles/#{vehicle}")
      |> render(:show, vehicle: vehicle)
    end
  end

  # GET /api/v1/vehicles/:id
  def show(conn, %{"id" => id}) do
    vehicle = Fleet.get_vehicle!(id)
    render(conn, :show, vehicle: vehicle)
  end

  # PUT /api/v1/vehicles/:id
  def update(conn, %{"id" => id} = params) do
    vehicle = Fleet.get_vehicle!(id)

    with {:ok, %Vehicle{} = vehicle} <- Fleet.update_vehicle(vehicle, params) do
      render(conn, :show, vehicle: vehicle)
    end
  end

  # DELETE /api/v1/vehicles/:id
  def delete(conn, %{"id" => id}) do
    vehicle = Fleet.get_vehicle!(id)

    with {:ok, %Vehicle{}} <- Fleet.delete_vehicle(vehicle) do
      send_resp(conn, :no_content, "")
    end
  end
end
