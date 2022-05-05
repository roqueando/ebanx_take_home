defmodule EbanxTakeHomeWeb.ResetController do
  use EbanxTakeHomeWeb, :controller

  def reset(conn, _params) do
    EbanxTakeHome.Accounts.reset()

    conn
    |> resp(200, "OK")
  end
end
