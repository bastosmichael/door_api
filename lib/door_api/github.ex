defmodule DoorApi.Github do
  @credentials Application.get_env(:door_api, __MODULE__)
  use OAuth2.Strategy

  def new do
    OAuth2.new([
      strategy: __MODULE__,
      client_id: @credentials[:client_id],
      client_secret: @credentials[:client_secret],
      redirect_uri: @credentials[:redirect_uri],
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token"
    ])
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(new(), params, headers)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
