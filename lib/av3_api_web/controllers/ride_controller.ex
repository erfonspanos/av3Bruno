defmodule Av3ApiWeb.RideController do
  use Av3ApiWeb, :controller

  alias Av3Api.Operation
  alias Av3Api.Operation.Ride
  alias Av3Api.Guardian # Necessário para pegar o usuário logado

  action_fallback Av3ApiWeb.FallbackController

  # POST /api/v1/rides
  # Aqui fazemos a mágica de converter o JSON do PDF para o Banco de Dados
  def create(conn, %{"origin" => origin, "destination" => dest} = _params) do
    # 1. Recupera o usuário logado do Token (colocado lá pelo Pipeline)
    current_user = Guardian.Plug.current_resource(conn)

    # 2. "Achata" os dados: Tira de dentro de 'origin' e põe em 'origin_lat', etc.
    ride_params = %{
      "user_id" => current_user.id,
      "origin_lat" => origin["lat"],
      "origin_lng" => origin["lng"],
      "dest_lat" => dest["lat"],
      "dest_lng" => dest["lng"]
    }

    # 3. Chama a função inteligente 'request_ride' que criamos no Operation
    with {:ok, %Ride{} = ride} <- Operation.request_ride(ride_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/rides/#{ride}") # Comentado para evitar erros de rota
      |> render(:show, ride: ride)
    end
  end

  # GET /api/v1/rides
  def index(conn, _params) do
    rides = Operation.list_rides()
    render(conn, :index, rides: rides)
  end

  # GET /api/v1/rides/:id
  def show(conn, %{"id" => id}) do
    ride = Operation.get_ride!(id)
    render(conn, :show, ride: ride)
  end

  # Update e Delete (mantidos simples se precisar no futuro, mas o foco é o create)
  def update(conn, %{"id" => id, "ride" => ride_params}) do
    ride = Operation.get_ride!(id)

    with {:ok, %Ride{} = ride} <- Operation.update_ride(ride, ride_params) do
      render(conn, :show, ride: ride)
    end
  end

  def delete(conn, %{"id" => id}) do
    ride = Operation.get_ride!(id)

    with {:ok, %Ride{}} <- Operation.delete_ride(ride) do
      send_resp(conn, :no_content, "")
    end
  end
end
