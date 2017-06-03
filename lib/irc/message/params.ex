defmodule Irc.Message.Params do
  @moduledoc """
  The parameters part of an IRC message.

  While there's no inherent reason to treat trailing and middle parameters
  separately, they are stored separately to provide the guarantee that
  message = message |> Params.decode |> Params.encode. If all you want is a
  simple list of all the parameters, then call Params.flatten/1
  """
  alias __MODULE__

  defstruct [:trailing, middles: []]

  @type t :: %Params{middles: [String.t], trailing: String.t}

  @space <<32>>
  @colon <<58>>

  @doc """
  Parses a string representation of the parameters section of an IRC message
  """
  @spec decode(String.t) ::{:ok, Params.t} | {:error, String.t}
  def decode(nil), do: nil
  def decode(str) do
    str |> String.split(" ", trim: true) |> do_decode([])
  end

  # We found a trailing in the proper position
  defp do_decode([":" <> trailing], middles) do
    {:ok, %Params{middles: middles, trailing: trailing}}
  end

  # There is something after a trailing
  defp do_decode([":" <> _trailing | _tail], _middles) do
    {:error, "Trailing parameter segment must only be in last position"}
  end

  # We ran out of middles without running into a trailing
  defp do_decode([], middles) do
    {:ok, %Params{middles: middles, trailing: nil}}
  end

  # Continue building up the list of middles
  defp do_decode([next | rest], middles) do
    do_decode(rest, [next | middles])
  end

  @doc """
  Generates a valid IRC params string from the given Params
  """
  @spec encode(Params.t) :: iolist()
  def encode(%Params{middles: middles, trailing: nil}) do
    middles |> append_spaces([])
  end

  def encode(%Params{middles: middles, trailing: trailing}) do
    middles |> append_spaces([@space, @colon, trailing])
  end

  defp append_spaces([h | t], acc) do
    append_spaces(t, [@space | [h | acc]])
  end

  defp append_spaces([], acc) do
    acc
  end

  @doc """
  Prepends trailing to middles to create a consolidated list of params that is
  easier to work with. Note: the resulting list will be in reverse order from
  how it would appear in the string representation; if this does not work for
  your usecase for some reason, simply pass it Enum.reverse/1 first.
  """
  @spec flatten(Params.t) :: [String.t]
  def flatten(%Params{middles: m, trailing: nil}), do: m
  def flatten(%Params{middles: m, trailing: t}), do: [t | m]
end

defimpl String.Chars, for: Irc.Message.Params do
  def to_string(params) do
    params |> Irc.Message.Params.encode |> Kernel.to_string
  end
end
