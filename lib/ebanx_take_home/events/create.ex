defmodule EbanxTakeHome.Events.Create do
  def call(id, amount) do
    EbanxTakeHome.Accounts.add_account(%{
      id: id,
      amount: amount
    })

    EbanxTakeHome.Accounts.get_account_by_id(id)
    |> IO.inspect()

    EbanxTakeHome.Accounts.get_account_by_id(id)
    |> normalize_amount()
  end

  defp normalize_amount(account), do: Map.put(account, :amount, String.to_integer(account.amount))
end
