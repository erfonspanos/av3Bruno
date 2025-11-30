defmodule Av3ApiWeb.DriverProfileController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.DriverProfile

  action_fallback Av3ApiWeb.FallbackController

  def index(conn, _params) do
    driver_profiles = Accounts.list_driver_profiles()
    render(conn, :index, driver_profiles: driver_profiles)
  end

  def create(conn, %{"driver_profile" => driver_profile_params}) do
    with {:ok, %DriverProfile{} = driver_profile} <- Accounts.create_driver_profile(driver_profile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/driver_profiles/#{driver_profile}")
      |> render(:show, driver_profile: driver_profile)
    end
  end

  def show(conn, %{"id" => id}) do
    driver_profile = Accounts.get_driver_profile!(id)
    render(conn, :show, driver_profile: driver_profile)
  end

  def update(conn, %{"id" => id, "driver_profile" => driver_profile_params}) do
    driver_profile = Accounts.get_driver_profile!(id)

    with {:ok, %DriverProfile{} = driver_profile} <- Accounts.update_driver_profile(driver_profile, driver_profile_params) do
      render(conn, :show, driver_profile: driver_profile)
    end
  end

  def delete(conn, %{"id" => id}) do
    driver_profile = Accounts.get_driver_profile!(id)

    with {:ok, %DriverProfile{}} <- Accounts.delete_driver_profile(driver_profile) do
      send_resp(conn, :no_content, "")
    end
  end
end
