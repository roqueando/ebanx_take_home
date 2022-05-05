defmodule EbanxTakeHomeWeb.Router do
  use EbanxTakeHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EbanxTakeHomeWeb do
    pipe_through :api

    resources "/balance", BalanceController, only: [:index]
  end
end
