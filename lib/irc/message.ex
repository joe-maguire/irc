defmodule Irc.Message do
  @moduledoc """
  """

  alias __MODULE__, as: Message
  alias Message.Prefix, as: Prefix
  alias Message.Command, as: Command
  alias Message.Params, as: Params

  defstruct prefix: nil, command: nil, params: nil

  def from_string(":" <> rest) do

  end

  def to_string(%Message{prefix: nil, command: command, params: nil}) do
    Command.to_string(command)
  end

  def to_string(%Message{prefix: prefix, command: command, params: nil}) do
    ":#{Prefix.to_string(prefix)} #{Command.to_string(command)}"
  end

  def to_string(%Message{prefix: nil, command: command, params: params}) do
    Command.to_string command
  end

  def to_string(%Message{prefix: prefix, command: command, params: params}) do
    Command.to_string command
  end
end
