defmodule Av3ApiWeb.AuthController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Guardian
  alias Av3Api.Accounts.User
  alias Av3Api.Accounts.Driver

  action_fallback Av3ApiWeb.FallbackController

  # --- REGISTRO ---

  # Registro de Usuário (Passageiro)
  def register(conn, %{"role" => "user"} = params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:auth_token, user: user, token: token)
    end
  end

  # Registro de Motorista
  def register(conn, %{"role" => "driver"} = params) do
    with {:ok, %Driver{} = driver} <- Accounts.create_driver(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(driver) do
      conn
      |> put_status(:created)
      |> render(:auth_token, driver: driver, token: token)
    end
  end

  # Registro de ADMIN
  def register(conn, %{"role" => "admin"} = params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:auth_token, user: user, token: token)
    end
  end

  def register(_conn, _params) do
    {:error, :bad_request}
  end

  # --- LOGIN ---

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn |> put_status(:ok) |> render(:auth_token, user: user, token: token)

      {:error, _} ->
        case Accounts.authenticate_driver(email, password) do
          {:ok, driver} ->
            {:ok, token, _claims} = Guardian.encode_and_sign(driver)
            conn |> put_status(:ok) |> render(:auth_token, driver: driver, token: token)

          {:error, _} ->
            {:error, :unauthorized}
        end
    end
  end
end
