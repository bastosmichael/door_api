defmodule DoorApi.Api.V1.SessionController do
  require IEx
  use Phoenix.Controller
  plug :action

  def create(conn, %{"authorizationCode" => auth_code, "provider" => "github-oauth2"}) do
    DoorApi.Github.get_token!(code: auth_code)
    |> _get_user_info
    |> _find_user
    |> _update_or_create_user
    |> _set_session(conn)
    |> _send_response
  end

  defp _get_user_info([access_token: nil]), do: {:error}

  defp _get_user_info(oauth2_token) do
    %{ access_token: access_token } = oauth2_token

    %{ "login" => username, "name" => name } = OAuth2.AccessToken.get!(oauth2_token, "/user")
    %{ access_token: access_token, username: username, name: name }
  end

  defp _find_user({:error}), do: {:error}

  defp _find_user(user_details) do
    %{ username: username } = user_details
    user = DoorApi.Queries.User.find_by_username(username)

    %{ details: user_details, user: user }
  end

  defp _update_or_create_user(%{ details: user_details, user: nil }) do
    changeset = DoorApi.User.changeset(%DoorApi.User{}, user_details)

    DoorApi.Repo.insert(changeset)
  end

  defp _update_or_create_user(%{ details: user_details, user: user }) do
    changeset = DoorApi.User.changeset(user, user_details)

    DoorApi.Repo.update(changeset)
  end


  defp _set_session(user, conn) do
    put_session conn, :user_id, user.id
    {conn, user}
  end

  defp _send_response({conn, user}) do
    conn
    |> put_status(:created)
    |> json(DoorApi.UserSerializer.to_map(user))
  end
end
