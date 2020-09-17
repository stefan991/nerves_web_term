defmodule NervesWebTerm.SocketHandler do
  @behaviour :cowboy_websocket

  @ping_time 20000

  def init(request, _state) do
    state = %{}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.NervesWebTerm
    |> Registry.register("TERMINAL", {})

    Process.send_after(self(), :send_ping, @ping_time)

    {:ok, state}
  end

  def websocket_handle({:text, data}, state) do
    NervesWebTerm.UART.write(data)
    {:ok, state}
  end

  def websocket_handle(:pong, state) do
    # do nothing...
    {:ok, state}
  end

  def websocket_info(:send_ping, state) do
    # Send ping messages to keep connection alive.
    Process.send_after(self(), :send_ping, @ping_time)

    {:reply, :ping, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
