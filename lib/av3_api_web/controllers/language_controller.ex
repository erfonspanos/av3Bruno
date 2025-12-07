defmodule Av3ApiWeb.LanguageController do
  use Av3ApiWeb, :controller

  alias Av3Api.General
  alias Av3Api.General.Language

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/languages
  def index(conn, _params) do
    languages = General.list_languages()
    render(conn, :index, languages: languages)
  end

  # POST /api/v1/languages
  # CORREÇÃO AQUI: Aceita params diretos (sem %{"language" => ...})
  def create(conn, language_params) do
    with {:ok, %Language{} = language} <- General.create_language(language_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/languages/#{language}") # Comentado para evitar warning
      |> render(:show, language: language)
    end
  end

  # GET /api/v1/languages/:id
  def show(conn, %{"id" => id}) do
    language = General.get_language!(id)
    render(conn, :show, language: language)
  end

  # PUT /api/v1/languages/:id
  # CORREÇÃO AQUI: Aceita params diretos também
  def update(conn, %{"id" => id} = language_params) do
    language = General.get_language!(id)

    with {:ok, %Language{} = language} <- General.update_language(language, language_params) do
      render(conn, :show, language: language)
    end
  end

  # DELETE /api/v1/languages/:id
  def delete(conn, %{"id" => id}) do
    language = General.get_language!(id)

    with {:ok, %Language{}} <- General.delete_language(language) do
      send_resp(conn, :no_content, "")
    end
  end
end
