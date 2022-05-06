defmodule EbanxTakeHomeWeb.EventControllerTest do
  use EbanxTakeHomeWeb.ConnCase, async: true

  setup %{conn: conn} do
    EbanxTakeHome.Accounts.reset()
    %{conn: conn}
  end

  test "POST /event Transfer from existing account", %{conn: conn} do
    EbanxTakeHome.Accounts.add_account(%{
      id: 500,
      amount: 15
    })

    EbanxTakeHome.Accounts.add_account(%{
      id: 600,
      amount: 0
    })

    params = %{
      "type" => "transfer",
      "origin" => "500",
      "destination" => "600",
      "amount" => 15
    }

    conn = post(conn, Routes.event_path(conn, :create, params))
    origin = json_response(conn, 201)["origin"]
    destination = json_response(conn, 201)["destination"]

    assert origin["balance"] == "0"
    assert origin["id"] == 500

    assert destination["balance"] == "15"
    assert destination["id"] == 600
  end

  test "POST /event Transfer from non existing account", %{conn: conn} do
    EbanxTakeHome.Accounts.add_account(%{
      id: 300,
      amount: 0
    })

    params = %{
      "type" => "transfer",
      "origin" => "200",
      "destination" => "300",
      "amount" => 15
    }

    conn = post(conn, Routes.event_path(conn, :create, params))

    assert response(conn, 404) == "0"
  end

  test "POST /event Withdraw from non existing account", %{conn: conn} do
    params = %{
      "type" => "withdraw",
      "origin" => "400",
      "amount" => 10
    }

    conn = post(conn, Routes.event_path(conn, :create, params))

    assert response(conn, 404) == "0"
  end

  test "POST /event Withdraw from existing account", %{conn: conn} do
    EbanxTakeHome.Accounts.add_account(%{
      id: 400,
      amount: 20
    })

    params = %{
      "type" => "withdraw",
      "origin" => "400",
      "amount" => 5
    }

    conn = post(conn, Routes.event_path(conn, :create, params))
    result = json_response(conn, 201)["origin"]
    assert result["balance"] == "15"
    assert result["id"] == 400
  end

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

  test "POST /event deposit in a existent account", %{conn: conn} do
    EbanxTakeHome.Accounts.add_account(%{
      id: 200,
      amount: 10
    })

    params = %{
      "type" => "deposit",
      "destination" => "200",
      "amount" => 10
    }

    conn = post(conn, Routes.event_path(conn, :create, params))

    result = json_response(conn, 201)["destination"]
    assert result["balance"] == "20"
    assert result["id"] == 200
  end
end
