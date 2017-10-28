defmodule OpenBudgetWeb.UserView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  location "/users/:id"
  attributes [:email]

  has_one :active_budget,
    serializer: OpenBudgetWeb.BudgetView,
    include: false,
    identifiers: :when_included
end
