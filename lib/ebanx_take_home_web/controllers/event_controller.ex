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

  def create(conn, %{"type" => "withdraw", "origin" => origin, "amount" => amount}) do
    account = EbanxTakeHome.Accounts.get_account_by_id(origin)

    case account do
      {:error, _} ->
        conn
        |> resp(404, "0")

      _ ->
        account = EbanxTakeHome.Event.withdraw(origin, amount)

        handle_response(
          conn,
          %{origin: %{id: account.id, balance: account.amount}},
          :success
        )
    end
  end

  def create(conn, %{
        "type" => "transfer",
        "origin" => origin,
        "destination" => destination,
        "amount" => amount
      }) do
    origin_account = EbanxTakeHome.Accounts.get_account_by_id(origin)
    destination_account = EbanxTakeHome.Accounts.get_account_by_id(destination)

    case {origin_account, destination_account} do
      {{:error, _}, {:error, _}} ->
        conn
        |> resp(404, "0")

      {_, {:error, _}} ->
        conn
        |> resp(404, "0")

      {{:error, _}, _} ->
        conn
        |> resp(404, "0")

      {_, _} ->
        {origin, destination} = EbanxTakeHome.Event.transfer(origin, destination, amount)

        handle_response(
          conn,
          %{
            origin: %{id: origin.id, balance: origin.amount},
            destination: %{id: destination.id, balance: destination.amount}
          },
          :success
        )
    end
  end

  defp handle_response(conn, data, :success) do
    conn
    |> put_status(201)
    |> json(data)
  end

  defp normalize_id(id) when is_binary(id), do: Integer.to_string(id)
  defp normalize_id(id), do: id
end
