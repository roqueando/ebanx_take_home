defmodule EbanxTakeHome.Events.Withdraw do
  def call(id, amount) do
    EbanxTakeHome.Accounts.withdraw_in_account(id, amount)
    EbanxTakeHome.Accounts.get_account_by_id(id)
  end
end
