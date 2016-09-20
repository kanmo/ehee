defmodule Ehee.Repos do
  alias Ehee.Gateway

  def repos(options \\ []) do
    params = %{visibility: Keyword.get(options, :visibility),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    response = Gateway.get("/user/repos", [], params: params) |> elem(1)
    Poison.decode!(response.body)
  end

  def repos_user(username, options \\ []) do
    params = %{sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    response = Gateway.get("/users/#{username}/repos", [], params: params) |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls(owner, repo, options \\ []) do
    params = %{state: Keyword.get(options, :state),
               sort: Keyword.get(options, :sort),
               direction: Keyword.get(options, :direction)}

    response = Gateway.get("/repos/#{owner}/#{repo}/pulls", [], params: params) |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_single(owner, repo, pull_no) do
    response = Gateway.get("/repos/#{owner}/#{repo}/pulls/#{pull_no}") |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_create(owner, repo, title, head, base, body \\ "") do
    params = %{title: title,
               body: body,
               head: head,
               base: base }

    response = Gateway.post("/repos/#{owner}/#{repo}/pulls", Poison.encode!(params)) |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_edit(owner, repo, pull_no, title, base, body, state) do
    params = %{title: title,
               body: body,
               state: state,
               base: base }

    response = Gateway.post("/repos/#{owner}/#{repo}/pulls/#{pull_no}", Poison.encode!(params)) |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_commits(owner, repo, pull_no) do
    response = Gateway.get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/commits") |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_files(owner, repo, pull_no) do
    response = Gateway.get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/files") |> elem(1)
    Poison.decode!(response.body)
  end

  def pulls_merged?(owner, repo, pull_no) do
    response = Gateway.get("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge") |> elem(1)
    response.status_code == 204
  end

  def pulls_merge!(owner, repo, pull_no, message \\ "") do
    params = %{ commit_message: message}
    response = Gateway.put("/repos/#{owner}/#{repo}/pulls/#{pull_no}/merge", Poison.encode!(params)) |> elem(1)
    Poison.decode!(response.body)
  end


end
