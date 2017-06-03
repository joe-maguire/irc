defmodule Irc.Mixfile do
  use Mix.Project

  def project do
    [app: :irc,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     deps: deps(),
     package: package(),
     source_url: "https://github.com/derpydev/irc"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:dialyxir, "~> 0.4", only: [:dev], runtime: false},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    A library for working with irc messages. This is not a client and won't
    handle your connection for you, but rather this gives you the flexibility
    to use whatever transport you need.
    """
  end

  defp package do
    [
      name: :irc,
      maintainers: ["Joe Maguire <joe.j.maguire@gmail.com>"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/derpydev/irc"}
    ]
  end
end
