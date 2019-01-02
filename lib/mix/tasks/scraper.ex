defmodule Mix.Tasks.Scraper do
  use Mix.Task

  def run(place_id) do
    IO.inspect bit_response(place_id).body
  end

  defp bit_response(place_id) do
    HTTPoison.start
    url = "https://www.bandsintown.com/?place_id=#{place_id}"
    HTTPoison.get!(url)
  end
end

# place_ids
# ChIJheeDikBgYIgRqiiHiR8mcSQ
# ChIJIQBpAG2ahYAR_6128GcTUEo
# ChIJ50eLV9cCBYgRhHtBtSIZX0Q
