defmodule Av3Api.Feedback do
  @moduledoc """
  The Feedback context.
  """

  import Ecto.Query, warn: false
  alias Av3Api.Repo

  alias Av3Api.Feedback.Rating
  alias Av3Api.Operation.Ride

  @doc """
  Returns the list of ratings.
  """
  def list_ratings do
    Repo.all(Rating)
  end
  def list_ratings_by_driver(driver_id) do
    from(r in Rating,
      join: ride in assoc(r, :ride),       
      where: ride.driver_id == ^driver_id,
      select: r
    )
    |> Repo.all()
  end
  # ---------------------------------------------------

  @doc """
  Gets a single rating.
  Raises `Ecto.NoResultsError` if the Rating does not exist.
  """
  def get_rating!(id), do: Repo.get!(Rating, id)

  @doc """
  Creates a rating.
  """
  def create_rating(attrs) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rating.
  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rating.
  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.
  """
  def change_rating(%Rating{} = rating, attrs \\ %{}) do
    Rating.changeset(rating, attrs)
  end
end
