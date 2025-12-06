defmodule Av3Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Av3Api.Repo
  alias Bcrypt # <--- Importante para checar senha

  alias Av3Api.Accounts.User
  alias Av3Api.Accounts.Driver
  alias Av3Api.Accounts.DriverProfile

  # --- FUNÇÕES DE USUÁRIOS (USERS) ---

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  # Adicionei esta função que retorna nil em vez de erro (para o Guardian)
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

  # Adicionei esta função que retorna nil em vez de erro (para o Guardian)
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

  # --- AUTENTICAÇÃO (LOGIN) - NECESSÁRIO PARA O AUTH CONTROLLER ---

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
end
