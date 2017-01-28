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

  @commands %{
    pass: "PASS", nick: "NICK", user: "USER", oper: "OPER", mode: "MODE",
    service: "SERVICE", quit: "QUIT", squit: "SQUIT",	join: "JOIN",
    part: "PART",	topic: "TOPIC",	names: "NAMES",	list: "LIST",
    invite: "INVITE",	kick: "KICK",	privmsg: "PRIVMSG",	notice: "NOTICE",
    motd: "MOTD",	lusers: "LUSERS",	version: "VERSION",	stats: "STATS",
    links: "LINKS",	time: "TIME",	connect: "CONNECT",	trace: "TRACE",
    admin: "ADMIN",	info: "INFO",	servlist: "SERVLIST",	squery: "SQUERY",
    who: "WHO",	whois: "WHOIS",	whowas: "WHOWAS",	kill: "KILL",	ping: "PING",
    pong: "PONG",	error: "ERROR",	away: "AWAY",	rehash: "REHASH",	die: "DIE",
    restart: "RESTART",	summon: "SUMMON",	users: "USERS",	wallops: "WALLOPS",
    userhost: "USERHOST",	ison: "ISON",	server: "SERVER",	njoin: "NJOIN"
  }

  # Generate function clauses for each command pair
  @commands
  |> Enum.each(fn {command, string} ->
    defp do_from_string(unquote(string)), do: unquote(command)
    defp do_to_string(unquote(command)), do: unquote(string)
  end)

  # Define a catchall, error-producing case
  defp do_from_string(_string), do: {:error, "Unrecognized command"}
  defp do_to_string(_atom), do: {:error, "Unrecognized command"}

end
