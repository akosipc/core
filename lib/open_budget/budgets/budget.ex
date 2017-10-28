defmodule OpenBudget.Budgets.Budget do
  @moduledoc """
  Budgets are where most budget-related data should be associated with.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Budgets.Account
  alias OpenBudget.Budgets.Budget
  alias OpenBudget.Budgets.BudgetUser
  alias OpenBudget.Authentication.User

  schema "budgets" do
    field :description, :string
    field :name, :string
    many_to_many :users, User,
                       join_through: BudgetUser,
                       unique: true,
                       on_delete: :delete_all
    has_many :accounts, Account, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Budget{} = budget, attrs) do
    budget
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
