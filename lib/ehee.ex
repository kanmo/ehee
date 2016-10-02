defmodule Ehee do
  use HTTPoison.Base
  @endpoint "https://api.github.com"

  @type response :: {integer, any}

  @spec handle_response(HTTPoison.Response.t) :: response
  def handle_response(%HTTPoison.Response{status_code: 200, body: body}), do: Poison.decode!(body)
  def handle_response(%HTTPoison.Response{status_code: status_code, body: body}), do: { status_code, body }

  def post(path, credential, body \\ "") do
    url = url(path)
    request!(:post, url, Poison.encode!(body), authorization_header(credential.auth, []), [])
    |> handle_response
  end

  def patch(path, credential, body \\ "") do
    url = url(path)
    request!(:post, url, Poison.encode!(body), authorization_header(credential.auth, []), [])
    |> handle_response
  end

  def put(path, credential, body \\ "") do
    url = url(path)
    request!(:put, url, Poison.encode!(body), authorization_header(credential.auth, []), [])
    |> handle_response
  end

  def delete(path, credential, body \\ "") do
    url = url(path)
    request!(:delete, url, Poison.encode!(body), authorization_header(credential.auth, []), [])
    |> handle_response
  end

  def get(path, credential, params \\ [], options \\ []) do
    url = url(path)# |> merge_uri_params
    case pagination(options) do
      :nil -> request_stream(:get, url, credential)
      :stream -> request_stream(:get, url, credential)
    end
  end

  defp pagination(options) do
    Keyword.get(options, :pagination, :nil)
  end

  defp request_stream(method, url, credential, body \\ "", override \\ nil) do
    request_with_pagination(method, url, credential.auth, body)
    |> stream_if_needed(override)
  end

  defp stream_if_needed(result = {status_code, _}, _) when is_number(status_code), do: result

  defp stream_if_needed({body, nil, _}, _), do: body

  defp stream_if_needed({body, _, _}, :one_page), do: body

  defp stream_if_needed(initial_results, _) do
    Stream.resource(
      fn -> initial_results end,
      &handle_stream/1,
      fn _ -> nil end)
  end

  def request_with_pagination(method, url, auth, body \\ "") do
    resp = request!(method, url, Poison.encode!(body), authorization_header(auth, []), [])
    case handle_response(resp) do
      x when is_tuple(x) -> x
      _ -> pagination_tuple(resp, auth)
    end
  end

  defp handle_stream({[], nil, _}), do: {:halt, nil}
  defp handle_stream({[], next, auth}) do
    request_with_pagination(:get, next, auth, "")
    |> handle_stream
  end
  # defp handle_stream({items, next, auth}) when is_list(items) do
  #   {items, {[], next, auth}}
  # end
  defp handle_stream({item, next, auth}) do
    {[item], {[], next, auth}}
  end

  defp pagination_tuple(%HTTPoison.Response{headers: headers} = resp, auth) do
    {handle_response(resp), next_link(headers), auth}
  end

  defp next_link(headers) do
    for {"Link", link_header} <- headers, links <- String.split(link_header, ",") do
      Regex.named_captures(~r/<(?<link>.*)>;\s*rel=\"(?<rel>.*)\"/, links)
      |> case do
        %{"link" => link, "rel" => "next"} -> link
        _ -> nil
      end
    end
    |> Enum.filter(&(not is_nil(&1)))
    |> List.first
  end


  defp merge_uri_params(uri, []), do: uri

  defp url(path) do
    @endpoint <> path
  end

  @spec authorization_header(Credential.auth, list) :: list
  def authorization_header(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "token #{token}"}]
  end

end
