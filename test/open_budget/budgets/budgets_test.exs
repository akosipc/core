defmodule OpenBudget.BudgetsTest do
  use OpenBudget.DataCase

  alias OpenBudget.Authentication
  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account
  alias OpenBudget.Budgets.Budget

  @create_account_attrs %{name: "Sample Account", description: "This is a sample account", category: "Cash"}
  @update_account_attrs %{name: "Updated Sample Account", description: "This is an updated sample account", category: "Cash"}
  @invalid_account_attrs %{name: nil, description: nil, category: nil}

  @create_budget_attrs %{name: "Sample Budget", description: "This is a sample budget"}
  @update_budget_attrs %{name: "Updated Sample Budget", description: "This is an updated sample budget"}
  @invalid_budget_attrs %{name: nil, description: nil}

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@create_account_attrs)
      |> Budgets.create_account()

    account
  end

  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> Enum.into(@create_budget_attrs)
      |> Budgets.create_budget()

    budget
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "test@example.com", password: "password"})
      |> Authentication.create_user()

    user
  end

  describe "accounts" do
    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Budgets.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Budgets.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Budgets.create_account(@create_account_attrs)
      assert account.name == "Sample Account"
      assert account.description == "This is a sample account"
      assert account.category == "Cash"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_account(@invalid_account_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, account} = Budgets.update_account(account, @update_account_attrs)
      assert %Account{} = account
      assert account.name == "Updated Sample Account"
      assert account.description == "This is an updated sample account"
      assert account.category == "Cash"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_account(account, @invalid_account_attrs)
      assert account == Budgets.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Budgets.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Budgets.change_account(account)
    end
  end

  describe "budgets" do
    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Budgets.list_budgets() == [budget]
    end

    test "list_budgets/1 returns all budgets associated with the user" do
      user = user_fixture()
      budget = budget_fixture()
      Budgets.associate_user_to_budget(budget, user)
      assert Budgets.list_budgets(user) == [budget]
    end

    test "get_budget/1 returns the budget with given id" do
      budget = budget_fixture()
      assert Budgets.get_budget(budget.id) == {:ok, budget}
    end

    test "get_budget/1 with invalid budget returns nothing" do
      assert Budgets.get_budget(123) == {:error, "Budget not found"}
    end

    test "get_budget/2 returns the budget with given id and associated user" do
      user = user_fixture()
      budget = budget_fixture()
      Budgets.associate_user_to_budget(budget, user)
      assert Budgets.get_budget(budget.id, user) == {:ok, budget}
    end

    test "get_budget/2 with invalid budget and user association returns nothing" do
      user = user_fixture()
      budget = budget_fixture()
      assert Budgets.get_budget(budget.id, user) == {:error, "Budget not found"}
    end

    test "create_budget/1 with valid data creates a budget" do
      assert {:ok, %Budget{} = budget} = Budgets.create_budget(@create_budget_attrs)
      assert budget.name == "Sample Budget"
      assert budget.description == "This is a sample budget"
    end

    test "create_budget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_budget(@invalid_budget_attrs)
    end

    test "create_budget/2 with valid data creates a budget" do
      user = user_fixture()
      assert {:ok, %Budget{} = budget} = Budgets.create_budget(@create_budget_attrs, user)
      assert budget.name == "Sample Budget"
      assert budget.description == "This is a sample budget"
    end

    test "create_budget/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.create_budget(@invalid_budget_attrs, user)
    end

    test "update_budget/2 with valid data updates the budget" do
      budget = budget_fixture()
      assert {:ok, budget} = Budgets.update_budget(budget, @update_budget_attrs)
      assert %Budget{} = budget
      assert budget.name == "Updated Sample Budget"
      assert budget.description == "This is an updated sample budget"
    end

    test "update_budget/2 with invalid data returns error changeset" do
      budget = budget_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_budget(budget, @invalid_budget_attrs)
      assert {:ok, budget} == Budgets.get_budget(budget.id)
    end

    test "delete_budget/1 deletes the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{}} = Budgets.delete_budget(budget)
      assert Budgets.get_budget(budget.id) == {:error, "Budget not found"}
    end

    test "change_budget/1 returns a budget changeset" do
      budget = budget_fixture()
      assert %Ecto.Changeset{} = Budgets.change_budget(budget)
    end

    test "associate_user_to_budget/2 associates a user to a budget" do
      budget = budget_fixture()
      user = user_fixture()
      result = Budgets.associate_user_to_budget(budget, user)
      user_result = hd(result)
      assert Kernel.length(result) == 1
      assert user_result.email == "test@example.com"
    end

    test "associate_user_to_budget/2 associates a user to a budget with an existing user association" do
      budget = budget_fixture()
      existing_user = user_fixture(%{email: "existing@example.com", password: "existingpassword"})
      user = user_fixture()
      Budgets.associate_user_to_budget(budget, existing_user)
      result = Budgets.associate_user_to_budget(budget, user)
      user_result = hd(result)
      assert Kernel.length(result) == 2
      assert user_result.email == "existing@example.com"
    end

    test "switch_active_budget/2 switches the active budget when the budget is associated with the given user" do
      budget = budget_fixture()
      other_budget = budget_fixture(%{name: "Other Budget"})
      user = user_fixture()
      Budgets.associate_user_to_budget(budget, user)
      Budgets.associate_user_to_budget(other_budget, user)

      {:ok, budget, user} = Budgets.switch_active_budget(budget, user)
      assert user.active_budget_id == budget.id

      {:ok, other_budget, user} = Budgets.switch_active_budget(other_budget, user)
      assert user.active_budget_id == other_budget.id
    end

    test "switch_active_budget/2 returns an error when the budget is not associated with the given user" do
      budget = budget_fixture()
      other_budget = budget_fixture(%{name: "Other Budget"})
      user = user_fixture()
      Budgets.associate_user_to_budget(budget, user)

      {:ok, budget, user} = Budgets.switch_active_budget(budget, user)
      assert user.active_budget_id == budget.id

      assert Budgets.switch_active_budget(other_budget, user) == {:error, "Budget not found"}
      assert user.active_budget_id != other_budget.id
      assert user.active_budget_id == budget.id
    end
  end
end
