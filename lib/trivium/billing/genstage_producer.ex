defmodule Trivium.Tracker.Producer do
  use GenStage

  def start_link(number) do
    GenStage.start_link(Trivium.Tracker.Producer, number, name: Trivium.Tracker.Producer)
  end

  # def init(counter) do
  #   {:producer, counter}
  # end

  # def handle_demand(demand, counter) when demand > 0 do
  #   # If the counter is 3 and we ask for 2 items, we will
  #   # emit the items 3 and 4, and set the state to 5.
  #   demand |> IO.inspect(label: "demand")
  #   counter |> IO.inspect(label: "counter")
  #   events = Enum.to_list(counter..(counter + demand - 1))
  #   {:noreply, events, counter + demand}
  # end

  def add(event) do
    GenStage.cast(__MODULE__, {:add, event})
  end

  ## Callbacks
  def init(:ok) do
    q = :queue.new()
    {:producer, q}
  end

  def handle_cast({:add, event}, q) do
    nq = :queue.in(event, q)
    # |> IO.inspect(label: "insert event")
    {:noreply, [], nq}
  end

  def handle_demand(demand, q) when demand > 0 do
    case :queue.is_empty(q) do
      true ->
        {:noreply, [], q}

      false ->
        {events, q, demand} = take([], q, demand)
        {:noreply, events, q}
    end
  end

  def take(events, q, items) do
    case :queue.out(q) do
      {:empty, q} ->
        {events, q, items}

      {{:value, out}, q} ->
        take(events ++ [out], q, items - 1)
    end
  end
end
