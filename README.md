# Elixir IRC package [![Build Status](https://travis-ci.org/derpydev/irc.svg?branch=master)](https://travis-ci.org/derpydev/irc)

A small, simple library for working with the IRC protocol without any assumptions
about your use case. This library does not manage any connection for you; it is
only meant to provide an abstraction for easily working with the protocol.

## Goals
[ ] Compliant with RFC 1459
[ ] Supports IRCv3.x
[ ] Fully typespec'd
[ ] Stable API
[ ] Fully tested

## Installation

The package can be installed by adding `irc` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [{:irc, "~> 0.1.0"}]
end
```

The docs can be found at [https://hexdocs.pm/irc](https://hexdocs.pm/irc).
