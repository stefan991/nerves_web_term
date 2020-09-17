defmodule NervesWebTerm.UART do
  use GenServer

  # TODO: make configurable
  @baudrate 115200
  @port "ttyAMA0"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def write(data) do
    GenServer.call(__MODULE__, {:write, data})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, uart} = Circuits.UART.start_link()
    opts = [speed: @baudrate, active: true]
    :ok = Circuits.UART.open(uart, @port, opts)
    state = %{uart: uart}
    {:ok, state}
  end

  def handle_call({:write, data}, _from, %{uart: uart} = state) do
    {:reply, Circuits.UART.write(uart, data), state}
  end

  def handle_info({:circuits_uart, _uart, data}, state) do
    Registry.NervesWebTerm
    |> Registry.dispatch("TERMINAL", fn entries ->
      for {pid, _} <- entries do
        Process.send(pid, {:send, data}, [])
      end
    end)

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
