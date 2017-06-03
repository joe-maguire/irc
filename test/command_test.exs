defmodule Irc.Message.CommandTest do
  use ExUnit.Case, async: true

  alias Irc.Message.Command, as: Command

  doctest Command

  test "encodes to the proper string representation" do
    assert Command.encode!(:pass) == "PASS"
  end

  test "can be decoded from a valid string" do
    assert Command.decode("PASS") == :pass
  end

  test "decoding an unrecognized command produces an error" do
    assert Command.decode("nonsense") == {:error, "Unrecognized command"}
  end

  test "encoding an unrecognized command raises an exception" do
    assert_raise(InvalidIrcMessageError, fn -> Command.encode!(:nonsense) end)
  end
end
