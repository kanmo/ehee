defmodule Ehee.Gateway do
  use HTTPoison.Base

  @endpoint "https://api.github.com"

  def endpoint do
    @endpoint
  end



  defp process_url(url) do
    @endpoint <> url
  end

  defp process_request_body(body) do
    body
  end

  defp process_request_headers(%{access_token: access_token}, headers) do
    headers ++ [
      {"Authorization", "Basic #{:base64.encode(credentials)}"}
    ]
  end

  defp credentials do
    "#{Application.get_env(:ehee, :access_token)}:x-oauth-basic"
  end

end
