defmodule CliTest do
  use ExUnit.Case
  doctest Ehee

  import Ehee.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "gists method name returned by option parsing with -g and --gist options" do
    assert parse_args(["-g", "list_users"]) == { :gist, "list_users", [] }
    assert parse_args(["--gist", "list_users"]) == { :gist, "list_users", [] }
  end

  test "repository method name returned by option parsing with -r and --repository options" do
    assert parse_args(["-r", "list_users"]) == { :repository, "list_users", [] }
    assert parse_args(["--repository", "list_users"]) == { :repository, "list_users", [] }
  end

  test "issues method name returned by option parsing with -i and --issue options" do
    assert parse_args(["-i", "list"]) == { :issue, "list", [] }
    assert parse_args(["--issue", "list"]) == { :issue, "list", [] }
  end

end
