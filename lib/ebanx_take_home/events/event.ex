defmodule EbanxTakeHome.Event do
  alias EbanxTakeHome.Events.Create
  alias EbanxTakeHome.Events.Deposit
  alias EbanxTakeHome.Events.Withdraw
  defdelegate create(id, amount), to: Create, as: :call
  defdelegate deposit(id, amount), to: Deposit, as: :call
  defdelegate withdraw(id, amount), to: Withdraw, as: :call
end
