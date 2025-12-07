defmodule Av3ApiWeb.Router do
  use Av3ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Av3Api.Pipeline
  end

  scope "/api", Av3ApiWeb do
    pipe_through :api

    # Rotas Públicas (v1) - Qualquer um acessa
    scope "/v1" do
      post "/auth/register", AuthController, :register
      post "/auth/login", AuthController, :login
    end
  end

  # Rotas Protegidas (v1) - Só com Token JWT acessa
  scope "/api/v1", Av3ApiWeb do
    pipe_through [:api, :auth]

    get "/drivers/:driver_id/vehicles", VehicleController, :index
    post "/drivers/:driver_id/vehicles", VehicleController, :create

    # CRUD de Motoristas (exceto create, que é via register)
    resources "/drivers", DriverController, except: [:new, :edit, :create]

    # --- USERS ---
    # CRUD de Usuários (exceto create, que é via register)
    resources "/users", UserController, except: [:new, :edit, :create]

    # --- RIDES ---
    resources "/rides", RideController, only: [:create, :index, :show]
    post "/rides/:id/accept", RideController, :accept
    post "/rides/:id/start", RideController, :start
    post "/rides/:id/complete", RideController, :complete
    post "/rides/:id/cancel", RideController, :cancel

    # --- RATINGS ---
    post "/rides/:ride_id/ratings", RatingController, :create

    # Rota de Perfil do Motorista (1:1)
    get "/drivers/:driver_id/profile", DriverProfileController, :show
    post "/drivers/:driver_id/profile", DriverProfileController, :create
    put "/drivers/:driver_id/profile", DriverProfileController, :update

    # --- IDIOMAS (CATÁLOGO GERAL) ---
    resources "/languages", LanguageController, except: [:new, :edit]

    # --- VÍNCULO MOTORISTA x IDIOMA ---
    get "/drivers/:driver_id/languages", DriverLanguageController, :index
    post "/drivers/:driver_id/languages", DriverLanguageController, :create
    delete "/drivers/:driver_id/languages/:id", DriverLanguageController, :delete

  end
end
