defmodule EbanxTakeHome.Events.Deposit do
  def call(id, _amount) do
    # EbanxTakeHome.Accounts.deposit_in_account(id, amount)
    EbanxTakeHome.Accounts.get_account_by_id(id)
  end
end
