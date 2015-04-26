defmodule DoorApi.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", DoorApi.Api do
    pipe_through :api
    scope "v1", V1 do
      post "session", SessionController, :create
    end
  end
end
