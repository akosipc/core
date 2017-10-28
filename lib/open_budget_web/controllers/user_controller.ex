defmodule OpenBudgetWeb.UserController do
  use OpenBudgetWeb, :controller

  alias Guardian.Plug
  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User
  alias OpenBudget.Budgets
  alias OpenBudget.Guardian.Authentication, as: GuardianAuth
  alias JaSerializer.Params

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    users = Authentication.list_users()
    render(conn, "index.json-api", data: users)
  end

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)

    case Authentication.create_user(attrs) do
      {:ok, user} ->
        budget_attrs = %{name: "Default Budget", description: "This is your budget"}
        {:ok, budget} = Budgets.create_budget(budget_attrs)
        Budgets.associate_user_to_budget(budget, user)
        {:ok, _, user} = Budgets.switch_active_budget(budget, user)

        conn = GuardianAuth.sign_in(conn, user)
        token = Plug.current_token(conn)

        conn
        |> put_status(201)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> put_resp_header("authorization", "Bearer #{token}")
        |> render("show.json-api", data: user, opts: [include: "active_budget"])
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(OpenBudgetWeb.ErrorView, "422.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    user = Authentication.get_user!(id)
    attrs = Params.to_attributes(data)

    with {:ok, %User{} = user} <-
        Authentication.update_user(user, attrs) do
      render(conn, "show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    with {:ok, %User{}} <- Authentication.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
