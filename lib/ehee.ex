defmodule Ehee do
  use HTTPoison.Base
  @endpoint "https://api.github.com"

  def post(path, credential, body \\ "") do
    url = url(path)
    request!(:post, url, Poison.encode!(body), authorization_headers(credential.auth, []), [])
    |> handle_response
  end

  def patch(path, credential, body \\ "") do
    url = url(path)
    request!(:post, url, Poison.encode!(body), authorization_headers(credential.auth, []), [])
    |> handle_response
  end

  def put(path, credential, body \\ "") do
    url = url(path)
    request!(:put, url, Poison.encode!(body), authorization_headers(credential.auth, []), [])
    |> handle_response
  end

  def delete(path, credential, body \\ "") do
    url = url(path)
    request!(:delete, url, Poison.encode!(body), authorization_headers(credential.auth, []), [])
    |> handle_response
  end

  # TODO body -> params
  def get(path, credential, body \\ []) do
    url = url(path)# |> merge_uri_params
    request!(:get, url, Poison.encode!(body), authorization_headers(credential.auth, []), [])
    |> handle_response
  end

  defp merge_uri_params(uri, []), do: uri

  defp url(path) do
    @endpoint <> path
  end

  defp authorization_headers(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "token #{token}"}]
  end

  defp handle_response(%HTTPoison.Response{status_code: 200, body: body}), do: body
  defp handle_response(%HTTPoison.Response{status_code: status_code, body: body}), do: { status_code, body }
end
