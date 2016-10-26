defmodule Ehee.Issues do
  import Ehee
  alias Ehee.Credential
  @moduledoc """
  The Issues Webhooks API
  """

  def list(credential) do
    get("/issues", credential)
  end

  @doc """
  List issues for a repository

  ## Example
      Ehee.Issues.list(credential, "username", "repositoryname")

  More info at:https://developer.github.com/v3/issues/#list-issues-for-a-repository
  """
  @spec list(Credential.t, binary, binary, Keyword.t) :: Ehee.response
  def list(credential, owner, repo, options \\ []) do
    params = %{milestone: Keyword.get(options, :milestone),
               state: Keyword.get(options, :state),
               assignee: Keyword.get(options, :assignee),
               creator: Keyword.get(options, :creator),
               mentioned: Keyword.get(options, :mentioned),
               labels: Keyword.get(options, :labels),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction),
               since: Keyword.get(options, :since)
              }
    get("/repos/#{owner}/#{repo}/issues", credential, [], params: params)
  end

  @doc """
  Get a single issue

  ## Example
      Ehee.Issues.show(credential, "username", "repositoryname", 1)

  More info at: https://developer.github.com/v3/issues/#get-a-single-issue
  """
  @spec show(Credential.t, binary, binary, integer ) :: Ehee.response
  def show(credential, owner, repo, no) do
    get("/repos/#{owner}/#{repo}/issues/#{no}", credential)
  end

  @doc """
  Create an issue

  ## Example
      Ehee.Issues.create(credential, "username", "repositoryname", "title")

  More info at: https://developer.github.com/v3/issues/#create-an-issue
  """
  @spec create(Credential.t, binary, binary, binary, Keyword.t) :: Ehee.response
  def create(credential, owner, repo, title, options \\ []) do
    params = %{title: title,
               body: Keyword.get(options, :body),
               milestone: Keyword.get(options, :milestone),
               labels: Keyword.get(options, :labels, []),
               assignees: Keyword.get(options, :assignees, [])}

    post("/repos/#{owner}/#{repo}/issues", credential, params)
  end

  @doc """
  Edit an Issue

  ## Example
      Ehee.Issues.edit(credential, "username", "repositoryname", 1)

  More info at: https://developer.github.com/v3/issues/#edit-an-issue
  """
  @spec edit(Credential.t, binary, binary, integer, Keyword.t) :: Ehee.response
  def edit(credential, owner, repo, no, options \\ []) do
    params = %{title: Keyword.get(options, :title),
               body: Keyword.get(options, :body),
               state: Keyword.get(options, :state, "open"),
               milestone: Keyword.get(options, :milestone),
               labels: Keyword.get(options, :labels, []),
               assignees: Keyword.get(options, :assignees, [])}

    patch("/repos/#{owner}/#{repo}/issues/#{no}", credential, params)
  end

  @doc """
  List comment on an issue

  ## Example
      Ehee.Issues.comments(credential, "username", "repositoryname", 1)

  More info at: https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue
  """
  @spec comments(Credential.t, binary, binary, integer, Keyword.t) :: Ehee.response
  def comments(credential, owner, repo, no, since \\ nil ) do
    params = %{since: since}

    get("/repos/#{owner}/#{repo}/issues/#{no}/comments", credential, [], params: params)
  end

  @doc """
  List Comments in a repository

  ## Example
      Ehee.Issues.list_comments(credential, "username", "repositoryname", Keyword.t)

  More info at: https://developer.github.com/v3/issues/comments/#list-comments-in-a-repository
  """
  @spec list_comments(Credential.t, binary, binary, Keyword.t) :: Ehee.response
  def list_comments(credential, owner, repo, options \\ []) do
    params = %{sort: Keyword.get(options, :sort, "created"),
               direction: Keyword.get(options, :direction),
               since: Keyword.get(options, :since)}

    get("/repos/#{owner}/#{repo}/issues/comments", credential, [], params: params)
  end

  @doc """
  Get a single comment

  ## Example
      Ehee.Issues.show_comment(credential, "username", "repositoryname", 1)

  More info at: https://developer.github.com/v3/issues/comments/#get-a-single-comment
  """
  @spec show_comment(Credential.t, binary, binary, integer) :: Ehee.response
  def show_comment(credential, owner, repo, id) do
    get("/repos/#{owner}/#{repo}/issues/comments/#{id}", credential)
  end

  @doc """
  Create a comment

  ## Example
      Ehee.Issues.create_comment(credential, "username", "repositoryname", 1, "comment body")

  More info at: https://developer.github.com/v3/issues/comments/#create-a-comment
  """
  @spec create_comment(Credential.t, binary, binary, integer, binary) :: Ehee.response
  def create_comment(credential, owner, repo, no, body) do
    params = %{ body: body }
    post("/repos/#{owner}/#{repo}/issues/#{no}/comments", credential, params)
  end

  @doc """
  Edit a comment

  ## Example
      Ehee.Issues.edit_comment(Credential.t, binary, binary, integer, binary)

  More info at: https://developer.github.com/v3/issues/comments/#edit-a-comment
  """
  @spec edit_comment(Credential.t, binary, binary, integer, binary) :: Ehee.response
  def edit_comment(credential, owner, repo, id, body) do
    params = %{ body: body }
    patch("/repos/#{owner}/#{repo}/issues/comments/#{id}", credential, params)
  end

  @doc """
  Delete a comment

  ## Example
    Ehee.Issues.delete_comment(Credential.t, binary, binary, integer)

  More info at: https://developer.github.com/v3/issues/comments/#delete-a-comment
  """
  @spec delete_comment(Credential.t, binary, binary, integer) :: Ehee.response
  def delete_comment(credential, owner, repo, id) do
    delete("/repos/#{owner}/#{repo}/issues/comments/#{id}", credential)
  end

end
