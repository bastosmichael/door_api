defmodule DoorApi.User do
  use DoorApi.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :access_token, :string

    timestamps
  end

  @required_fields ~w(name username access_token)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_unique(:username, on: DoorApi.Repo)
  end
end
