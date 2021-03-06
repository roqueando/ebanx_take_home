defmodule EbanxTakeHomeWeb.BalanceController do
  use EbanxTakeHomeWeb, :controller

  def index(conn, %{"account_id" => account_id}) do
    account =
      String.to_integer(account_id)
      |> EbanxTakeHome.Accounts.get_account_by_id()

    case account do
      {:error, _} ->
        conn
        |> resp(404, "0")

      _ ->
        conn
        |> resp(200, Integer.to_string(account.amount))
    end
  end
end
