defmodule EbanxTakeHome.Events.Create do
  def call(id, amount) do
    EbanxTakeHome.Accounts.add_account(%{
      id: id,
      amount: amount
    })

    EbanxTakeHome.Accounts.get_account_by_id(id)
  end
end
