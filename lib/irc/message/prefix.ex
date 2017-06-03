defmodule Irc.Message.Prefix do
  @moduledoc """
  This module provides functions for encoding and decoding raw IRC prefixes.
  """
  alias __MODULE__, as: Prefix

  @enforce_keys [:name]
  defstruct [:name, :user, :host]

  @typedoc "The prefix section of an IRC message"
  @type t :: %Prefix{name: String.t, user: String.t, host: String.t}

  @invalid_prefix_error "Invalid prefix: server or nickname required"

  @prefix <<58>>
  @user_prefix <<33>>
  @host_prefix <<64>>
  @space <<32>>

  @doc "Decodes a raw IRC message prefix"
  @spec decode(String.t) :: {:ok, Prefix.t} | {:error, String.t}
  def decode(nil), do: nil
  def decode(str) do
    case String.split(str, "!", parts: 2) do
      [""]  -> {:error, @invalid_prefix_error} 
      ["", _] -> {:error, @invalid_prefix_error}
      ["@" <> _] -> {:error, @invalid_prefix_error}
      [name_host] -> handle_name_host(name_host)
      [name, user_host] -> handle_name_with_user_host(name, user_host)
    end
  end

  # User isn't specified and we need to split out host from name
  defp handle_name_host(name_host) do
    case String.split(name_host, "@", parts: 2) do
      [name, host] -> %Prefix{name: name, user: nil, host: host}
      [name] -> %Prefix{name: name, user: nil, host: nil}
    end
  end

  # User is specified and we need to split out host from user
  defp handle_name_with_user_host(name, user_host) do
    case String.split(user_host, "@", parts: 2) do
      [user, host] -> %Prefix{name: name, user: user, host: host}
      [user] -> %Prefix{name: name, user: user, host: nil}
    end
  end

  @doc "Encodes a prefix as an iolist"
  @spec encode(Prefix.t) :: iolist()
  def encode(%Prefix{name: name, user: nil, host: nil}) do
    [@prefix, name, @space]
  end
  def encode(%Prefix{name: name, user: user, host: nil}) do
    [@prefix, name, @user_prefix, user, @space]
  end
  def encode(%Prefix{name: name, user: nil, host: host}) do
    [@prefix, name, @host_prefix, host, @space]
  end
  def encode(%Prefix{name: name, user: user, host: host}) do
    [@prefix, name, @user_prefix, user, @host_prefix, host, @space]
  end
end

defimpl String.Chars, for: Irc.Message.Prefix do
  def to_string(prefix) do
    prefix |> Irc.Message.Prefix.encode |> Kernel.to_string
  end
end
