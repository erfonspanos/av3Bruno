defmodule Av3Api.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :av3_api,
    error_handler: Av3ApiWeb.FallbackController,
    module: Av3Api.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
