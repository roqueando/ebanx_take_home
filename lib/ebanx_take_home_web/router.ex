defmodule EbanxTakeHomeWeb.Router do
  use EbanxTakeHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EbanxTakeHomeWeb do
    pipe_through :api

    resources "/balance", BalanceController, only: [:index]
    resources "/event", EventController, only: [:create]
    post "/reset", ResetController, :reset, as: :reset
  end
end
