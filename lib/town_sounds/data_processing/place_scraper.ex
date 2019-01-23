defmodule TownSounds.DataProcessing.PlaceScraper do
  require Apex

  def process(raw_html) do
    Apex.ap(raw_html)
  end

  @doc """
    This module is listens for data arriving on the FIFO
    On new data, it is parsed and inserted into the database
  """
  # def start(fifo_path) do
  #   IO.inspect("reading from #{fifo_path}")
  #   port = Port.open({:spawn, "tail -f #{fifo_path}"}, [:eof])
  #   loop(port)
  # end

  # def loop(port) do
  #   receive do
  #     {port, {:data, data}} -> Apex.ap([port, "got some #{length(data)} bytes"])
  #     {port, :closed} -> Apex.ap([port, "port closed"]); Port.close(port)
  #     {:EXIT, port, reason} -> Apex.ap([":EXIT for some reason...", port, reason]); Port.close(port)
  #   end
  #   loop(port)
  # end
end
