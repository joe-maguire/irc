defmodule Irc.Message.Command do
  @moduledoc """
  """
  alias __MODULE__, as: Command

  @typedoc ""
  @type t :: :atom

  @typedoc ""
  @type unrecognized_command_error :: {:error, String.t}

  @spec from_string(String.t) :: Command.t | unrecognized_command_error
  def from_string(raw), do: do_from_string(raw)

  @doc """
  """
  @spec to_string(Command.t) :: String.t | unrecognized_command_error
  def to_string(command), do: do_to_string(command)

  @basic_commands [
    :pass, :nick, :user, :oper, :mode, :service, :quit, :squit, :join, :part,
	  :topic,	:names,	:list, :invite,	:kick, :privmsg, :notice, :motd, :lusers,
    :version,	:stats, :links,	:time, :connect, :trace, :admin, :info,	:servlist,
	  :squery, :whois, :whowas, :kill, :ping, :pong, :error, :away,	:rehash, :die,
    :restart, :summon, :users, :wallops, :userhost, :ison, :server,	:njoin
  ]

  # Generate function clauses for each command
  @basic_commands
  |> Enum.each(fn (command) ->
    string = command |> Atom.to_string |> String.upcase
    defp do_from_string(unquote(string)), do: unquote(command)
    defp do_to_string(unquote(command)), do: unquote(string)
  end)

  # Define a catchall, error-producing case
  defp do_from_string(_string), do: {:error, "Unrecognized command"}
  defp do_to_string(_atom), do: {:error, "Unrecognized command"}
end
