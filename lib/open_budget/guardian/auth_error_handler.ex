defmodule OpenBudget.Guardian.AuthErrorHandler do
  @moduledoc """
  Handler required by Guardian pipeline
  """
  use OpenBudgetWeb, :controller

  def auth_error(conn, _error, _opts) do
    conn
    |> put_status(401)
    |> render(OpenBudgetWeb.ErrorView, "401.json-api")
    |> halt
  end
end
