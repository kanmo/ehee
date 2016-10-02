defmodule Ehee.GistsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Ehee.Gists

  @credential Ehee.Credential.new(%{access_token: "yourtokencomeshere"})

  setup_all do
    HTTPoison.start
  end

  test "list" do
    use_cassette "gists#list" do
      all_gists = list(@credential)
      assert Enum.count(all_gists) > 1
    end
  end

  test "list_users" do
    use_cassette "gists#list_users" do
      user_gists = list_users(@credential, "kanmo")
      assert Enum.count(user_gists) > 1
    end
  end

  test "list_public" do
    use_cassette "gists#list_public" do
      public_gists = list_public(@credential) |> Enum.take(100)
      assert Enum.count(public_gists) == 100
    end
  end

  test "show" do
    use_cassette "gists#show" do
      gist = show(@credential, 6050435)
      assert gist["url"] == "https://api.github.com/gists/6050435"
    end
  end

  test "create" do
    use_cassette "gists#create" do
      {status, _} = create(@credential, "test gist", true, "file1", "Hello Gist!")
      assert status == 201
    end
  end

  test "edit" do
    use_cassette "gists#edit" do
      %{"files" => %{"file1" => %{"content" => content}}} =  edit(@credential, "d3167879e3abbbb95b5d854d34478ea3", "file1", "editted gist")
      assert content == "editted gist"
    end
  end

  test "star" do
    use_cassette "gists#star" do
      {status, _} = star(@credential, "d3167879e3abbbb95b5d854d34478ea3")
      assert status == 204
    end
  end

  test "unstar" do
    use_cassette "gists#unstar" do
      {status, _} = unstar(@credential, "d3167879e3abbbb95b5d854d34478ea3")
      assert status == 204
    end
  end

  test "starred?" do
    use_cassette "gists#starred?" do
      assert starred?(@credential, "d3167879e3abbbb95b5d854d34478ea3") == false
    end
  end

  test "destroy" do
    use_cassette "gists#destroy" do
      {status, _} = destroy(@credential, "d3167879e3abbbb95b5d854d34478ea3")
      assert status == 204
    end
  end

  test "list_comments" do
    use_cassette "gists#list_comments" do
      comments = list_comments(@credential, "72d5b0fab65e2264c9140d30b191c3c0")
      assert Enum.count(comments) == 1
    end
  end

  test "show_comment" do
    use_cassette "gists#show_comment" do
      %{"id" => gist_id} = show_comment(@credential, "72d5b0fab65e2264c9140d30b191c3c0", 1880862)
      assert gist_id == 1880862
    end
  end

  test "create_comment" do
    use_cassette "gists#create_comment" do
      {status, _} = create_comment(@credential, "72d5b0fab65e2264c9140d30b191c3c0", "test comment")
      assert status == 201
    end
  end

  test "edit_comment" do
    use_cassette "gists#edit_comment" do
      %{"body" => body} = edit_comment(@credential, "72d5b0fab65e2264c9140d30b191c3c0", 1880862, "editted comment")
      assert body == "editted comment"
    end
  end

  test "delete_comment" do
    use_cassette "gists#delete_comment" do
      {status, _} = delete_comment(@credential, "72d5b0fab65e2264c9140d30b191c3c0", 1880862)
      assert status == 204
    end
  end

end
