defmodule Irc.Message.CommandTest do
  use ExUnit.Case, async: true

  alias Irc.Message.Command, as: Command

  doctest Command

  test "has a valid string representation" do
    assert Command.to_string(:pass) == "PASS"
  end

  test "can be initialized from a valid raw string" do
    assert Command.from_string("PASS") == :pass
  end

  test "unrecognized commands produce an error" do
    assert Command.from_string("nonsense") == {:error, "Unrecognized command"}
    assert Command.to_string(:nonsense) == {:error, "Unrecognized command"}
  end
end
