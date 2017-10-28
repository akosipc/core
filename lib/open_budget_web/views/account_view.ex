defmodule OpenBudgetWeb.AccountView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  location "/accounts/:id"
  attributes [:name, :description, :category]
end
