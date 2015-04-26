defmodule DoorApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :access_token, :string

      timestamps
    end
  end
end
