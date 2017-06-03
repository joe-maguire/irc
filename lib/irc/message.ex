defmodule Irc.Message do
  @moduledoc """
  A library for decoding and encoding irc messages.
  """

  alias __MODULE__
  alias Message.Prefix
  alias Message.Command
  alias Message.Params

  @enforce_keys [:command]
  defstruct [:prefix, :command, :params]

  @typedoc """
  An IRC message separated into three parts: the prefix, the command,and the
  parameters.
  """
  @type t :: %Message{prefix: Prefix.t, command: Command.t, params: Params.t}

  @spec decode(String.t) :: {:ok, Message.t} | {:error, String.t}
  def decode(":" <> raw) do
    case String.split(raw, " ", parts: 3) do
      [_prefix] -> {:error, "Message must contain a command"}
      [prefix, command] ->
        do_decode(prefix, command, nil)
      [prefix, command, params] ->
        do_decode(prefix, command, params)
    end
  end

  def decode(raw) do
    case String.split(raw, " ", parts: 2) do
      [command] ->
        do_decode(nil, command, nil)
      [command, params] ->
        do_decode(nil, command, params)
    end
  end

  defp do_decode(raw_prefix, raw_command, raw_params) do
    with {:ok, prefix} <- Prefix.decode(raw_prefix),
         {:ok, command} <- Command.decode(raw_command),
         {:ok, params} <- Params.decode(raw_params)
    do
      {:ok, %Message{prefix: prefix, command: command, params: params}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec encode(Message.t) :: String.t
  def encode(%Message{prefix: nil, command: command, params: nil}) do
    [command]
  end

  def encode(%Message{prefix: prefix, command: command, params: nil}) do
    [prefix, command]
  end

  def encode(%Message{prefix: nil, command: command, params: params}) do
    [command, params]
  end

  def encode(%Message{prefix: prefix, command: command, params: params}) do
    [prefix, command, params]
  end
end

defimpl String.Chars, for: Irc.Message do
  def to_string(message), do: message |> Irc.Message.encode |> to_string
end
