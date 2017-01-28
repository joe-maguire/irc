defmodule Irc.Message.ParamsTest do
  use ExUnit.Case

  alias Irc.Message.Params, as: Params

  doctest Params

  test "has a valid string representation" do
    inputs = [
      %Params{middles: [], trailing: nil},
      %Params{middles: [], trailing: "trailing"},
      %Params{middles: ["middle"], trailing: nil },
      %Params{middles: ["middle1", "middle2", "middle3"], trailing: "trailing"}
    ]

    expected_outputs = [
      "",
      " :trailing",
      " middle",
      " middle1 middle2 middle3 :trailing"
    ]

    Enum.zip(inputs, expected_outputs)
    |> Enum.each(fn ({input, expected}) ->
      assert Params.to_string(input) == expected end)
  end

  test "can be initialized from a valid raw string" do
    inputs = [
      " :trailing",
      " middle",
      " middle1 middle2 middle3 :trailing"
    ]

    expected_outputs = [
      %Params{middles: [], trailing: "trailing"},
      %Params{middles: ["middle"], trailing: nil },
      %Params{middles: ["middle1", "middle2", "middle3"], trailing: "trailing"}
    ]

    Enum.zip(inputs, expected_outputs)
    |> Enum.each(fn ({input, expected}) ->
      assert Params.from_string(input) == expected end)
  end

  test "strings that have parts after a trailing part produce errors" do
    assert Params.from_string(" :trailing middle") ==
      {:error, "Invalid params: trailing segment must only be in last position"}
  end
end
