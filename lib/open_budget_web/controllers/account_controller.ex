defmodule OpenBudgetWeb.AccountController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account
  alias JaSerializer.Params
  alias Guardian.Plug
  alias OpenBudget.Repo

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    current_user = Plug.current_resource(conn)
    current_user = Repo.preload(current_user, [:active_budget])
    accounts = Budgets.list_accounts(current_user.active_budget)
    render(conn, "index.json-api", data: accounts)
  end

  def create(conn, %{"data" => data}) do
    current_user = Plug.current_resource(conn)
    current_user = Repo.preload(current_user, [:active_budget])
    attrs = Params.to_attributes(data)

    case Budgets.create_account(attrs, current_user.active_budget) do
      {:ok, account} ->
        conn
        |> put_status(201)
        |> put_resp_header("location", account_path(conn, :show, account))
        |> render("show.json-api", data: account, opts: [include: "budget"])
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(OpenBudgetWeb.ErrorView, "422.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Plug.current_resource(conn)
    current_user = Repo.preload(current_user, [:active_budget])
    case Budgets.get_account(id, current_user.active_budget) do
      {:ok, account} -> render(conn, "show.json-api", data: account)
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def update(conn, %{"id" => id, "data" => data}) do
    attrs = Params.to_attributes(data)
    {:ok, account} = Budgets.get_account(id)

    with {:ok, %Account{} = account} <-
      Budgets.update_account(account, attrs) do
      render(conn, "show.json-api", data: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, account} = Budgets.get_account(id)
    with {:ok, %Account{}} <- Budgets.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
