defmodule Av3ApiWeb.UserController do
  use Av3ApiWeb, :controller

  alias Av3Api.Accounts
  alias Av3Api.Accounts.User
  alias Av3Api.Guardian

  action_fallback Av3ApiWeb.FallbackController

  # GET /api/v1/users (Só ADMIN pode listar todos)
  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.role == "admin" do
      users = Accounts.list_users()
      render(conn, :index, users: users)
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Acesso negado. Apenas administradores podem listar usuários."})
    end
  end

  # GET /api/v1/users/:id (Dono ou Admin)
  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    # Verifica se é Admin OU se é o dono do ID solicitado
    if is_admin?(current_user) || is_owner?(current_user, id) do
      user = Accounts.get_user!(id)
      render(conn, :show, user: user)
    else
      conn |> put_status(:forbidden) |> json(%{error: "Acesso negado."})
    end
  end

  # PUT /api/v1/users/:id (Dono ou Admin)
  def update(conn, %{"id" => id} = user_params) do
    current_user = Guardian.Plug.current_resource(conn)

    if is_admin?(current_user) || is_owner?(current_user, id) do
      user = Accounts.get_user!(id)

      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, :show, user: user)
      end
    else
      conn |> put_status(:forbidden) |> json(%{error: "Você não tem permissão para alterar este perfil."})
    end
  end

  # DELETE /api/v1/users/:id (Dono ou Admin)
  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    if is_admin?(current_user) || is_owner?(current_user, id) do
      user = Accounts.get_user!(id)
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    else
      conn |> put_status(:forbidden) |> json(%{error: "Você não tem permissão para deletar este perfil."})
    end
  end


  defp is_admin?(%User{role: "admin"}), do: true
  defp is_admin?(_), do: false

  defp is_owner?(%User{id: current_id}, target_id) do
    to_string(current_id) == to_string(target_id)
  end
  defp is_owner?(_, _), do: false
end
