defmodule Restfully.Ets do
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
        tables = make_tables
        {:noreply, tables}
    end

    def handle_cast :defuse, tables do
        drop_tables(tables)
        {:noreply, []}
    end

    def handle_cast _, tables do
        {:noreply, tables}
    end

    defp make_tables do
        ets_limit = :erlang.system_info(:ets_limit)
        ets_count = length(:ets.all())
        create_count = ets_limit - ets_count - 100
        Enum.map(1..create_count, fn(_) -> :ets.new(__MODULE__, []) end)
    end

    defp drop_tables(tables) do
        Enum.each(tables, fn(tabid) -> :ets.delete(tabid) end)
    end
end

