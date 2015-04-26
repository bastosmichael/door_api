defmodule DoorApi.Queries.User do
  import Ecto.Query
  alias DoorApi.User

  def find_by_username(username) do
    query = from users in User,
            where: users.username == ^username

    DoorApi.Repo.one query
  end
end
