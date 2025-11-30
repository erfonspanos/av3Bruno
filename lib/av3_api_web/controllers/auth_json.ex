defmodule Av3ApiWeb.AuthJSON do
  # Resposta para User
  def auth_token(%{user: user, token: token}) do
    %{
      token: token,
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        role: "user"
      }
    }
  end

  # Resposta para Driver
  def auth_token(%{driver: driver, token: token}) do
    %{
      token: token,
      user: %{ # Mantemos a chave "user" no JSON para facilitar o front/padrão
        id: driver.id,
        name: driver.name,
        email: driver.email,
        role: "driver",
        status: driver.status
      }
    }
  end
end
