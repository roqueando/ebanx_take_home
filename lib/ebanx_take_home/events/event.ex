defmodule EbanxTakeHome.Event do
  alias EbanxTakeHome.Events.Create
  alias EbanxTakeHome.Events.Deposit
  defdelegate create(id, amount), to: Create, as: :call
  defdelegate deposit(id, amount), to: Deposit, as: :call
end
