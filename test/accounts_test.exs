defmodule EbanxTakeHome.AccountTest do
  use ExUnit.Case, async: true

  setup do
    account = %{
      id: 100,
      amount: 100
    }

    EbanxTakeHome.Accounts.add_account(account)
    %{account_id: account.id}
  end

  test "test adding account" do
    account = %{
      id: 200,
      amount: 100
    }

    EbanxTakeHome.Accounts.add_account(account)
    find_account = EbanxTakeHome.Accounts.get_account_by_id(account.id)
    assert find_account.id == account.id
  end

  test "test reset accounts state" do
    EbanxTakeHome.Accounts.reset()
    assert length(EbanxTakeHome.Accounts.get_accounts()) == 0
  end

  test "test find account by id", %{account_id: id} do
    account = EbanxTakeHome.Accounts.get_account_by_id(id)
    assert account.id == account.id
  end

  test "test not find account by id" do
    account = EbanxTakeHome.Accounts.get_account_by_id(202)
    assert {:error, 0} = account
  end
end
