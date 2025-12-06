defmodule Av3ApiWeb.DriverController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.Driver

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/drivers (Listar todos)
  def index(conn, _params) do
    drivers = Accounts.list_drivers()
    render(conn, :index, drivers: drivers)
  end

  # GET /api/v1/drivers/:id (Ver perfil)
  def show(conn, %{"id" => id}) do
    driver = Accounts.get_driver!(id)
    render(conn, :show, driver: driver)
  end

  # PUT /api/v1/drivers/:id (Atualizar)
  def update(conn, %{"id" => id} = driver_params) do
    driver = Accounts.get_driver!(id)

    with {:ok, %Driver{} = driver} <- Accounts.update_driver(driver, driver_params) do
      render(conn, :show, driver: driver)
    end
  end

  # DELETE /api/v1/drivers/:id
  def delete(conn, %{"id" => id}) do
    driver = Accounts.get_driver!(id)

    with {:ok, %Driver{}} <- Accounts.delete_driver(driver) do
      send_resp(conn, :no_content, "")
    end
  end
end
