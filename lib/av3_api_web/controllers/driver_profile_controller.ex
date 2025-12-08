defmodule Av3ApiWeb.DriverProfileController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.DriverProfile
  alias Av3Api.Guardian

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/drivers/:driver_id/profile
  def show(conn, %{"driver_id" => driver_id}) do
    current_driver = Guardian.Plug.current_resource(conn)

    if to_string(current_driver.id) != to_string(driver_id) do
       conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    else
      case Accounts.get_driver_profile_by_driver(driver_id) do
        nil ->
          conn |> put_status(:not_found) |> json(%{error: "Perfil ainda não criado."})
        profile ->
          render(conn, :show, driver_profile: profile)
      end
    end
  end

  # POST /api/v1/drivers/:driver_id/profile
  def create(conn, %{"driver_id" => driver_id} = params) do
    current_driver = Guardian.Plug.current_resource(conn)

    cond do
      to_string(current_driver.id) != to_string(driver_id) ->
         conn |> put_status(:forbidden) |> json(%{error: "Você não pode criar perfil para outro motorista."})

      Accounts.get_driver_profile_by_driver(driver_id) != nil ->
         conn |> put_status(:conflict) |> json(%{error: "Este motorista já possui um perfil cadastrado."})

      true ->
        profile_params = Map.put(params, "driver_id", driver_id)

        with {:ok, %DriverProfile{} = profile} <- Accounts.create_driver_profile(profile_params) do
          conn
          |> put_status(:created)
          |> render(:show, driver_profile: profile)
        end
    end
  end

  # PUT /api/v1/drivers/:driver_id/profile
  def update(conn, %{"driver_id" => driver_id} = params) do
    current_driver = Guardian.Plug.current_resource(conn)

    if to_string(current_driver.id) != to_string(driver_id) do
       conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    else
      profile = Accounts.get_driver_profile_by_driver(driver_id)

      if profile do
        with {:ok, %DriverProfile{} = updated_profile} <- Accounts.update_driver_profile(profile, params) do
          render(conn, :show, driver_profile: updated_profile)
        end
      else
         conn |> put_status(:not_found) |> json(%{error: "Perfil não encontrado para editar."})
      end
    end
  end
end
