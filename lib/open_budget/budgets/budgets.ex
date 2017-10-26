defmodule OpenBudget.Budgets do
  @moduledoc """
  The Budgets context.
  """

  import Ecto.Query, warn: false
  alias OpenBudget.Repo

  alias OpenBudget.Budgets.Account
  alias OpenBudget.Budgets.Budget
  alias OpenBudget.Budgets.BudgetUser
  alias OpenBudget.Authentication.User

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Returns a list of accounts associated with the given budget.

  ## Examples

      iex> list_accounts(budget)
      [%Account{}, ...]
  """
  def list_accounts(budget) do
    Repo.all(from a in Account,
            preload: [:budget],
            left_join: b in Budget, on: b.id == a.budget_id,
            where: b.id == ^budget.id)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  @doc """
  Adds an association between a Budget and an Account.

  ## Examples
      iex> associate_account_to_budget(account, budget)
      {:ok, %Budget{}, %Account{}}

      iex> associate_account_to_budget(account, %Budget{})
      {:error, %Ecto.Changeset{}}
  """
  def associate_account_to_budget(%Account{} = account, %Budget{} = budget) do
    changeset =
      account
      |> Account.budget_association_changeset(%{budget_id: budget.id})
      |> Repo.update()

    case changeset do
      {:ok, account} ->
        account = Repo.preload(account, :budget)
        {:ok, account}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Returns the list of budgets.

  ## Examples

      iex> list_budgets()
      [%Budget{}, ...]

  """
  def list_budgets do
    Repo.all(Budget)
  end

  @doc """
  Returns the list of budgets associated with the user specified.

  ## Examples

      iex> list_budgets(user)
      [%Budget{}, ...]

  """
  def list_budgets(user) do
    Repo.all(from b in Budget,
            left_join: bu in BudgetUser, on: b.id == bu.budget_id,
            left_join: u in User, on: u.id == bu.user_id,
            where: u.id == ^user.id)
  end

  @doc """
  Gets a single budget.

  ## Examples

      iex> get_budget(123)
      {:ok, %Budget{}}

      iex> get_budget(456)
      {:error, "Budget not found"}

  """
  def get_budget(id) do
    budget = Repo.get!(Budget, id)
    {:ok, budget}
  rescue
    Ecto.NoResultsError -> {:error, "Budget not found"}
  end

  @doc """
  Gets a single budget that's associated with the given user.

  Raises `Ecto.NoResultsError` if the Budget does not exist.

  ## Examples

      iex> get_budget(123, user)
      {:ok, %Budget{}}

      iex> get_budget(456, user)
      {:error, "Budget not found"}

  """
  def get_budget(id, user) do
    budget = Repo.one!(from b in Budget,
                      left_join: bu in BudgetUser, on: b.id == bu.budget_id,
                      left_join: u in User, on: u.id == bu.user_id,
                      where: u.id == ^user.id and b.id == ^id)
    {:ok, budget}
  rescue
    Ecto.NoResultsError -> {:error, "Budget not found"}
  end

  @doc """
  Creates a budget.

  ## Examples

      iex> create_budget(%{field: value})
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a budget and associate it with the given user.

  ## Examples

      iex> create_budget(%{field: value}, user)
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value}, user)
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs, user) do
    changeset =
      %Budget{}
      |> Budget.changeset(attrs)
      |> Repo.insert()

    case changeset do
      {:ok, budget} ->
        associate_user_to_budget(budget, user)
        budget = Repo.preload(budget, :users)
        {:ok, budget}
      {:error, bad_changeset} ->
        {:error, bad_changeset}
    end
  end

  @doc """
  Updates a budget.

  ## Examples

      iex> update_budget(budget, %{field: new_value})
      {:ok, %Budget{}}

      iex> update_budget(budget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget(%Budget{} = budget, attrs) do
    budget
    |> Budget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Budget.

  ## Examples

      iex> delete_budget(budget)
      {:ok, %Budget{}}

      iex> delete_budget(budget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget(%Budget{} = budget) do
    Repo.delete(budget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget changes.

  ## Examples

      iex> change_budget(budget)
      %Ecto.Changeset{source: %Budget{}}

  """
  def change_budget(%Budget{} = budget) do
    Budget.changeset(budget, %{})
  end

  @doc """
  Adds an association between a Budget and a User.

  ## Examples
      iex> associate_user_to_budget(budget, user)
      [%OpenBudget.Authentication.User{}]
  """
  def associate_user_to_budget(%Budget{} = budget, %User{} = user) do
    %BudgetUser{}
    |> BudgetUser.changeset(%{budget_id: budget.id, user_id: user.id})
    |> Repo.insert()
    Repo.all(from u in User,
            preload: [:budgets],
            left_join: bu in BudgetUser, on: u.id == bu.user_id,
            left_join: b in Budget, on: b.id == bu.budget_id,
            where: b.id == ^budget.id)
  end

  def switch_active_budget(%Budget{} = budget, %User{} = user) do
    budget = Repo.one(from b in Budget,
                      left_join: bu in BudgetUser, on: b.id == bu.budget_id,
                      left_join: u in User, on: u.id == bu.user_id,
                      where: b.id == ^budget.id and u.id == ^user.id)

    case budget do
      nil -> {:error, "Budget not found"}
      _ ->
        changeset =
          user
          |> User.active_budget_changeset(%{active_budget_id: budget.id})
          |> Repo.update()

        case changeset do
          {:ok, user} ->
            user = Repo.preload(user, :active_budget)
            {:ok, budget, user}
          {:error, _} ->
            {:error, "Failed to switch active budget"}
        end
    end
  end
end
