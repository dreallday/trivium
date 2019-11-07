defmodule Trivium.Tracker.ProducerConsumer do
  use GenStage

  def start_link(:ok) do
    GenStage.start_link(Trivium.Tracker.ProducerConsumer, :ok,
      name: Trivium.Tracker.ProducerConsumer
    )
  end

  def init(:ok) do
    # {:producer_consumer, multiplier}
    Process.send_after(self(), :ask, 1000)
    {:producer_consumer, %{}, subscribe_to: [Trivium.Tracker.Producer]}
  end

  def handle_events(events, _from, producers) do
    # IO.puts("#{inspect(self())} processing #{length(events)}")
    # events |> IO.inspect()
    {:noreply, events, producers}
  end

  def handle_info(:ask, %{producer: producer} = state) do
    # state |> IO.inspect(label: "handle_info in pc")
    GenStage.ask(producer, 100)

    Process.send_after(self(), :ask, 1000)
    {:noreply, [], state}
  end

  # Handle Subscription for Producer manually
  def handle_subscribe(:producer, _opts, from, producers) do
    # from |> IO.inspect(label: "handle_subscribe from")
    producers = producers |> Map.put(:producer, from)
    {:manual, producers}
  end

  # Make the subscriptions to auto for consumers
  def handle_subscribe(:consumer, _opts, _from, state) do
    {:automatic, state}
  end
end
