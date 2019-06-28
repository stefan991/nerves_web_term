defmodule NervesWebTerm.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{}
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.NervesWebTerm
    |> Registry.register("TERMINAL", {})

    {:ok, state}
  end

  def websocket_handle({:text, data}, state) do
    NervesWebTerm.UART.write(data)
    {:ok, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
