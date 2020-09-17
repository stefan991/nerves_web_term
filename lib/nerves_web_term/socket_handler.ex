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
    # TODO: make this an option
    # replace DEL with BS
    # the rc2014 software needs this for backspace to work properly.
    # minicom does this as well by default
    # picocom needs the option: --omap delbs
    # see https://wiki.archlinux.org/index.php/Working_with_the_serial_console#picocom
    # there seems to be some greater confusion about this...
    # https://www.cs.colostate.edu/~mcrob/toolbox/unix/keyboard.html
    replaced_data = String.replace(data, "\x7F", "\x08")

    NervesWebTerm.UART.write(replaced_data)
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
