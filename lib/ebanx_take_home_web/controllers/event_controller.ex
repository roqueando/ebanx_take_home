defmodule EbanxTakeHomeWeb.EventController do
  use EbanxTakeHomeWeb, :controller

  def create(conn, %{"type" => "deposit", "destination" => destination, "amount" => amount}) do
    account = EbanxTakeHome.Accounts.get_account_by_id(destination)

    case account do
      {:error, _} ->
        account = EbanxTakeHome.Event.create(destination, amount)

        handle_response(
          conn,
          %{destination: %{id: account.id, balance: account.amount}},
          :success
        )

      _ ->
        account = EbanxTakeHome.Event.deposit(destination, amount)

        handle_response(
          conn,
          %{destination: %{id: account.id, balance: account.amount}},
          :success
        )
    end
  end

  defp handle_response(conn, data, :success) do
    conn
    |> put_status(201)
    |> json(data)
  end
end
