defmodule NervesWebTerm.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # TODO: check superversion strategy
    opts = [strategy: :one_for_one, name: NervesWebTerm.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: NervesWebTerm.Worker.start_link(arg)
        # {NervesWebTerm.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
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

  def target() do
    Application.get_env(:nerves_web_term, :target)
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
