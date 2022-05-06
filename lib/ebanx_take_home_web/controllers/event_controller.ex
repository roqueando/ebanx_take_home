defmodule EbanxTakeHomeWeb.EventController do
  use EbanxTakeHomeWeb, :controller

  def create(conn, %{"type" => "deposit", "destination" => destination, "amount" => amount}) do
    account = EbanxTakeHome.Accounts.get_account_by_id(destination)

    case account do
      {:error, _} ->
        account = EbanxTakeHome.Event.create(destination, amount)

        handle_response(
          conn,
          mount_response(account, :destination),
          :success
        )

      _ ->
        account = EbanxTakeHome.Event.deposit(destination, amount)

        handle_response(
          conn,
          mount_response(account, :destination),
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
          mount_response(account, :origin),
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
          mount_response(origin, destination, :both),
          :success
        )
    end
  end

  defp handle_response(conn, data, :success) do
    conn
    |> put_status(201)
    |> json(data)
  end

  def mount_response(%{id: id, amount: amount}, :destination) do
    %{
      destination: %{
        id: Integer.to_string(id),
        balance: amount
      }
    }
  end

  def mount_response(%{id: id, amount: amount}, :origin) do
    %{
      origin: %{
        id: Integer.to_string(id),
        balance: amount
      }
    }
  end

  def mount_response(
        %{id: origin_id, amount: origin_amount},
        %{id: destination_id, amount: destination_amount},
        :both
      ) do
    %{
      origin: %{
        id: Integer.to_string(origin_id),
        balance: origin_amount
      },
      destination: %{
        id: Integer.to_string(destination_id),
        balance: destination_amount
      }
    }
  end
end
