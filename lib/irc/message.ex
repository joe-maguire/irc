defmodule Irc.Message do
  @moduledoc """
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

  @typedoc ""
  @type message_parse_error :: {:error, String.t}

  @spec from_string(String.t) :: {:ok, t} | message_parse_error
  def from_string(":" <> raw) do
    case String.split(raw, " ", parts: 3) do
      [raw_prefix, raw_command] ->
        parse_parts(raw_prefix, raw_command, nil)
      [raw_prefix, raw_command, raw_params] ->
        parse_parts(raw_prefix, raw_command, raw_params)
    end
  end

  def from_string(raw) do
    case String.split(raw, " ", parts: 2) do
      [raw_command] ->
        parse_parts(nil, raw_command, nil)
      [raw_command, raw_params] ->
        parse_parts(nil, raw_command, raw_params)
    end
  end

  # Parse each part of the message individually. If all parts are valid, then
  # construct the full message, otherwise return a descriptive error message.
  # Note: If multiple parts are invalid, only the first issue encountered will
  # be mentioned in the error message.
  @spec parse_parts(String.t, String.t, String.t) :: {:ok, t}
        | message_parse_error
  defp parse_parts(raw_prefix, raw_command, raw_params) do
    with {:ok, prefix} <- Prefix.from_string(raw_prefix),
         {:ok, command} <- Command.from_string(raw_command),
         {:ok, params} <- Params.from_string(raw_params)
    do
      %Message{prefix: prefix, command: command, params: params}
    else
      {:error, reason} -> {:error, "Could not parse message: #{reason}"}
    end
  end

  @spec to_string(Message.t) :: String.t
  def to_string(%Message{prefix: nil, command: command, params: nil}) do
    "#{command}"
  end

  def to_string(%Message{prefix: prefix, command: command, params: nil}) do
    ":#{prefix} #{command}"
  end

  def to_string(%Message{prefix: nil, command: command, params: params}) do
    "#{command}#{params}"
  end

  def to_string(%Message{prefix: prefix, command: command, params: params}) do
    ":#{prefix} #{command}#{params}"
  end
end
