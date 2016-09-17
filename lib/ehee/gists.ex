defmodule Ehee.Gists do
  alias Ehee.Gateway

  def gists do
    response = Gateway.get("/gists") |> elem(1)
    Poison.decode!(response.body)
  end

  def gists(username) do
    response = Gateway.get("/users/#{username}/gists") |> elem(1)
    Poison.decode!(response.body)
  end

end
