defmodule Av3Api.Repo do
  use Ecto.Repo,
    otp_app: :av3_api,
    adapter: Ecto.Adapters.MyXQL
end
