defmodule NervesWebTerm.Application do
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # TODO: check superversion strategy
    opts = [strategy: :one_for_one, name: NervesWebTerm.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  def children(:host) do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: NervesWebTerm.Router,
        options: [
          dispatch: dispatch(),
          port: 8080
        ]
      )
    ]
  end

  def children(_target) do
    [
      NervesWebTerm.UART,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: NervesWebTerm.Router,
        options: [
          dispatch: dispatch(),
          port: 80
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.NervesWebTerm
      )
    ]
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws", NervesWebTerm.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {NervesWebTerm.Router, []}}
       ]}
    ]
  end
end
