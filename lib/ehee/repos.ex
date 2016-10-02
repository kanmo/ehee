defmodule Ehee.Repos do
  import Ehee
  alias Ehee.Credential
  @moduledoc """
  The Repository and Pull Requests Webhooks API
  """

  @doc """
  List your repositories

  ## Example
      Ehee.Repos.repos(credential, visibility: "public", sort: "updated", direction: "desc")

  More info at: https://developer.github.com/v3/repos/#list-your-repositories
  """
  @spec repos(Credential.t, Keyword.t) :: Ehee.response
  def repos(credential, options \\ []) do
    params = %{visibility: Keyword.get(options, :visibility),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/user/repos", credential, params)
  end

  @doc """
  List user repositories

  ## Example
      Ehee.Repos.repos_user(credential, sort: "updated", direction: "desc")

  More info at: https://developer.github.com/v3/repos/#list-user-repositories
  """
  @spec repos_user(Credential.t, binary, Keyword.t) :: Ehee.response
  def repos_user(credential, username, options \\ []) do
    params = %{sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/users/#{username}/repos", credential, [], params: params)
  end

  @doc """
  List pull requests

  ## Example
      Ehee.Repos.pulls(credential, state: "open", sort: "updated", direction: "desc")

  More info at: https://developer.github.com/v3/pulls/#list-pull-requests
  """
  @spec pulls(Credential.t, binary, binary, Keyword.t) :: Ehee.response
  def pulls(credential, owner, repo, options \\ []) do
    params = %{state: Keyword.get(options, :state),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/repos/#{owner}/#{repo}/pulls", credential, [], params: params)
  end

  @doc """
  Get a single pull request

  ## Example
      Ehee.Repos.pulls_single(credential, "owner", "repository_name", "pull_request_no")

  More info at: https://developer.github.com/v3/pulls/#get-a-single-pull-request
  """
  @spec pulls_single(Credential.t, binary, binary, integer) :: Ehee.response
  def pulls_single(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}", credential)
  end

  @doc """
  Create a pull request

  ## Example
      Ehee.Repos.pulls_create(credential, "owner", "repository_name", "Amasing new feature", "octocat:new-feature", "master", "Please pull this in!")

  More info at: https://developer.github.com/v3/pulls/#create-a-pull-request
  """
  @spec pulls_create(Credential.t, binary, binary, binary, binary, binary, binary) :: Ehee.response
  def pulls_create(credential, owner, repo, title, head, base, body \\ "") do
    params = %{title: title,
               body: body,
               head: head,
               base: base }

    post("/repos/#{owner}/#{repo}/pulls", credential, params)
  end

  @doc """
  Update a pull request

  ## Example
      Ehee.Repos.pulls_edit(credential, "owner", "repository_name",100, "new title", "master", "new body", "open")

  More info at: https://developer.github.com/v3/pulls/#update-a-pull-request
  """
  @spec pulls_edit(Credential.t, binary, binary, integer, binary, binary, binary, binary) :: Ehee.response
  def pulls_edit(credential, owner, repo, pull_no, title, base, body, state) do
    params = %{title: title,
               body: body,
               state: state,
               base: base }

    post("/repos/#{owner}/#{repo}/pulls/#{pull_no}", credential, params)
  end

  @doc """
  List commits on a pull request

  ## Example
      Ehee.Repos.pulls_commits(credential, "owner", "repository_name", 100)

  More info at: https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
  """
  @spec pulls_commits(Credential.t, binary, binary, integer) :: Ehee.response
  def pulls_commits(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/commits", credential)
  end

  @doc """
  List pull requests files

  ## Example
      Ehee.Repos.pulls_files(credential, "owner", "repository_name", 100)

  More info at: https://developer.github.com/v3/pulls/#list-pull-requests-files
  """
  @spec pulls_files(Credential.t, binary, binary, integer) :: Ehee.response
  def pulls_files(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/files", credential)
  end

  @doc """
  Get if a pull request has been merged

  ## Example
      Ehee.Repos.pulls_merged?(credential, "owner", "repository_name", 100)

  More info at: https://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged
  """
  @spec pulls_merged?(Credential.t, binary, binary, integer) :: Ehee.response
  def pulls_merged?(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge", credential)
  end

  @doc """
  Merge a pull request(Merge Button)

  ## Example
      Ehee.Repos.pulls_merged?(credential, "owner", "repository_name", 100)

  More info at: https://developer.github.com/v3/pulls/#merge-a-pull-request-merge-button
  """
  @spec pulls_merge!(Credential.t, binary, binary, integer, binary) :: Ehee.response
  def pulls_merge!(credential, owner, repo, pull_no, message \\ "") do
    params = %{ commit_message: message}
    put("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge", credential, params)
  end

end
