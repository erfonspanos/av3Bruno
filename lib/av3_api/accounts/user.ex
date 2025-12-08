defmodule Av3Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :role, :string, default: "user"

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :phone, :password, :role])
    |> validate_required([:name, :email, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_inclusion(:role, ["user", "driver", "admin"])
    |> unique_constraint(:email)
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
