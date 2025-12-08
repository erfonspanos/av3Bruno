defmodule Av3ApiWeb.RatingController do
  use Av3ApiWeb, :controller

  alias Av3Api.Feedback
  alias Av3Api.Feedback.Rating
  alias Av3Api.Operation 

  action_fallback Av3ApiWeb.FallbackController

  # POST /api/v1/rides/:ride_id/ratings
  def create(conn, %{"ride_id" => ride_id} = params) do
    ride = Operation.get_ride!(ride_id)

    cond do
      ride.status != "FINALIZADA" ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Você só pode avaliar corridas finalizadas."})

      true ->
        rating_params = Map.put(params, "ride_id", ride_id)

        with {:ok, %Rating{} = rating} <- Feedback.create_rating(rating_params) do
          conn
          |> put_status(:created)
          |> render(:show, rating: rating)
        end
    end
  end

  # GET /api/v1/ratings
  def index(conn, _params) do
    ratings = Feedback.list_ratings()
    render(conn, :index, ratings: ratings)
  end

  # GET /api/v1/drivers/:driver_id/ratings
  def index_by_driver(conn, %{"driver_id" => driver_id}) do
    ratings = Feedback.list_ratings_by_driver(driver_id)
    render(conn, :index, ratings: ratings)
  end
end
