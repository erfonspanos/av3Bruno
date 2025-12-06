defmodule Av3Api.OperationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Av3Api.Operation` context.
  """

  @doc """
  Generate a ride.
  """
  def ride_fixture(attrs \\ %{}) do
    {:ok, ride} =
      attrs
      |> Enum.into(%{
        dest_lat: 120.5,
        dest_lng: 120.5,
        ended_at: ~U[2025-12-05 17:40:00Z],
        final_price: 120.5,
        origin_lat: 120.5,
        origin_lng: 120.5,
        price_estimate: 120.5,
        requested_at: ~U[2025-12-05 17:40:00Z],
        started_at: ~U[2025-12-05 17:40:00Z],
        status: "some status"
      })
      |> Av3Api.Operation.create_ride()

    ride
  end
end
