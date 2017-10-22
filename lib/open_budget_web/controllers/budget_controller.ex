defmodule OpenBudgetWeb.BudgetController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Repo
  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Budget
  alias JaSerializer.Params
  alias Guardian.Plug

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    current_user = Plug.current_resource(conn)
    budgets = Budgets.list_budgets(current_user)
    render(conn, "index.json-api", data: budgets)
  end

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Budget{} = budget} <-
        Budgets.create_budget(attrs) do
      current_user = Plug.current_resource(conn)
      Budgets.associate_user_to_budget(budget, current_user)
      budget =
        budget
        |> Repo.preload(:users)

      conn
      |> put_status(:created)
      |> put_resp_header("location", budget_path(conn, :show, budget))
      |> render("show.json-api", data: budget, opts: [include: "users"])
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} -> render(conn, "show.json-api", data: budget)
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def update(conn, %{"id" => id, "data" => data}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} ->
        budget = Repo.preload(budget, :users)
        attrs = Params.to_attributes(data)

        case Budgets.update_budget(budget, attrs) do
          {:ok, budget} -> render(conn, "show.json-api", data: budget, opts: [include: "users"])
          {:error, _} ->
            conn
            |> put_status(422)
            |> render(OpenBudgetWeb.ErrorView, "422.json-api")
        end
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} ->
        case Budgets.delete_budget(budget) do
          {:ok, _} -> send_resp(conn, :no_content, "")
          {:error, _} ->
            conn
            |> put_status(422)
            |> render(OpenBudgetWeb.ErrorView, "422.json-api")
        end
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end
end
