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

  def add_account(account), do: GenServer.cast(__MODULE__, {:add_account, account})

  def deposit_in_account(id, amount),
    do: GenServer.cast(__MODULE__, {:deposit_in_account, id, amount})

  def withdraw_in_account(id, amount),
    do: GenServer.cast(__MODULE__, {:withdraw_in_account, id, amount})

  @doc """
  Get all accounts registered on state
  """
  def get_accounts, do: GenServer.call(__MODULE__, :get_accounts)

  @doc """
  Reset accounts state
  """
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
end
