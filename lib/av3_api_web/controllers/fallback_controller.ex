defmodule Av3ApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """
  use Av3ApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: Av3ApiWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: Av3ApiWeb.ErrorHTML, json: Av3ApiWeb.ErrorJSON)
    |> render(:"404")
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: Av3ApiWeb.ErrorJSON)
    |> render(:"401")
  end
end
