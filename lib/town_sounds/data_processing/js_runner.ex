defmodule TownSounds.DataProcessing.JSRunner do
  alias TownSounds.DataProcessing.PlaceWorker

  @doc """
    Run scrape_bit.js code with the proper environment.
    If the program terminates properly, send a message to parent to stop working
  """
  def start(place_id, fifo_channel, parent) do
    cd_path = File.cwd! <> "/assets"
    IO.inspect(place_id)
    env_vars = [
      {"SCROLL_DOWN_EVENTS", "1000"},
      {"PLACE_ID", place_id},
      {"FIFO_CHANNEL", fifo_channel}
    ]

    IO.inspect("starting writer to #{fifo_channel}...")
    case System.cmd("node", ["vendor/scrape_bit.js"], cd: cd_path, env: env_vars) do
      {ret, 0} -> done(ret, parent)
      _ -> IO.inspect("bad error?!?")
    end
  end

  defp done(ret, parent) do
    Apex.ap(["done scraping!", ret])
    PlaceWorker.finished_scraping(parent)
  end
end
