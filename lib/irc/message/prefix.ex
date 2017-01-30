defmodule Irc.Message.Prefix do
  @moduledoc """
  This module provides functions for encoding and decoding raw IRC prefixes.
  """
  alias __MODULE__, as: Prefix

  @enforce_keys [:name]
  defstruct [:name, :user, :host]

  @typedoc "The prefix section of an IRC message"
  @type t :: %Prefix{name: String.t, user: String.t, host: String.t}

  @typedoc "An error that includes the reason for invalidity"
  @type invalid_prefix_error :: {:error, String.t}

  @invalid_prefix_error "Invalid prefix: server or nickname required"

  @doc "Parses a raw IRC message prefix string into the Prefix struct"
  @spec from_string(String.t) :: Prefix.t | invalid_prefix_error
  def from_string(raw) do
    case String.split(raw, "!", parts: 2) do
      [""]  -> {:error, @invalid_prefix_error}
      ["", _] -> {:error, @invalid_prefix_error}
      ["@" <> _] -> {:error, @invalid_prefix_error}
      [name_host] -> handle_name_host(name_host)
      [name, user_host] -> handle_name_with_user_host(name, user_host)
    end
  end

  # User isn't specified and we need to split out host from name
  @spec handle_name_host(String.t) :: Prefix.t
  defp handle_name_host(name_host) do
    case String.split(name_host, "@", parts: 2) do
      [name, host] -> %Prefix{name: name, user: nil, host: host}
      [name] -> %Prefix{name: name, user: nil, host: nil}
    end
  end

  # User is specified and we need to split out host from user
  @spec handle_name_with_user_host(String.t, String.t) :: Prefix.t
  defp handle_name_with_user_host(name, user_host) do
    case String.split(user_host, "@", parts: 2) do
      [user, host] -> %Prefix{name: name, user: user, host: host}
      [user] -> %Prefix{name: name, user: user, host: nil}
    end
  end

  @doc "Generates the valid IRC string representation of the given Prefix"
  @spec to_string(Prefix.t) :: String.t
  def to_string(%Prefix{name: name, user: user, host: host}) do
    [[name, user, host], ["", "!", "@"]]
    |> Enum.zip
    |> Enum.map_join(fn {val, pre} -> prefix(val, pre) end)
  end

  # Prefix the value string with the given prefix string
  @spec prefix(String.t, String.t) :: String.t 
  defp prefix(nil, _prefix), do: ""
  defp prefix(value, prefix), do: [prefix, value] |> Enum.join
end
