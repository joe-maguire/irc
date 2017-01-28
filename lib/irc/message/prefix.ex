defmodule Irc.Message.Prefix do
  @moduledoc """

  """
  alias __MODULE__, as: Prefix

  @enforce_keys [:name]
  defstruct [:name, :user, :host]

  @typedoc "The prefix section of an IRC message"
  @type t :: %Prefix{name: String.t, user: String.t, host: String.t}

  @typedoc "An error that includes the reason for invalidity"
  @type invalid_prefix_error :: {:error, String.t}

  @invalid_prefix_error "Invalid prefix: server or nickname required"

  @spec from_string(String.t) :: Prefix.t | invalid_prefix_error
  def from_string(raw) when is_binary(raw) do
    case String.split(raw, "!", parts: 2) do
      [""]  -> {:error, @invalid_prefix_error}
      ["", _] -> {:error, @invalid_prefix_error}
      ["@" <> _] -> {:error, @invalid_prefix_error}
      [name_host] ->
        case String.split(name_host, "@", parts: 2) do
          [name, host] -> %Prefix{name: name, user: nil, host: host}
          [name] -> %Prefix{name: name, user: nil, host: nil}
        end
      [name, user_host] ->
        case String.split(user_host, "@", parts: 2) do
          [user, host] -> %Prefix{name: name, user: user, host: host}
          [user] -> %Prefix{name: name, user: user, host: nil}
        end
    end
  end

  @spec to_string(Prefix.t) :: String.t
  def to_string(%Prefix{name: name, user: nil, host: nil}) do
    name
  end

  @spec to_string(Prefix.t) :: String.t
  def to_string(%Prefix{name: name, user: user, host: nil}) do
    name <> "!" <> user
  end

  @spec to_string(Prefix.t) :: String.t
  def to_string(%Prefix{name: name, user: nil, host: host}) do
    name <> "@" <> host
  end

  @spec to_string(Prefix.t) :: String.t
  def to_string(%Prefix{name: name, user: user, host: host}) do
     name <> "!" <> user <> "@" <> host
  end
end
