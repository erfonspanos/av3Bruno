defmodule Av3Api.Accounts.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :status, :string, default: "ACTIVE"

    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :driver_profile, Av3Api.Accounts.DriverProfile

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password, :status])
    # 1. REMOVI :password DAQUI
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_inclusion(:status, ["ACTIVE", "INACTIVE", "BUSY"])
    |> unique_constraint(:email)
    # 2. VALIDAÇÃO INTELIGENTE
    |> validate_password_lifecycle()
  end

  defp validate_password_lifecycle(changeset) do
    if is_nil(changeset.data.id) || get_change(changeset, :password) do
      changeset
      |> validate_required([:password])
      |> validate_length(:password, min: 6)
      |> put_password_hash()
    else
      changeset
    end
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
