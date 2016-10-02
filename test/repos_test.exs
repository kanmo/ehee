defmodule Ehee.ReposTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Ehee.Repos

  @credential Ehee.Credential.new(%{access_token: "yourtokencomeshere"})

  setup_all do
    HTTPoison.start
  end

  test "list" do
    use_cassette "repos#list" do
      repos = list(@credential)
      assert Enum.count(repos) > 1
    end
  end

  test "list_users" do
    use_cassette "repos#list_users" do
      repos = list_users(@credential, "kanmo")
      assert Enum.count(repos) > 1
    end
  end

  test "pull_requests" do
    use_cassette "repos#pull_requests" do
      pulls = pull_requests(@credential, "kanmo", "Hello-World")
      assert Enum.count(pulls) == 0
    end
  end

  test "show_pull_request" do
    use_cassette "repos#show_pull_request" do
      %{"number" => number} = show_pull_request(@credential, "kanmo", "Hello-World", 1)
      assert number == 1
    end
  end

  test "create_pull_request" do
    use_cassette "repos#create_pull_request" do
      {status, _} = create_pull_request(@credential, "kanmo", "Hello-World", "test-pull-req", "kanmo:new-feature", "master", "test-pull-req body")
      assert status == 201
    end
  end

  test "edit_pull_request" do
    use_cassette "repos#edit_pull_request" do
      %{"title" => title} = edit_pull_request(@credential, "kanmo", "Hello-World", 2, "test-edit-pull-req", "master", "editted body", "open")
      assert title == "test-edit-pull-req"
    end
  end

  test "pull_request_commits" do
    use_cassette "repos#pull_request_commits" do
      commits = pull_request_commits(@credential, "kanmo", "Hello-World", 2)
      assert Enum.count(commits) == 1
    end
  end

  test "pull_request_files" do
    use_cassette "repos#pull_request_files" do
      files = pull_request_files(@credential, "kanmo", "Hello-World", 2)
      assert Enum.count(files) == 1
    end
  end

  test "pull_request_merged?" do
    use_cassette "repos#pull_request_merged?" do
      assert pull_request_merged?(@credential, "kanmo", "Hello-World", 2) == false
    end
  end

  test "pull_request_merge!" do
    use_cassette "repos#pull_request_merge!" do
      %{"merged" => merged} = pull_request_merge!(@credential, "kanmo", "Hello-World", 2)
      assert merged == true
    end
  end
end
