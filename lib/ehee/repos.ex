defmodule Ehee.Repos do
  import Ehee

  def repos(credential, options \\ []) do
    params = %{visibility: Keyword.get(options, :visibility),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/user/repos", credential)
  end

  def repos_user(credential, username, options \\ []) do
    params = %{sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/users/#{username}/repos", credential, [], params: params)
  end

  def pulls(credential, owner, repo, options \\ []) do
    params = %{state: Keyword.get(options, :state),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    get("/repos/#{owner}/#{repo}/pulls", credential, [], params: params)
  end

  def pulls_single(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}", credential)
  end

  def pulls_create(credential, owner, repo, title, head, base, body \\ "") do
    params = %{title: title,
               body: body,
               head: head,
               base: base }

    post("/repos/#{owner}/#{repo}/pulls", credential, params)
  end

  def pulls_edit(credential, owner, repo, pull_no, title, base, body, state) do
    params = %{title: title,
               body: body,
               state: state,
               base: base }

    post("/repos/#{owner}/#{repo}/pulls/#{pull_no}", credential, params)
  end

  def pulls_commits(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/commits", credential)
  end

  def pulls_files(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/files", credential)
  end

  def pulls_merged?(credential, owner, repo, pull_no) do
    get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge", credential)
  end

  def pulls_merge!(credential, owner, repo, pull_no, message \\ "") do
    params = %{ commit_message: message}
    put("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge", credential, params)
  end

end
