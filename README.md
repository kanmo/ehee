# Ehee [![hex.pm version](https://img.shields.io/hexpm/v/ehee.svg)](https://hex.pm/packages/ehee) [![hex.pm](https://img.shields.io/hexpm/l/ehee.svg)](https://github.com/kanmo/ehee/blob/master/LICENSE)
This is an unofficial elixir client for the [GitHub API](http://developer.github.com/). 

## Features
* Pulls
  * Comments
  * Commits
* Repositories
  * Branches
* Gists
  * Comments
  * Star

Documentation can be found [here](https://hexdocs.pm/ehee)

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

## Example

Every call to GitHub needs a client, but if you want to use unauthenticated requests we will provide an unauthenticated client for you. Keep in mind that GitHub has different [rate-limits](https://developer.github.com/v3/#rate-limiting) if you authenticate or not.

Getting info from a user using a client

### IEx

* Using a personal access token [Github personal API token](https://github.com/blog/1509-personal-api-tokens). get from [here](https://github.com/settings/tokens).

```iex
iex> credential = Ehee.Credential.new(%{access_token: "yourtokencomeshere"})
```

#### Gists

* List a user's gists

```iex
iex> Ehee.Gists.list_user(credential, "username")
```

* List a authenticated user's gists

```iex
iex> Ehee.Gists.list(credential)
```

* List all public gists

```iex
iex> Ehee.Gists.list_public(credential)
```

* Get a single gist

```iex
iex> Ehee.Gists.show(credential, id)
```

* Create a gist([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Gists.html#create/5))

```iex
iex> Ehee.Gists.create(credential, "gist description", true, "gist file_name", "gist content")
```

* Edit a gist

```iex
iex> Ehee.Gists.edit(credential, 1, "gist_file_name", "gist content")
```

* Star a gist

```iex
iex> Ehee.Gists.star(credential, 1)
```

* Unstar a gist

```iex
iex> Ehee.Gists.unstar(credential, 1)
```

* Check if a gist is starred

```iex
iex> Ehee.Gists.starred?
```

* Delete a gist

```iex
iex> Ehee.Gists.destroy(credential, 1)
```

* List comments for a gist

```iex
iex> Ehee.Gists.list_comments(credential, 1)
```

* Get a single gist comment

```iex
iex> Ehee.Gist.show_comment(credential, 1, 1)
```

* Create a single gist comment

```iex
iex> Ehee.Gist.create_comment(credential, 1, "gist_comment")
```

* Patch a single gist comment

```iex
iex> Ehee.Gist.edit_comment(credential, 1, 1, "gist_comment")
```

* Delete a single gist comment

```iex
iex> Ehee.Gist.delete_comment(credential, 1, 1)
```

This software is released under the MIT License, see LICENSE.txt.
