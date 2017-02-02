defmodule Irc.Message.ParamsTest do
  use ExUnit.Case, async: true

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
      assert Params.from_string(input) == {:ok, expected} end)
  end

  test "strings that have parts after a trailing part produce errors" do
    assert Params.from_string(" :trailing middle") ==
      {:error, "Invalid params: trailing segment must only be in last position"}
  end

  test "can be flattened into a simple List" do
    inputs = [
      %Params{middles: [1, 2, 3], trailing: nil},
      %Params{middles: [], trailing: nil},
      %Params{middles: [1, 2, 3], trailing: 4},
      %Params{middles: [], trailing: 4},
    ]

    expected_outputs = [[1, 2, 3], [], [1, 2, 3, 4], [4]]

    [inputs, expected_outputs]
    |> Enum.zip
    |> Enum.each(fn {input, expected} ->
      assert Params.flatten(input) == expected end)
  end
end
