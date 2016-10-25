defmodule Ehee.Issues do
  import Ehee
  alias Ehee.Credential
  @moduledoc """
  The Issues Webhooks API
  """

  def list(credential) do
    get("/issues", credential)
  end

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

  def show(credential, owner, repo, no) do
    get("/repos/#{owner}/#{repo}/issues/#{no}", credential)
  end

  def create(credential, owner, repo, title, options \\ []) do
    params = %{title: title,
               body: Keyword.get(options, :body),
               milestone: Keyword.get(options, :milestone),
               labels: Keyword.get(options, :labels, []),
               assignees: Keyword.get(options, :assignees, [])}

    post("/repos/#{owner}/#{repo}/issues", credential, params)
  end

  def edit(credential, owner, repo, no, options \\ []) do
    params = %{title: Keyword.get(options, :title),
               body: Keyword.get(options, :body),
               state: Keyword.get(options, :state, "open"),
               milestone: Keyword.get(options, :milestone),
               labels: Keyword.get(options, :labels, []),
               assignees: Keyword.get(options, :assignees, [])}

    patch("/repos/#{owner}/#{repo}/issues/#{no}", credential, params)
  end


end