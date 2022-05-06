defmodule EbanxTakeHome.Event do
  alias EbanxTakeHome.Events.Create
  alias EbanxTakeHome.Events.Deposit
  alias EbanxTakeHome.Events.Withdraw
  alias EbanxTakeHome.Events.Transfer

  defdelegate create(id, amount), to: Create, as: :call
  defdelegate deposit(id, amount), to: Deposit, as: :call
  defdelegate withdraw(id, amount), to: Withdraw, as: :call
  defdelegate transfer(origin, destination, amount), to: Transfer, as: :call
end
