defmodule Av3ApiWeb.UserController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.User

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/users (Listar todos)
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  # GET /api/v1/users/:id (Ver perfil)
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # PUT /api/v1/users/:id (Atualizar dados)
  # Removemos a chave "user" do params para aceitar JSON plano
  def update(conn, %{"id" => id} = user_params) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  # DELETE /api/v1/users/:id (Remover conta)
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
