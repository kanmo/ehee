defmodule Ehee.Gists do
  import Ehee
  alias Ehee.Gateway

  def gists(credential) do
    get("/gists", credential)
  end

  def gists(credential, id) do
    get("/gists/#{id}", credential)
  end

  def gists_user(credential, username) do
    get("/users/#{username}/gists", credential)
  end

  def gists_public(credential) do
    get("/gists/public", credential, [], [pagination: :stream])
  end

  def gists_create(credential, description, is_public, file_name, content) do
    body = %{ "description": description,
              "public": is_public,
              "files": %{
                "#{file_name}": %{
                  "content": content
                           }
              }
            }

    post("/gists", credential, body)
  end

  def gists_edit(credential, id, file_name, content) do
    body = %{"files": %{
                "#{file_name}": %{
                  "content": content
                           }
                    }
            }

    patch("/gists/#{id}", credential, body)
  end

  def gists_star(credential, id) do
    put("/gists/#{id}/star", credential)
  end

  def gists_unstar(credential, id) do
    delete("/gists/#{id}/star", credential)
  end

  def gists_starred?(credential, id) do
    resp = get("/gists/#{id}/star", credential)
    resp |> elem(0) == 204
  end

  def gists_destroy(credential, id) do
    delete("/gists/#{id}", credential)
  end

  def gists_comments(credential, id) do
    get("/gists/#{id}/comments", credential)
  end

  def gists_comments(credential, gist_id, comment_id) do
    get("/gists/#{gist_id}/comments/#{comment_id}", credential)
  end

  def gists_comments_create(credential, id, comment) do
    body = %{ "body": comment}
    post("/gists/#{id}/comments", credential, body)
  end

  def gists_comments_edit(credential, gist_id, comment_id, comment) do
    body = %{ "body": comment }
    patch("/gists/#{gist_id}/comments/#{comment_id}", credential, body)
  end

  def gists_comments_delete(credential, gist_id, comment_id) do
    delete("/gists/#{gist_id}/comments/#{comment_id}",  credential)
  end

  defp fetch_gists(cred, url) do
    gists = get(url)

    links = response.headers
    |> extract_links
    |> parse_links

    {gists, links["next"]}
  end

end
