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
                                         r: :repository])
    case parse do

      { [ help: true ], _, _}
        -> :help

      { [ gist: gist_command ], args, _}
        -> { :gist, gist_command, args }

      { [ repository: repository_command ], args, _}
        -> { :repository, repository_command, args }

      { _, [ user, project, count ], _ }
        -> { user, project, String.to_integer(count) }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: ehee [ -g | -r ] <commnad>
    """
    System.halt(0)
  end

  def process({ :gist, command, args }) do
    cred = Ehee.Credential.new(%{access_token: Application.get_env(:ehee, :access_token)})
    code = quote do
      apply(Ehee.Gists, unquote(String.to_atom(command)), List.insert_at(unquote(args), 0, var!(credential)))
    end

    resp = Code.eval_quoted code, [credential: cred]
    IO.inspect(resp)
  end
end
