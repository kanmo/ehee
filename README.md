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

### IEx

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

### CLI Application

  1. To install the escript on your mix directory(`/Users/yourusername/.mix/escripts`)

    ```bash
    mix do escript.build, escript.install
    ```

  2. Set the Github personal API token to environment variable. write to bashrc if you use bash.
  
    ```
    export GH_ACCESS_TOKEN="yourtokencomeshere"
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
iex> Ehee.Gists.list_users(credential, "username")
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

#### Repositories

* List a user's repositories

```iex
iex> Ehee.Repos.list_users(credential, "username")
```

* List a authenticated user's gists

```iex
iex> Ehee.Repos.list(credential)
```

* List pull requests on a repository

```iex
iex> Ehee.Repos.pull_requests(credential, "ownername", "repositoryname)
```

* Get a single pull request on a repository

```iex
iex> Ehee.Repos.pull_requests(credential, "ownername", "repositoryname", 1)
```

* Create a pull request([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Repos.html#create_pull_request/7))

```iex
iex> Ehee.Repos.create_pull_request(credential, "ownername", "repositoryname", "pull request title", "octocat:new-feature", "master", "Please pull this in!")
```

* Update a pull request([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Repos.html#edit_pull_request/8))

```iex
iex> Ehee.Repos.edit_pull_request(credential, "ownername", "repositoryname", 1, "new title", "master", "new body", "open")
```

### CLI

#### Gists

* List a user's gists

```bash
ehee -g list_users kanmo
```

* List a authenticated user's gists

```bash
ehee -g list
```

* List all public gists

```bash
ehee -g list_public
```

* Get a single gist

```bash
ehee -g show 1
```

* Create a gist([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Gists.html#create/5))

```bash
ehee -g create "gist description", true, "gist file_name", "gist content"
```

* Edit a gist

```bash
ehee -g edit 1 "gist_file_name" "gist content"
```

* Star a gist

```bash
ehee -g star 1
```

* Unstar a gist

```bash
ehee -g unstar 1
```

* Check if a gist is starred

```bash
ehee -g starred? 1
```

* Delete a gist

```bash
ehee -g destroy 1
```

* List comments for a gist

```bash
ehee -g list_comments 1
```

* Get a single gist comment

```bash
ehee -g show_comment 1 1
```

* Create a single gist comment

```bash
ehee -g create_comment 1 "gist_comment"
```

* Patch a single gist comment

```bash
ehee -g edit_comment 1 1 "gist_comment"
```

* Delete a single gist comment

```bash
ehee -g delete_comment 1 1
```

#### Repositories

* List a user's repositories

```bash
ehee -r list_users "username"
```

* List a authenticated user's gists

```bash
ehee -r list
```

* List pull requests on a repository

```bash
ehee -r pull_requests "ownername" "repositoryname
```

* Get a single pull request on a repository

```bash
ehee -r pull_requests "ownername", "repositoryname", 1
```

* Create a pull request([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Repos.html#create_pull_request/7))

```bash
ehee -r create_pull_request "ownername" "repositoryname" "pull request title" "octocat:new-feature" "master" "Please pull this in!"
```

* Update a pull request([see docs for all possible params](https://hexdocs.pm/ehee/Ehee.Repos.html#edit_pull_request/8))

```bash
ehee -r edit_pull_request "ownername" "repositoryname" 1 "new title" "master" "new body" "open"
```


This software is released under the MIT License, see LICENSE.txt.
