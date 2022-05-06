defmodule EbanxTakeHomeWeb.BalanceControllerTest do
  use EbanxTakeHomeWeb.ConnCase

  setup %{conn: conn} do
    EbanxTakeHome.Accounts.reset()
    EbanxTakeHome.Accounts.add_account(%{id: 100, amount: 150})
    %{conn: conn, account_id: 100}
  end

  test "GET /balance?account_id=1234 non exist account", %{conn: conn} do
    conn = get(conn, Routes.balance_path(conn, :index), account_id: 1234)

    assert response(conn, 404) == "0"
  end

  test "GET /balance?account_id=100 existing account", %{conn: conn} do
    conn = get(conn, Routes.balance_path(conn, :index), account_id: 100)
    assert response(conn, 200) == "150"
  end
end
