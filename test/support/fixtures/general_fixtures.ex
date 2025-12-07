defmodule Av3Api.GeneralFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Av3Api.General` context.
  """

  @doc """
  Generate a language.
  """
  def language_fixture(attrs \\ %{}) do
    {:ok, language} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> Av3Api.General.create_language()

    language
  end
end
