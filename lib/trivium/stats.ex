defmodule Trivium.Stats do
  use GenServer
  alias Trivium.Repo

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


  def handle_cast({:save, value}, state) do
    

    {:noreply, state}
  end

  ### Client API / Helper functions

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end


  def save(pid, value), do: GenServer.call(pid, {:save, value})
  def queue, do: GenServer.call(__MODULE__, :queue)
  def enqueue(value), do: GenServer.cast(__MODULE__, {:enqueue, value})
  def dequeue, do: GenServer.call(__MODULE__, :dequeue)
end
