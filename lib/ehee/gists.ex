defmodule Ehee.Gists do
  import Ehee
  alias Ehee.Credential
  @moduledoc """
  The Gist Webhooks API
  """

  @doc """
  List authenticated users gists

  ## Example
      Ehee.Gists.list(credential)

  More info at: https://developer.github.com/v3/gists/#list-a-users-gists
  """
  @spec list(Credential.t) :: Ehee.response
  def list(credential) do
    get("/gists", credential)
  end

  @doc """
  List public gists for specified user

  ## Example
      Ehee.Gists.list_users(credential, "username")

  More info at: https://developer.github.com/v3/gists/#list-a-users-gists
  """
  @spec list_users(Credential.t, binary) :: Ehee.response
  def list_users(credential, username) do
    get("/users/#{username}/gists", credential)
  end

  @doc """
  List all public gists

  ## Example
      Ehee.Gists.list_public(credential)

  More info at: https://developer.github.com/v3/gists/#list-all-public-gists
  """
  @spec list_public(Credential.t) :: Ehee.response
  def list_public(credential) do
    get("/gists/public", credential, [], [pagination: :stream])
  end

  @doc """
  Get a single gist

  ## Example
      Ehee.Gists.show(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#get-a-single-gist
  """
  @spec show(Credential.t, binary | integer) :: Ehee.response
  def show(credential, id) do
    get("/gists/#{id}", credential)
  end

  @doc """
  Create a gist

  ## Example
      Ehee.Gists.create(credential, "gist description", true, "file1", "sample gist")

  More info at: https://developer.github.com/v3/gists/#create-a-gist
  """
  @spec create(Credential.t, binary, boolean, binary, binary) :: Ehee.response
  def create(credential, description, is_public, file_name, content) do
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
      Ehee.Gists.edit(credential, 1234567, "files", "sample gist")

  More info at: https://developer.github.com/v3/gists/#edit-a-gist
  """
  @spec edit(Credential.t, binary | integer, binary, binary) :: Ehee.response
  def edit(credential, id, file_name, content) do
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
      Ehee.Gists.star(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#star-a-gist
  """
  @spec star(Credential.t, binary | integer) :: Ehee.response
  def star(credential, id) do
    put("/gists/#{id}/star", credential)
  end

  @doc """
  Unstar a gist

  ## Example
      Ehee.Gists.unstar(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#unstar-a-gist
  """
  @spec unstar(Credentail.t, binary | integer) :: Ehee.response
  def unstar(credential, id) do
    delete("/gists/#{id}/star", credential)
  end

  @doc """
  Check if a gist is starred

  ## Example
      Ehee.Gists.starred?(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#check-if-a-gist-is-starred
  """
  @spec starred?(Credential.t, binary | integer) :: boolean
  def starred?(credential, id) do
    resp = get("/gists/#{id}/star", credential)
    resp |> elem(0) == 204
  end

  @doc """
  Delete a gist

  ## Example
      Ehee.Gists.destroy(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/#delete-a-gist
  """
  @spec destroy(Credential.t, binary | integer) :: Ehee.response
  def destroy(credential, id) do
    delete("/gists/#{id}", credential)
  end

  @doc """
  List gist on a gist

  ## Example
      Ehee.Gists.list_comments(credential, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
  """
  @spec list_comments(Credentail.t, binary | integer) :: Ehee.response
  def list_comments(credential, id) do
    get("/gists/#{id}/comments", credential)
  end

  @doc """
  Get a single comment

  ## Example
      Ehee.Gists.show_comment(credential, 1234567, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#get-a-single-comment
  """
  @spec show_comment(Credentail.t, binary | integer, binary | integer) :: Ehee.response
  def show_comment(credential, gist_id, comment_id) do
    get("/gists/#{gist_id}/comments/#{comment_id}", credential)
  end

  @doc """
  Create a comment

  ## Example
      Ehee.Gists.create_comment(credential, 1234567, "gist comment!")

  More info at: https://developer.github.com/v3/gists/comments/#create-a-comment
  """
  @spec create_comment(Credentail.t, binary | integer, binary) :: Ehee.response
  def create_comment(credential, id, comment) do
    body = %{ "body": comment}
    post("/gists/#{id}/comments", credential, body)
  end

  @doc """
  Edit a comment

  ## Example
      Ehee.Gists.edit_coment(credential, 1234567, 1234567, "gist comment!")

  More info at: https://developer.github.com/v3/gists/comments/#edit-a-comment
  """
  @spec edit_comment(Credentail.t, binary | integer, binary | integer, binary) :: Ehee.response
  def edit_comment(credential, gist_id, comment_id, comment) do
    body = %{ "body": comment }
    patch("/gists/#{gist_id}/comments/#{comment_id}", credential, body)
  end

  @doc """
  Delete a comment

  ## Example
      Ehee.Gists.delete_comment(credential, 1234567, 1234567)

  More info at: https://developer.github.com/v3/gists/comments/#delete-a-comment
  """
  @spec delete_comment(Credential.t, binary | integer, binary | integer) :: Ehee.response
  def delete_comment(credential, gist_id, comment_id) do
    delete("/gists/#{gist_id}/comments/#{comment_id}",  credential)
  end
end
