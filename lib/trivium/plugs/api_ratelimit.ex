defmodule Trivium.Plug.RateLimit do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def init(options), do: options
  # def call(conn, options), do: rate_limit(conn, options)

  def call(conn, options \\ []) do
    case check_rate(conn, options) do
      # Do nothing, allow execution to continue
      {:ok, _count} -> conn
      {:error, count} -> render_error(conn, count)
    end
  end

  defp check_rate(conn, options) do
    interval_milliseconds = options[:interval_seconds] * 1000
    max_requests = options[:max_requests]
    ExRated.check_rate(bucket_name(conn), interval_milliseconds, max_requests)
  end

  # Bucket name should be a combination of ip address and request path, like so:
  #
  # "127.0.0.1:/api/v1/authorizations"
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    "#{ip}:#{path}" |> IO.inspect(label: "ip:path")
  end

  defp render_error(conn, count) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Rate limit exceeded. #{count}"})
    # Stop execution of further plugs, return response now
    |> halt()
  end
end
