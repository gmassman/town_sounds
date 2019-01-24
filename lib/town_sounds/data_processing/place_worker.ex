defmodule TownSounds.DataProcessing.PlaceWorker do
  require Apex
  use GenServer, restart: :transient
  alias TownSounds.DataProcessing.{PlaceScraper, JSRunner}

  ## Client API

  def start_link(place_id) do
    GenServer.start_link(__MODULE__, [place_id])
  end

  def finished_scraping(pid) do
    GenServer.call(pid, :finished_scraping)
  end

  ## GenServer callbacks

  @impl true
  def init([place_id]) do
    spawn_link(fn -> perform_init(place_id) end)
    {:ok, 0}
  end

  defp perform_init(place_id) do
    fifo_channel = "BIT_CHANNEL:#{place_id}"

    # subscribe to Redis channel
    {:ok, pubsub} = Redix.PubSub.start_link()
    {:ok, ref} = Redix.PubSub.subscribe(pubsub, fifo_channel, self())

    # exec a node script to publish to the channel
    fifo_writer = spawn_link(fn -> JSRunner.start(place_id, fifo_channel, self()) end)

    Apex.ap(["started pubsub and fifo_writer", {pubsub, fifo_writer}])

    # run PlaceScraper to process data from channel
    loop(pubsub, ref, fifo_channel, place_id)
  end

  defp loop(pubsub, ref, channel, place_id) do
    receive do
      {:redix_pubsub, ^pubsub, ^ref, :subscribed, %{channel: ^channel}} -> :ok
      {:redix_pubsub, ^pubsub, ^ref, :message, %{channel: ^channel, payload: payload}} ->
        spawn(fn -> PlaceScraper.consume(payload, place_id) end)
    end
    loop(pubsub, ref, channel, place_id)
  end

  @impl true
  def handle_cast(:finished_scraping, _state) do
    {:noreply, Process.exit(self(), :normal)}
  end
end
