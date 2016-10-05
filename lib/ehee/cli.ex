defmodule Ehee.CLI do
  def run(argv) do
    parse_args(argv)
    |> process
  end

  def parse_args(argv) do
    IO.inspect argv
    parse = OptionParser.parse(argv,
                               switches: [ help: :boolean],
                               aliases: [h: :help,
                                         g: :gist,
                                         r: :repository])

    case parse do

      { [ help: true ], _, _}
        -> :help

      { [ gist: gist_command ], _, _}
        -> { :gist, gist_command }

      { [ repository: repository_command ], _, _}
        -> { :repository, repository_command }

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

end
