defmodule Irc.Message.Params do
  @moduledoc """
  """
  alias __MODULE__, as: Params

  defstruct middles: [], trailing: nil

  @type t :: %Params{middles: [String.t], trailing: String.t}

  def from_string(" " <> rest) do
    rest |> String.split(" ", trim: true) |> route_params([])
  end

  defp route_params([":" <> trailing], middles) do
    %Params{middles: Enum.reverse(middles), trailing: trailing}
  end

  defp route_params([":" <> _trailing | _tail], _middles) do
    {:error, "Invalid params: trailing segment must only be in last position"}
  end

  defp route_params([], middles) do
    %Params{middles: Enum.reverse(middles), trailing: nil}
  end

  defp route_params(parts, middles) do
    [middle | rest] = parts
    route_params(rest, [middle | middles])
  end

  @doc """
  """
  def to_string(%Params{middles: [], trailing: nil}), do: ""

  def to_string(%Params{middles: [], trailing: trailing}) do
    " :" <> trailing
  end

  def to_string(%Params{middles: middles, trailing: nil}) do
    " " <> Enum.join(middles, " ")
  end

  def to_string(%Params{middles: middles, trailing: trailing}) do
    " " <> Enum.join(middles, " ") <> " :" <> trailing
  end

  def flatten(params) do
    params.middle ++ [params.trailing]
  end
end
