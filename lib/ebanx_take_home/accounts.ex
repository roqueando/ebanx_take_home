defmodule EbanxTakeHome.Accounts do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call(:reset, _from, _state), do: {:reply, [], []}
  def handle_call(:get_accounts, _from, state), do: {:reply, state, state}

  def handle_call({:get_account_by_id, value}, _from, state) do
    index = Enum.find_index(state, fn account -> account.id == value end)
    account = get_by_index(state, index)

    case account do
      nil ->
        {:reply, {:error, 0}, state}

      _ ->
        account = Map.put(account, :amount, Integer.to_string(account.amount))
        {:reply, account, state}
    end
  end

  def handle_cast({:add_account, account}, state) do
    {:noreply, [account | state]}
  end

  @doc """
  Add an account to GenServer's account state
  """
  def add_account(account), do: GenServer.cast(__MODULE__, {:add_account, account})

  @doc """
  Get all accounts registered on state
  """
  def get_accounts, do: GenServer.call(__MODULE__, :get_accounts)

  @doc """
  Reset accounts state
  """
  def reset, do: GenServer.call(__MODULE__, :reset)
  def get_account_by_id(id), do: GenServer.call(__MODULE__, {:get_account_by_id, id})

  defp get_by_index(_accounts, nil), do: nil
  defp get_by_index(accounts, index), do: Enum.at(accounts, index)
end
