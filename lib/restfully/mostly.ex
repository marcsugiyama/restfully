defmodule Restfully.Mostly do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def call() do
        GenServer.call(__MODULE__, :call)
    end

    def init _args do
        {:ok, state(0, nil)}
    end

    def handle_call :call, _, state do
        maybe_reply(state)
    end

    defp maybe_reply(%{:success => success, :failure_at => nil}) do
        {:reply, :ok, state(success + 1, failure_at())}
    end

    defp maybe_reply(%{:success => success, :failure_at => success}) do
        {:noreply, state(0, nil)}
    end

    defp maybe_reply(%{:success => success, :failure_at => failure_at}) do
        {:reply, :ok, state(success + 1, failure_at)}
    end

    defp state(success, failure_at) do
        %{:success => success, :failure_at => failure_at}
    end

    defp failure_at do
        :rand.uniform(10000)
    end

end

