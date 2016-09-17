defmodule Ehee.Gists do
  alias Ehee.Gateway

  def gists do
    response = Gateway.get("/gists") |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_user(username) do
    response = Gateway.get("/users/#{username}/gists") |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_public do
    Stream.resource(fn -> fetch_gists("/gists/public") end, &process_page/1, fn _ -> end)
    |> Enum.take(100)
  end

  def gists(id) do
    response = Gateway.get("/gists/#{id}") |> elem(1)
    Poison.decode!(response.body)
  end


  def gists_create do
    body = %{ "description": "the description for this gist",
              "public": true,
              "files": %{
                "file1.txt": %{
                  "content": "gist contents"
                           }
              }
            }

    response = Gateway.post("/gists", Poison.encode!(body)) |> elem(1)
    Poison.decode!(response.body)
  end

  defp fetch_gists(url) do
    response = Gateway.get(url) |> elem(1)
    gists = Poison.decode!(response.body)

    links = response.headers
    |> extract_links
    |> parse_links

    {gists, links["next"]}
  end

  defp extract_links(headers) do
    [{_, value} | _] = Enum.filter(headers, &(elem(&1, 0) == "Link"))
    value
  end

  defp parse_links(links_string) do
    links = String.split(links_string, ", ")

    Enum.map(links, fn link ->
      [_,name] = Regex.run(~r{rel="([a-z]+)"}, link)
      [_,url] = Regex.run(~r{<([^>]+)>}, link)
      short_url = String.replace(url, Gateway.endpoint, "")

      {name, short_url}
    end) |> Enum.into(%{})
  end

  defp process_page({nil, nil}) do
    {:halt, nil}
  end

  defp process_page({nil, next_page_url}) do
    next_page_url
    |> fetch_gists
    |> process_page
  end

  defp process_page({items, next_page_url}) do
    {items, {nil, next_page_url}}
  end


end
