defmodule OpenBudget.Budgets.Account do
  @moduledoc """
  Accounts are the representation
  of a user's real-life accounts.

  ## Examples

      Petty Cash
      BPI Savings
      BDO Checking
      HSBC Visa
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Budgets.Account
  alias OpenBudget.Budgets.Budget

  schema "accounts" do
    field :description, :string
    field :name, :string
    field :category, :string
    belongs_to :budget, Budget

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :description, :category])
    |> validate_required([:name, :description, :category])
  end
end
