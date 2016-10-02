defmodule Ehee.Gists do
  import Ehee
  alias Ehee.Credential
  @moduledoc """
  The Gist Webhooks API
  """

  @doc """
  List authenticated users gists

  ## Example
      Ehee.Gists.gist(credential)

  More info at: https://developer.github.com/v3/gists/#list-a-users-gists
  """
  @spec gists(Credential.t) :: Ehee.response
  def gists(credential) do
    get("/gists", credential)
  end

  @doc """
  List public gists for specified user

  ## Example
      Ehee.Gists.gists_user(credential, "username")

  More info at: https://developer.github.com/v3/gists/#list-a-users-gists
  """
  @spec gists_user(Credential.t, binary) :: Ehee.response
  def gists_user(credential, username) do
    get("/users/#{username}/gists", credential)
  end

  @doc """
  List all public gists

  ## Example
      Ehee.Gists.gists_public(credential)

  More info at: https://developer.github.com/v3/gists/#list-all-public-gists
  """
  @spec gists_public(Credential.t) :: Ehee.response
  def gists_public(credential) do
    get("/gists/public", credential, [], [pagination: :stream])
  end

  @doc """
  Get a single gist

  ## Example
      Ehee.Gists.gists(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#get-a-single-gist
  """
  @spec gists(Credential.t, binary | integer) :: Ehee.response
  def gists(credential, id) do
    get("/gists/#{id}", credential)
  end

  @doc """
  Create a gist

  ## Example
      Ehee.gist_create(credential, "gist description", true, "file1", "sample gist")

  More info at: https://developer.github.com/v3/gists/#create-a-gist
  """
  @spec gists_create(Credential.t, binary, boolean, binary, binary) :: Ehee.response
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

  @doc """
  Edit a gist

  ## Example
      Ehee.gist.gist_edit(credential, 1234567, "files", "sample gist")

  More info at: https://developer.github.com/v3/gists/#edit-a-gist
  """
  @spec gists_edit(Credential.t, binary | integer, binary, binary) :: Ehee.response
  def gists_edit(credential, id, file_name, content) do
    body = %{"files": %{
                "#{file_name}": %{
                  "content": content
                           }
                    }
            }

    patch("/gists/#{id}", credential, body)
  end

  @doc """
  Star a gist

  ## Example
      Ehee.gists_star(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#star-a-gist
  """
  @spec gists_star(Credential.t, binary | integer) :: Ehee.response
  def gists_star(credential, id) do
    put("/gists/#{id}/star", credential)
  end

  @doc """
  Unstar a gist

  ## Example
      Ehee.gists_unstar(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#unstar-a-gist
  """
  @spec gists_unstar(Credentail.t, binary | integer) :: Ehee.response
  def gists_unstar(credential, id) do
    delete("/gists/#{id}/star", credential)
  end

  @doc """
  Check if a gist is starred

  ## Example
      Ehee.gists_starred?(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#check-if-a-gist-is-starred
  """
  @spec gists_starred?(Credential.t, binary | integer) :: boolean
  def gists_starred?(credential, id) do
    resp = get("/gists/#{id}/star", credential)
    resp |> elem(0) == 204
  end

  @doc """
  Delete a gist

  ## Example
      Ehee.gists_destroy(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#delete-a-gist
  """
  @spec gists_destroy(Credential.t, binary | integer) :: Ehee.response
  def gists_destroy(credential, id) do
    delete("/gists/#{id}", credential)
  end

  @doc """
  List gist on a gist

  ## Example
      Ehee.gists_comments(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
  """
  @spec gists_comments(Credentail.t, binary | integer) :: Ehee.response
  def gists_comments(credential, id) do
    get("/gists/#{id}/comments", credential)
  end

  @doc """
  Get a single comment

  ## Example
      Ehee.gists_comments(credential, 1234567, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#get-a-single-comment
  """
  @spec gists_comments(Credentail.t, binary | integer, binary | integer) :: Ehee.response
  def gists_comments(credential, gist_id, comment_id) do
    get("/gists/#{gist_id}/comments/#{comment_id}", credential)
  end

  @doc """
  Create a comment

  ## Example
      Ehee.gists_comments_create(credential, 1234567, "gist comment!")

  More info at: https://developer.github.com/v3/gists/comments/#create-a-comment
  """
  @spec gists_comments_create(Credentail.t, binary | integer, binary) :: Ehee.response
  def gists_comments_create(credential, id, comment) do
    body = %{ "body": comment}
    post("/gists/#{id}/comments", credential, body)
  end

  @doc """
  Edit a comment

  ## Example
      Ehee.gists_coments_edit(credential, 1234567, 1234567, "gist comment!")

  More info at: https://developer.github.com/v3/gists/comments/#edit-a-comment
  """
  @spec gists_comments_edit(Credentail.t, binary | integer, binary | integer, binary) :: Ehee.response
  def gists_comments_edit(credential, gist_id, comment_id, comment) do
    body = %{ "body": comment }
    patch("/gists/#{gist_id}/comments/#{comment_id}", credential, body)
  end

  @doc """
  Delete a comment

  ## Example
      Ehee.gists_comments_delete(credential, 1234567, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#delete-a-comment
  """
  @spec gists_comments_delete(Credential.t, binary | integer, binary | integer) :: Ehee.response
  def gists_comments_delete(credential, gist_id, comment_id) do
    delete("/gists/#{gist_id}/comments/#{comment_id}",  credential)
  end
end
