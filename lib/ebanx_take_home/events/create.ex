defmodule EbanxTakeHome.Events.Create do
  def call(id, amount) do
    EbanxTakeHome.Accounts.add_account(%{
      id: id,
      amount: amount
    })

    EbanxTakeHome.Accounts.get_account_by_id(id)
    |> normalize_id()
    |> normalize_amount()
  end

  defp normalize_id(account), do: Map.put(account, :id, Integer.to_string(account.id))
  defp normalize_amount(account), do: Map.put(account, :amount, String.to_integer(account.amount))
end
