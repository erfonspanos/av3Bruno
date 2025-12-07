defmodule Av3ApiWeb.RideController do
  use Av3ApiWeb, :controller

  alias Av3Api.Operation
  alias Av3Api.Operation.Ride
  alias Av3Api.Guardian
  alias Av3Api.Accounts.Driver # Adicionei este alias para usar no teste de tipo

  action_fallback Av3ApiWeb.FallbackController

  # POST /api/v1/rides
  def create(conn, %{"origin" => origin, "destination" => dest} = _params) do
    current_user = Guardian.Plug.current_resource(conn)

    ride_params = %{
      "user_id" => current_user.id,
      "origin_lat" => origin["lat"],
      "origin_lng" => origin["lng"],
      "dest_lat" => dest["lat"],
      "dest_lng" => dest["lng"]
    }

    with {:ok, %Ride{} = ride} <- Operation.request_ride(ride_params) do
      conn
      |> put_status(:created)
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

  # --- POST /api/v1/rides/:id/accept (CORRIGIDO) ---
  def accept(conn, %{"id" => ride_id, "vehicle_id" => vehicle_id}) do
    # Pegamos o recurso logado (pode ser User ou Driver)
    resource = Guardian.Plug.current_resource(conn)

    # Verificamos SE é um Motorista usando Pattern Matching do Elixir
    case resource do
      %Driver{} = driver ->
        # É um motorista! Podemos prosseguir.
        case Operation.accept_ride(ride_id, driver.id, vehicle_id) do
          {:ok, %Ride{} = ride} ->
            render(conn, :show, ride: ride)

          {:error, :conflict} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Esta corrida já foi aceita ou não está disponível."})

          {:error, :not_found} ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Corrida não encontrada."})

          {:error, _reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Erro ao aceitar corrida."})
        end

      _ ->
        # Se não for %Driver{} (ex: é um %User{}), bloqueamos.
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Apenas motoristas podem aceitar corridas."})
    end
  end

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

  # POST /rides/:id/start
  def start(conn, %{"id" => ride_id}) do
    driver = Guardian.Plug.current_resource(conn)

    case Operation.start_ride(ride_id, driver.id) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :conflict} ->
        conn |> put_status(:conflict) |> json(%{error: "A corrida deve estar ACEITA para ser iniciada."})

      {:error, :unauthorized} ->
        conn |> put_status(:forbidden) |> json(%{error: "Você não é o motorista desta corrida."})

      {:error, :not_found} ->
        conn |> put_status(:not_found) |> json(%{error: "Corrida não encontrada."})
    end
  end

  # POST /rides/:id/complete
  def complete(conn, %{"id" => ride_id, "final_price" => final_price}) do
    driver = Guardian.Plug.current_resource(conn)

    case Operation.complete_ride(ride_id, driver.id, final_price) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :conflict} ->
        conn |> put_status(:conflict) |> json(%{error: "A corrida deve estar EM_ANDAMENTO para ser finalizada."})

      {:error, _} ->
        conn |> put_status(:bad_request) |> json(%{error: "Erro ao finalizar corrida."})
    end
  end

  # POST /api/v1/rides/:id/cancel
  def cancel(conn, %{"id" => id}) do
    # Nota: Em um app real, checaríamos se o usuário é o dono da corrida.
    # Para o trabalho, focamos na validação de status.

    case Operation.cancel_ride(id) do
      {:ok, %Ride{} = ride} ->
        render(conn, :show, ride: ride)

      {:error, :conflict} ->
        conn
        |> put_status(:conflict)
        |> json(%{error: "Não é possível cancelar esta corrida (Status inválido)."})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Corrida não encontrada."})
    end
  end
end
