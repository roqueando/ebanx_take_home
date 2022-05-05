defmodule EbanxTakeHomeWeb.EventControllerTest do
  use EbanxTakeHomeWeb.ConnCase

  test "POST /event Create account with initial balance", %{conn: conn} do
    params = %{
      "type" => "deposit",
      "destination" => "100",
      "amount" => 10
    }

    conn = post(conn, Routes.event_path(conn, :create, params))

    result = json_response(conn, 201)["destination"]
    assert result["balance"] == 10
    assert result["id"] == 100
  end
end
