defmodule Ehee.Mixfile do
  use Mix.Project

  @description """
    Unofficial Elixir client for the Github API
  """

  def project do
    [app: :ehee,
     escript: escript_config,
     version: "0.0.1",
     elixir: "~> 1.3",
     name: "Ehee",
     description: @description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :poison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:poison, "~> 1.5"},
      {:ex_doc, "~> 0.11"},
      {:earmark, ">= 0.0.0"},
      {:exvcr, "~> 0.6", only: :test},
    ]
  end

  defp package do
    [ maintainers: ["Akihide Kang"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/kanmo/ehee" } ]
  end

  defp escript_config do
    [ main_module: Ehee.CLI ]
  end
end
