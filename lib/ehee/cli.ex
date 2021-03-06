defmodule Ehee.CLI do
  def main(argv) do
    parse_args(argv)
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
                               switches: [ help: :boolean],
                               aliases: [h: :help,
                                         g: :gist,
                                         r: :repository,
                                         i: :issue])
    case parse do

      { [ help: true ], _, _} -> :help

      { [ gist: gist_command ], args, _} -> { :gist, gist_command, args }

      { [ repository: repository_command ], args, _} -> { :repository, repository_command, args }

      { [ issue: issue_command ], args, _} -> { :issue, issue_command, args }

      { _, [ user, project, count ], _ } -> { user, project, String.to_integer(count) }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: ehee [ -g | -r ] <commnad>
    """
    System.halt(0)
  end

  def process({ type, command, args }) do
    cred = Ehee.Credential.new(%{access_token: System.get_env("GH_ACCESS_TOKEN")})
    code = quote do
      module_name = case unquote(type) do
                      :gist -> Ehee.Gists
                      :repository -> Ehee.Repos
                      :issue -> Ehee.Issues
                    end

      method_name = unquote(String.to_atom(command))
      parameters = List.insert_at(unquote(args), 0, var!(credential))

      apply(module_name, method_name, parameters)
    end

    resp = Code.eval_quoted code, [credential: cred]
    IO.inspect(resp)
  end
end
