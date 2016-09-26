defmodule EheeTest do
  use ExUnit.Case
  import Ehee

  doctest Ehee

  test "authorization header" do
    authorization_headers(%{access_token: 123456}, []) == [{"Authorization", "token 123456"}]
  end

  test "handle response on a 200 response" do
    assert handle_response(%HTTPoison.Response{status_code: 200, body: "body"}) == "body"
  end

  test "handle response on a non-200 response" do
    assert handle_response(%HTTPoison.Response{status_code: 500, body: "body"}) == {500, "body"}
  end

end
