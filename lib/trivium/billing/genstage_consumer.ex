defmodule Trivium.Tracker.Consumer do
  @moduledoc false
  use GenStage
  alias Trivium.Repo
  alias Trivium.Billing.{Stat}

  def start_link(_opts) do
    GenStage.start_link(Trivium.Tracker.Consumer, :ok)
  end

  def init(:ok) do
    # {:consumer, :the_state_does_not_matter}
    {:consumer, :the_state_does_not_matter, subscribe_to: [Trivium.Tracker.ProducerConsumer]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    # Process.sleep(100)

    # Inspect the events.

    events |> length() |> IO.inspect(label: "#{inspect(self())} processing ")

    # Repo.transaction(fn repo ->
    #   Enum.map(events, fn x ->
    #     %Stat{}
    #     |> Stat.changeset(x)
    #     |> repo.insert!()
    #   end)
    # end)

    events =
      events
      |> Enum.map(fn x ->
        x
        |> Map.put_new(:id, Ecto.UUID.generate())

        # |> Map.put_new(:inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
        # |> Map.put_new(:updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
      end)

    # |> IO.inspect(label: "entries")

    Repo.insert_all(Stat, events)
    # |> IO.inspect(label: "insert_all")

    # %Stat{}
    # |> Stat.changeset(x)

    # self() |> IO.inspect()

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end
