defmodule Av3ApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """
  use Av3ApiWeb, :controller

  # Trata erros do Ecto (Changeset inválido) -> 422
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: Av3ApiWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # Trata recurso não encontrado -> 404
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: Av3ApiWeb.ErrorHTML, json: Av3ApiWeb.ErrorJSON)
    |> render(:"404")
  end

  # --- CORREÇÃO DO ERRO 500 ---
  # Esta função é chamada pelo Guardian quando a autenticação falha.
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: Av3ApiWeb.ErrorJSON)
    |> render(:"401")
  end
end
