defmodule Av3ApiWeb.LanguageController do
  use Av3ApiWeb, :controller

  alias Av3Api.General
  alias Av3Api.General.Language
  alias Av3Api.Guardian
  alias Av3Api.Accounts.User # Necessário para checar a role

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/languages (Acessível para qualquer usuário logado)
  def index(conn, _params) do
    languages = General.list_languages()
    render(conn, :index, languages: languages)
  end

  # POST /api/v1/languages (BLINDADO: SÓ ADMIN)
  def create(conn, language_params) do
    current_user = Guardian.Plug.current_resource(conn)

    if is_admin?(current_user) do
      with {:ok, %Language{} = language} <- General.create_language(language_params) do
        conn
        |> put_status(:created)
        |> render(:show, language: language)
      end
    else
      conn |> put_status(:forbidden) |> json(%{error: "Acesso negado. Apenas administradores."})
    end
  end

  # GET /api/v1/languages/:id (Acessível para qualquer usuário logado)
  def show(conn, %{"id" => id}) do
    language = General.get_language!(id)
    render(conn, :show, language: language)
  end

  # PUT /api/v1/languages/:id (BLINDADO: SÓ ADMIN)
  def update(conn, %{"id" => id} = language_params) do
    current_user = Guardian.Plug.current_resource(conn)

    if is_admin?(current_user) do
      language = General.get_language!(id)

      with {:ok, %Language{} = language} <- General.update_language(language, language_params) do
        render(conn, :show, language: language)
      end
    else
      conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    end
  end

  # DELETE /api/v1/languages/:id (BLINDADO: SÓ ADMIN)
  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    if is_admin?(current_user) do
      language = General.get_language!(id)

      with {:ok, %Language{}} <- General.delete_language(language) do
        send_resp(conn, :no_content, "")
      end
    else
      conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    end
  end

  # Função auxiliar para verificar se é Admin
  defp is_admin?(%User{role: "admin"}), do: true
  defp is_admin?(_), do: false
end
