defmodule Irc.Message.Params do
  @moduledoc """
  """
  alias __MODULE__, as: Params

  defstruct middles: [], trailing: nil

  @type t :: %Params{middles: [String.t], trailing: String.t}

  @spec from_string(String.t) ::{:ok, Params.t} | {:error, String.t}
  def from_string(raw) do
    raw |> String.split(" ", trim: true) |> route_params([])
  end

  # We found a trailing in the proper position
  @spec route_params([String.t], [String.t]) :: Params.t
  defp route_params([":" <> trailing], middles) do
    {:ok, %Params{middles: Enum.reverse(middles), trailing: trailing}}
  end

  # There is either more than one trailing, or there are middles after a trailing
  @spec route_params([String.t], [String.t]) :: Params.t
  defp route_params([":" <> _trailing | _tail], _middles) do
    {:error, "Invalid params: trailing segment must only be in last position"}
  end

  # We ran out of middles without running into a trailing
  @spec route_params([String.t], [String.t]) :: Params.t
  defp route_params([], middles) do
    {:ok, %Params{middles: Enum.reverse(middles), trailing: nil}}
  end

  # Continue building up the list of middles
  @spec route_params([String.t], [String.t]) :: Params.t
  defp route_params(parts, middles) do
    [middle | rest] = parts
    route_params(rest, [middle | middles])
  end

  @doc "Generates a valid IRC params string from the given Params"
  @spec to_string(Params.t) :: String.t
  def to_string(%Params{middles: middles, trailing: nil}) do
    middles |> Enum.map_join(&String.replace_prefix(&1, "", " "))
  end

  @spec to_string(Params.t) :: String.t
  def to_string(%Params{middles: middles, trailing: trailing}) do
    middles ++ [String.replace_prefix(trailing, "", ":")]
    |> Enum.map_join(&String.replace_prefix(&1, "", " "))
  end

  @doc """
  Appends trailing to middles to create a consolidated list of params that is
  easier to work with.
  """
  @spec flatten(Params.t) :: [String.t]
  def flatten(params) do
    params.middles ++ [params.trailing]
  end
end
