defmodule EbanxTakeHome.Events.Transfer do
  def call(origin, destination, amount) do
    EbanxTakeHome.Accounts.transfer(origin, destination, amount)
    origin = EbanxTakeHome.Accounts.get_account_by_id(origin)
    destination = EbanxTakeHome.Accounts.get_account_by_id(destination)

    {origin, destination}
  end
end
