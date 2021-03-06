defmodule OpenBudget.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :description, :string
      add :category, :string

      timestamps()
    end

  end
end
