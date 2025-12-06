defmodule Av3Api.Operation do
  @moduledoc """
  The Operation context.
  """

  import Ecto.Query, warn: false
  alias Av3Api.Repo
  alias Av3Api.Operation.Ride

  @doc """
  Returns the list of rides.
  """
  def list_rides do
    Repo.all(Ride)
  end

  @doc """
  Gets a single ride.
  Raises `Ecto.NoResultsError` if the Ride does not exist.
  """
  def get_ride!(id), do: Repo.get!(Ride, id)

  # --- FUNÇÃO PERSONALIZADA: SOLICITAR CORRIDA ---
  # Substitui a create_ride padrão para adicionar lógica de negócio
  def request_ride(attrs) do
    # 1. Calcula o preço baseado na distância (Lógica de Negócio)
    price = calculate_price(attrs)

    # 2. Adiciona dados automáticos (Preço, Data atual, Status)
    # Usamos Map.put para injetar esses valores no mapa de atributos
    attrs = attrs
    |> Map.put("price_estimate", price)
    |> Map.put("requested_at", DateTime.utc_now())
    |> Map.put("status", "SOLICITADA")

    # 3. Salva no banco
    %Ride{}
    |> Ride.changeset(attrs)
    |> Repo.insert()
  end

  # Função privada para calcular preço (Simulação)
  # Se recebermos as coordenadas, calculamos a distância
  defp calculate_price(%{"origin_lat" => lat1, "origin_lng" => lng1, "dest_lat" => lat2, "dest_lng" => lng2}) do
    # Distância simples (Euclidiana) para simular o cálculo
    distance = :math.sqrt(:math.pow(lat2 - lat1, 2) + :math.pow(lng2 - lng1, 2))

    # Multiplicador arbitrário: Distância * 1000 + Taxa fixa de 5.00
    (distance * 1000) + 5.00
    |> Float.round(2)
  end

  # Fallback: Se faltar coordenada, cobra taxa mínima
  defp calculate_price(_), do: 10.00
  # -----------------------------------------------

  @doc """
  Updates a ride.
  """
  def update_ride(%Ride{} = ride, attrs) do
    ride
    |> Ride.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ride.
  """
  def delete_ride(%Ride{} = ride) do
    Repo.delete(ride)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ride changes.
  """
  def change_ride(%Ride{} = ride, attrs \\ %{}) do
    Ride.changeset(ride, attrs)
  end
end
