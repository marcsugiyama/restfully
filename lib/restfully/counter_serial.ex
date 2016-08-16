defmodule Restfully.CounterSerial do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def transaction(tfun) do
        GenServer.call(__MODULE__, {:transaction, tfun}, :infinity)
    end

    def async_transaction(tfun) do
        GenServer.cast(__MODULE__, {:transaction, tfun})
    end

    def init _args do
        {:ok, :state}
    end

    def handle_call {:transaction, tfun}, _from, state do
        reply = tfun.()
        simulated_delay()
        {:reply, reply, state}
    end
    
    def handle_cast {:transaction, tfun}, state do
        tfun.()
        simulated_delay()
        {:noreply, state}
    end

    def simulated_delay() do
        Restfully.Sleep.simulated_delay(:delay_millis)
    end
end

