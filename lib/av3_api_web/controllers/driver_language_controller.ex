defmodule Av3ApiWeb.DriverLanguageController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.DriverLanguage
  alias Av3Api.Guardian

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/drivers/:driver_id/languages
  def index(conn, %{"driver_id" => driver_id}) do
    languages = Accounts.list_driver_languages(driver_id)
    json(conn, %{data: languages})
  end

  # POST /api/v1/drivers/:driver_id/languages
  # Espera Body: {"language_id": 1}
  def create(conn, %{"driver_id" => driver_id, "language_id" => language_id}) do
    current_driver = Guardian.Plug.current_resource(conn)

    # Segurança: Só o próprio motorista pode adicionar idiomas ao seu perfil
    if to_string(current_driver.id) != to_string(driver_id) do
       conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    else
      attrs = %{"driver_id" => driver_id, "language_id" => language_id}

      with {:ok, %DriverLanguage{} = dl} <- Accounts.create_driver_language(attrs) do
        conn
        |> put_status(:created)
        |> json(%{message: "Idioma vinculado com sucesso!", id: dl.id})
      end
    end
  end

  # DELETE /api/v1/drivers/:driver_id/languages/:id
  # Aqui o :id é o ID do VÍNCULO (driver_language.id), não do idioma
  def delete(conn, %{"driver_id" => driver_id, "id" => id}) do
    current_driver = Guardian.Plug.current_resource(conn)

    if to_string(current_driver.id) != to_string(driver_id) do
       conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    else
      with {:ok, _} <- Accounts.delete_driver_language(id) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
