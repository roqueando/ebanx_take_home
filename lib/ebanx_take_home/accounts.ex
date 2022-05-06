defmodule EbanxTakeHome.Accounts do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call(:reset, _from, _state), do: {:reply, [], []}
  def handle_call(:get_accounts, _from, state), do: {:reply, state, state}

  def handle_call({:get_account_by_id, value}, _from, state) do
    account = get_account(state, value)

    case account do
      nil ->
        {:reply, {:error, 0}, state}

      _ ->
        account = Map.put(account, :amount, Integer.to_string(account.amount))
        {:reply, account, state}
    end
  end

  def handle_cast({:add_account, %{id: id, amount: amount}}, state)
      when is_binary(id) and is_binary(amount) do
    {:noreply, [%{id: String.to_integer(id), amount: String.to_integer(amount)} | state]}
  end

  def handle_cast({:add_account, account}, state) do
    {:noreply, [account | state]}
  end

  def handle_cast({:withdraw_in_account, id, amount}, state)
      when is_binary(id) and is_binary(amount) do
    id = String.to_integer(id)
    amount = String.to_integer(amount)

    account = get_account(state, id)
    account = Map.put(account, :amount, account.amount - amount)

    {:noreply, [account | state]}
  end

  def handle_cast({:withdraw_in_account, id, amount}, state) do
    account = get_account(state, id)
    account = Map.put(account, :amount, account.amount - amount)

    {:noreply, [account | state]}
  end

  def handle_cast({:deposit_in_account, id, amount}, state)
      when is_binary(id) and is_binary(amount) do
    id = String.to_integer(id)
    amount = String.to_integer(amount)

    account = get_account(state, id)
    account = Map.put(account, :amount, account.amount + amount)

    {:noreply, [account | state]}
  end

  def handle_cast({:deposit_in_account, id, amount}, state) do
    account = get_account(state, id)
    account = Map.put(account, :amount, account.amount + amount)

    {:noreply, [account | state]}
  end

  def handle_cast({:transfer, origin, destination, amount}, state)
      when is_binary(origin) and is_binary(destination) and is_binary(amount) do
    origin = get_account(state, String.to_integer(origin))
    destination = get_account(state, String.to_integer(destination))
    amount = String.to_integer(amount)

    origin_updated = Map.put(origin, :amount, origin.amount - amount)
    destination_updated = Map.put(destination, :amount, destination.amount + amount)

    state = update_accounts(state, origin, origin_updated, destination, destination_updated)

    {:noreply, state}
  end

  def handle_cast({:transfer, origin, destination, amount}, state) do
    origin = get_account(state, origin)
    destination = get_account(state, destination)

    origin_updated = Map.put(origin, :amount, origin.amount - amount)
    destination_updated = Map.put(destination, :amount, destination.amount + amount)

    state = update_accounts(state, origin, origin_updated, destination, destination_updated)
    {:noreply, state}
  end

  def add_account(account), do: GenServer.cast(__MODULE__, {:add_account, account})

  def deposit_in_account(id, amount),
    do: GenServer.cast(__MODULE__, {:deposit_in_account, id, amount})

  def withdraw_in_account(id, amount),
    do: GenServer.cast(__MODULE__, {:withdraw_in_account, id, amount})

  def transfer(origin, destination, amount),
    do: GenServer.cast(__MODULE__, {:transfer, origin, destination, amount})

  def get_accounts, do: GenServer.call(__MODULE__, :get_accounts)
  def reset, do: GenServer.call(__MODULE__, :reset)

  def get_account_by_id(id) when is_binary(id),
    do: GenServer.call(__MODULE__, {:get_account_by_id, String.to_integer(id)})

  def get_account_by_id(id),
    do: GenServer.call(__MODULE__, {:get_account_by_id, id})

  defp get_by_index(_accounts, nil), do: nil
  defp get_by_index(accounts, index), do: Enum.at(accounts, index)

  defp get_account(accounts, id) do
    index = Enum.find_index(accounts, fn account -> account.id == id end)
    get_by_index(accounts, index)
  end

  defp update_accounts(state, origin, new_origin, destination, new_destination) do
    state
    |> Enum.map(fn account ->
      cond do
        account.id == new_origin.id ->
          Map.merge(origin, new_origin)

        account.id == new_destination.id ->
          Map.merge(destination, new_destination)

        true ->
          account
      end
    end)
  end
end
