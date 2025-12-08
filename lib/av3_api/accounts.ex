defmodule Av3Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Av3Api.Repo
  alias Bcrypt

  alias Av3Api.Accounts.User
  alias Av3Api.Accounts.Driver
  alias Av3Api.Accounts.DriverProfile
  alias Av3Api.Accounts.DriverLanguage
  alias Av3Api.General.Language

  # --- FUNÇÕES DE USUÁRIOS (USERS) ---

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  # --- FUNÇÕES DE MOTORISTAS (DRIVERS) ---

  def list_drivers do
    Repo.all(Driver)
  end

  def get_driver!(id), do: Repo.get!(Driver, id)

  def get_driver(id), do: Repo.get(Driver, id)

  def create_driver(attrs) do
    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  def change_driver(%Driver{} = driver, attrs \\ %{}) do
    Driver.changeset(driver, attrs)
  end

  # --- FUNÇÕES DE PERFIL (DRIVER PROFILE) ---

  def list_driver_profiles do
    Repo.all(DriverProfile)
  end

  def get_driver_profile!(id), do: Repo.get!(DriverProfile, id)

  def create_driver_profile(attrs) do
    %DriverProfile{}
    |> DriverProfile.changeset(attrs)
    |> Repo.insert()
  end

  def update_driver_profile(%DriverProfile{} = driver_profile, attrs) do
    driver_profile
    |> DriverProfile.changeset(attrs)
    |> Repo.update()
  end

  def delete_driver_profile(%DriverProfile{} = driver_profile) do
    Repo.delete(driver_profile)
  end

  def change_driver_profile(%DriverProfile{} = driver_profile, attrs \\ %{}) do
    DriverProfile.changeset(driver_profile, attrs)
  end

  # --- AUTENTICAÇÃO (LOGIN) ---

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}
      true ->
        {:error, :unauthorized}
    end
  end

  def authenticate_driver(email, password) do
    driver = Repo.get_by(Driver, email: email)

    cond do
      driver && Bcrypt.verify_pass(password, driver.password_hash) ->
        {:ok, driver}
      true ->
        {:error, :unauthorized}
    end
  end

  # --- DRIVER PROFILE POR DRIVER ID ---
  def get_driver_profile_by_driver(driver_id) do
    Repo.get_by(DriverProfile, driver_id: driver_id)
  end

  # --- VÍNCULO DE IDIOMAS (DRIVER LANGUAGES) ---

  def create_driver_language(attrs) do
    %DriverLanguage{}
    |> DriverLanguage.changeset(attrs)
    |> Repo.insert()
  end

  def list_driver_languages(driver_id) do
    from(dl in DriverLanguage,
      join: l in Language, on: dl.language_id == l.id,
      where: dl.driver_id == ^driver_id,
      select: %{id: dl.id, language: l.name, code: l.code}
    )
    |> Repo.all()
  end

  def delete_driver_language(id) do
    driver_language = Repo.get!(DriverLanguage, id)
    Repo.delete(driver_language)
  end

end
