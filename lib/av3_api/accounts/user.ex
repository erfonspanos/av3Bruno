defmodule Av3Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :role, :string, default: "user" # Define 'user' como padrão

    # Campo virtual: existe na memória para receber a senha digitada
    field :password, :string, virtual: true
    # Campo real: salvo no banco criptografado
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    # 1. Aceitamos 'password' na entrada, não o hash direto
    |> cast(attrs, [:name, :email, :phone, :password, :role])
    # 2. Validamos que name, email, password e role são obrigatórios
    |> validate_required([:name, :email, :password, :role])
    # 3. Validação de formato de email simples
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    # 4. Só aceitamos role 'user' ou 'driver' (conforme PDF)
    |> validate_inclusion(:role, ["user", "driver"])
    # 5. Senha com no mínimo 6 caracteres
    |> validate_length(:password, min: 6)
    # 6. Email único no banco
    |> unique_constraint(:email)
    # 7. Função privada para criptografar a senha
    |> put_password_hash()
  end

  # Transforma o 'password' em 'password_hash' usando Bcrypt
  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
