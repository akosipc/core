defmodule OpenBudget.Repo.Migrations.AddBudgetIdToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :budget_id, references(:budgets, on_delete: :delete_all)
    end
  end
end
