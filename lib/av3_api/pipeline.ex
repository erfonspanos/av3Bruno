defmodule Av3Api.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :av3_api,
    error_handler: Av3ApiWeb.FallbackController,
    module: Av3Api.Guardian

  # 1. Procura o token no Header "Authorization: Bearer <token>"
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # 2. Garante que o token é válido (se não for, barra aqui)
  plug Guardian.Plug.EnsureAuthenticated
  # 3. Carrega os dados do User ou Driver no 'conn' para usarmos depois
  plug Guardian.Plug.LoadResource
end
