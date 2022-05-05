defmodule EbanxTakeHomeWeb.ResetControllerTest do
  use EbanxTakeHomeWeb.ConnCase

  setup %{conn: conn} do
    EbanxTakeHome.Accounts.add_account(%{id: 100, amount: 150})
    %{conn: conn, account_id: 100}
  end

  test "POST /reset ", %{conn: conn} do
    conn = post(conn, Routes.reset_path(conn, :reset))

    assert response(conn, 200) == "OK"
    assert EbanxTakeHome.Accounts.get_accounts() == []
  end
end
