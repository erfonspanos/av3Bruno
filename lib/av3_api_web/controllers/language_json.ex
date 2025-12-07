defmodule Av3ApiWeb.LanguageJSON do
  alias Av3Api.General.Language

  @doc """
  Renders a list of languages.
  """
  def index(%{languages: languages}) do
    %{data: for(language <- languages, do: data(language))}
  end

  @doc """
  Renders a single language.
  """
  def show(%{language: language}) do
    %{data: data(language)}
  end

  defp data(%Language{} = language) do
    %{
      id: language.id,
      name: language.name,
      code: language.code
    }
  end
end
