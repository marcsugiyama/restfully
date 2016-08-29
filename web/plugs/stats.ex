defmodule Restfully.StatsPlug do  
    @behaviour Plug
    import Plug.Conn, only: [register_before_send: 2]
    use Elixometer

    def init(opts), do: opts

    def call(conn, _opts) do
        start_time = :os.timestamp

        register_before_send conn, fn conn ->
            method = conn.method
            status = conn.status
            path_info = conn.path_info
            method_count(method)
            status_count(status, method)
            resource_count(path_info, status, method)
            duration = div(:timer.now_diff(:os.timestamp, start_time), 1000)
            request_time(duration, path_info, status, method)
            conn
        end
    end

    defp method_count(method) do
        update_spiral(metric(method), 1)
    end

    defp status_count(status, method) do
        update_spiral(metric(status, method), 1)
    end

    defp resource_count([resource | _], status, method) do
        update_spiral(metric(resource, status, method), 1)
    end
    defp resource_count(_, status, method) do
        update_spiral(metric("none", status, method), 1)
    end

    defp request_time(_duration, [_resource | _], _status, _method) do
#       update_histogram(metric(duration, resource, status, method), duration)
        :ok
    end

    # metric name
    defp metric(method) when is_binary(method) do
        method <> "_count"
    end
    defp metric(_) do
        "unknown_method_count"
    end

    defp metric(status, method) when is_integer(status) and is_binary(method) do
        method <> "_#{status}_count"
    end
    defp metric(_, _) do
        "unknown_method_status_count"
    end
 
    defp metric(resource, status, method) when is_binary(resource) and is_integer(status) and is_binary(method) do
        resource <> "_" <> method <> "_#{status}_count"
    end
    defp metric(_, _, _) do
        "unknown_resource_method_status_count"
    end
  
#   defp metric(_, resource, status, method) when is_binary(resource) and is_integer(status) and is_binary(method) do
#       resource <> "_" <> method <> "_#{status}_millis"
#   end
#   defp metric(_, _, _, _) do
#       "unknown_resource_method_status_millis"
#   end
end
