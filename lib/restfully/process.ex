defmodule Restfully.Process do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def bomb() do
        GenServer.cast(__MODULE__, :bomb)
    end

    def defuse() do
        GenServer.cast(__MODULE__, :defuse)
    end

    def init _args do
        {:ok, []}
    end

    def handle_cast :bomb, [] do
        processes = spawn_processes
        {:noreply, processes}
    end

    def handle_cast :defuse, processes do
        kill_processes(processes)
        {:noreply, []}
    end

    def handle_cast _, processes do
        {:noreply, processes}
    end

    defp spawn_processes do
        process_limit = :erlang.system_info(:process_limit)
        process_count = length(:erlang.processes())
        create_count = process_limit - process_count - 100
        Enum.map(1..create_count, fn(_) -> spawn &child_loop/0 end)
    end

    defp kill_processes(processes) do
        Enum.each(processes, fn(pid) -> send pid, :exit end)
    end

    defp child_loop do
        receive do
            :exit -> :ok
        end
    end
end

