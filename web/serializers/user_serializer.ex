defmodule DoorApi.UserSerializer do
  use Remodel
  @instance_root :user

  attributes [:id, :username]
end
