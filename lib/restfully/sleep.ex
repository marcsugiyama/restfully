defmodule Restfully.Sleep do
    def set_delay(key, value) do
        :application.set_env(:restfully, key, value)
    end

    def simulated_delay(key) do
        :timer.sleep(get_delay(key))
    end

    defp get_delay(key) do
        get_env(key, 100)
    end

    defp get_env(key, default) do
        case Application.get_env(:restfully, key) do
            nil -> default
            value -> value
        end
    end
end
