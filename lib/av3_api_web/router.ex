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

    post "/rides/:id/accept", RideController, :accept
    post "/rides/:id/start", RideController, :start
    post "/rides/:id/complete", RideController, :complete

    resources "/rides", RideController, only: [:create, :index, :show]

    # Rota aninhada de Avaliação
    post "/rides/:ride_id/ratings", RatingController, :create
    
    # Aqui colocaremos Users, Drivers, Rides depois...
    resources "/users", UserController, except: [:new, :edit, :create] # Create via register
  end
end
