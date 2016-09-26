defmodule Ehee.Mixfile do
  use Mix.Project

  def project do
    [app: :ehee,
     version: "0.0.1",
     elixir: "~> 1.3",
     name: "Ehee",
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
      {:httpotion, github: "myfreeweb/httpotion"},
      {:ex_doc, "~> 0.11"},
      {:earmark, ">= 0.0.0"}
    ]
  end

  defp package do
    [ maintainers: ["Akihide Kang"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/kanmo/ehee" } ]
  end
end
