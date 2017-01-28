defmodule Irc.Message do
  @moduledoc """
  """

  alias __MODULE__, as: Message

  defstruct prefix: nil, command: nil, params: nil

  def from_string(":" <> rest) do

  end


end
