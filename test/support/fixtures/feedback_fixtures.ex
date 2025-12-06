defmodule Av3Api.FeedbackFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Av3Api.Feedback` context.
  """

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        score: 42
      })
      |> Av3Api.Feedback.create_rating()

    rating
  end
end
