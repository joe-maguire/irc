defmodule Irc.Message.PrefixTest do
  use ExUnit.Case, async: true

  alias Irc.Message.Prefix, as: Prefix

  @invalid_prefix_error "Invalid prefix: server or nickname required"

  doctest Irc.Message.Prefix

  test "can be initialized from a valid raw string" do
    inputs = ["server", "server!user", "server@host", "server!user@host"]

    expected_outputs = [
      %Prefix{name: "server", user: nil, host: nil},
      %Prefix{name: "server", user: "user", host: nil},
      %Prefix{name: "server", user: nil, host: "host"},
      %Prefix{name: "server", user: "user", host: "host"}
    ]

    Enum.zip(inputs, expected_outputs)
    |> Enum.each(fn ({input, expected}) ->
      assert Prefix.decode(input) == expected end)
  end

  test "has a string representation that is compatible with the spec" do
    inputs = [
      %Prefix{name: "server", user: nil, host: nil},
      %Prefix{name: "server", user: "user", host: nil},
      %Prefix{name: "server", user: nil, host: "host"},
      %Prefix{name: "server", user: "user", host: "host"}
    ]

    expected_outputs = [
      [":", "server", " "],
      [":", "server", "!", "user", " "],
      [":", "server", "@", "host", " "],
      [":", "server", "!", "user", "@", "host", " "]
    ]

    Enum.zip(inputs, expected_outputs)
    |> Enum.each(fn ({input, expected}) ->
      assert Prefix.encode(input) == expected end)
  end

  test "invalid raw strings return errors" do
    assert Prefix.decode("") == {:error, @invalid_prefix_error}
    assert Prefix.decode("!user") == {:error, @invalid_prefix_error}
    assert Prefix.decode("@host") == {:error, @invalid_prefix_error}
    assert Prefix.decode("!user@host") == {:error, @invalid_prefix_error}
  end
end
