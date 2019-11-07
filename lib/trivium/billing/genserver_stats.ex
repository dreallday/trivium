defmodule Trivium.Tracker do
  use GenServer
  alias Trivium.Repo
  alias Trivium.Billing.{Stat}
  # alias Trivium

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_call(:dequeue, _from, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def handle_call(:queue, _from, state), do: {:reply, state, state}

  def handle_cast({:enqueue, value}, state) do
    {:noreply, state ++ [value]}
  end

  def handle_cast({:save, stat_attrs}, state) do
    # Billing.create_stat(stat_attrs)
    %Stat{}
    |> Stat.changeset(stat_attrs)
    |> Repo.insert()

    # |> IO.inspect(label: "create_stat")
    # {:noreply, state}
    {:stop, :normal, state}
  end

  def terminate(reason, state) do
    # IO.puts("server is terminating because of #{inspect(reason)}")
    # inspect(state)
    # :ok
    {reason, state}
  end

  ### Client API / Helper functions

  def start(options \\ []) do
    GenServer.start(__MODULE__, [], options)
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
    # GenServer.stop(__MODULE__, :normal)
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def save(stat_attrs), do: GenServer.cast(__MODULE__, {:save, stat_attrs})
  def save(pid, stat_attrs), do: GenServer.cast(pid, {:save, stat_attrs})

  def queue, do: GenServer.call(__MODULE__, :queue)
  def enqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
end
