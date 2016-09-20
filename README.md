# Ehee
This is an unofficial elixir client for the Github API. 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ehee` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ehee, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ehee` is started before your application:

    ```elixir
    def application do
      [applications: [:ehee]]
    end
    ```

  3. Fetching dependencies and running on elixir console:

    ```elixir
    mix deps.get
    iex -S mix
    ```

