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

  def gists_create(description, is_public, file_name, content) do
    body = %{ "description": description,
              "public": is_public,
              "files": %{
                "#{file_name}": %{
                  "content": content
                           }
              }
            }

    response = Gateway.post("/gists", Poison.encode!(body)) |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_edit(id, file_name, content) do
    body = %{"files": %{
                "#{file_name}": %{
                  content: content
                           }
                    }
             }
    response = Gateway.patch("/gists/#{id}", Poison.encode!(body)) |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_star(id) do
    response = Gateway.put("/gists/#{id}/star", "") |> elem(1)
    response.status_code == 204
  end

  def gists_unstar(id) do
    response = Gateway.delete("/gists/#{id}/star") |> elem(1)
    response.status_code == 204
  end

  def gists_starred?(id) do
    response = Gateway.get("/gists/#{id}/star") |> elem(1)
    response.status_code == 204
  end

  def gists_destroy(id) do
    response = Gateway.delete("/gists/#{id}") |> elem(1)
    response.status_code == 204
  end

  def gists_comments(id) do
    response = Gateway.get("/gists/#{id}/comments") |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_comments(gist_id, comment_id) do
    response = Gateway.get("/gists/#{gist_id}/comments/#{comment_id}")
    Poison.decode!(response.body)
  end

  def gists_comments_create(id, comment) do
    body = %{ "body": comment}
    response = Gateway.post("/gists/#{id}/comments", Poison.encode!(body)) |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_comments_edit(gist_id, comment_id, comment) do
    body = %{ "body": comment }
    response = Gateway.patch("/gists/#{gist_id}/comments/#{comment_id}", Poison.encode!(body)) |> elem(1)
    Poison.decode!(response.body)
  end

  def gists_comments_delete(gist_id, comment_id) do
    response = Gateway.delete("/gists/#{gist_id}/comments/#{comment_id}") |> elem(1)
    response.status_code == 204
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
