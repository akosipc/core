defmodule OpenBudgetWeb.Router do
  use OpenBudgetWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json-api"]
    plug OpenBudget.Guardian.AuthPipeline
    plug JaSerializer.Deserializer
  end

  scope "/api", OpenBudgetWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
  end

  scope "/api", OpenBudgetWeb do
    pipe_through :api_auth

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/budgets", BudgetController, except: [:new, :edit] do
      post "/switch", BudgetController, :switch, as: :switch
    end
    resources "/users", UserController, except: [:new, :edit, :create]
    delete "/auth/token", TokenController, :delete
  end

  scope "/api/auth", OpenBudgetWeb do
    pipe_through :api

    resources "/token", TokenController, only: [:create]
  end
end
