defmodule OpenBudgetWeb.AccountView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  location "/accounts/:id"
  attributes [:name, :description, :category]

  has_one :budget,
    serializer: OpenBudgetWeb.BudgetView,
    include: false,
    identifiers: :when_included
end
