defmodule Trivium.Plug.RateLimit do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  import Ecto.Query, warn: false
  alias Trivium.Repo
  alias Trivium.Cache
  alias Trivium.Private.Token
  alias Trivium.Users.User
  alias Trivium.Billing.Plan

  def init(options), do: options
  # def call(conn, options), do: rate_limit(conn, options)

  def call(
        %Plug.Conn{params: params, request_path: request_path, query_string: query_string} = conn,
        options \\ []
      ) do
    params |> IO.inspect(label: "call params")
    options |> IO.inspect(label: "call options")
    # Pow.Plug.current_user(conn) |> IO.inspect(label: "pow current user")
    # options =
    #   get_user_from_token(params["key"])
    #   |> case do
    #     {:ok, options} ->
    #       options

    #     {:error, _} ->
    #       options
    #   end

    options =
      params["key"]
      |> get_options_from_token_cache()
      |> case do
        {:ok, options} ->
          options

        {:error, :unauthorized} ->
          nil
      end
      |> IO.inspect(label: "call get_options_from_token_cache")

    # case check_rate(conn, options) do
    #   # Do nothing, allow execution to continue
    #   {:ok, _count} -> conn
    #   {:error, count} -> render_error(conn, count)
    # end

    cond do
      options == nil ->
        conn
        |> render_error_unauthorized()
        |> halt()

      true ->
        options
        |> check_rate_v2()
        |> IO.inspect(label: "call check_rate_v2")
        |> case do
          # Do nothing, allow execution to continue
          {:ok, _count} -> conn
          {:error, count} -> render_error(conn, count)
        end
    end
  end

  defp get_options_from_token_cache(token) do
    token
    |> Cache.get()
    |> case do
      nil ->
        token
        |> get_user_from_token()
        |> case do
          {:ok, options_from_db} ->
            {:ok, Cache.set(token, options_from_db, ttl: 3600)}

          {:error, _} ->
            {:error, :unauthorized}
        end

      token ->
        {:ok, token}
    end
  end

  defp get_user_from_token(token) do
    from(t in Token,
      left_join: u in assoc(t, :user),
      left_join: p in assoc(u, :plan),
      where: [token: ^token],
      preload: [
        user: {
          u,
          plan: p
        }
      ]
    )
    |> not_deleted()
    |> Repo.one()
    |> case do
      %Token{
        id: id,
        user: %User{
          plan: %Plan{
            request_limit: request_limit,
            request_limit_interval: request_limit_interval
          }
        }
      } ->
        {:ok,
         %{
           user_id: id,
           request_limit: request_limit,
           request_limit_interval: request_limit_interval
         }}

      _ ->
        {:error, :unauthorized}
    end
  end

  defp check_rate_v2(options) do
    interval_milliseconds = options[:request_limit_interval] * 1000
    max_requests = options[:request_limit]
    ExRated.check_rate(options[:id], interval_milliseconds, max_requests)
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
    "#{ip}:#{path}"
  end

  defp not_deleted(query) do
    from(q in query, where: is_nil(q.deleted_at))
  end

  defp render_error(conn, count) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Rate limit exceeded. (#{count})"})
    # Stop execution of further plugs, return response now
    |> halt()
  end

  defp render_error_unauthorized(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Unauthorized"})
    # Stop execution of further plugs, return response now
    |> halt()
  end
end
