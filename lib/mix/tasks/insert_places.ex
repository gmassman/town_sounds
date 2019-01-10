defmodule Mix.Tasks.InsertPlaces do
  use Mix.Task
  import Mix.Ecto
  import Mix.EctoSQL
  alias TownSounds.{Repo, AutocompletePlace}

  def run(_args) do
    base_url = "https://www.bandsintown.com/cityAutocomplete?input="
    HTTPoison.start
    start_ecto()

    lines = File.stream!("priv/cities-usa.csv") |> CSV.decode(headers: true)
    for {:ok, data} <- lines do
      base_url <> String.replace(data["City"], ~r/\[\d+\]/, "")
      |> URI.encode
      |> HTTPoison.get!
      |> parse_body()
      |> insert_places()
    end
  end

  def insert_places(places) do
    Enum.each(places, fn place ->
      case Repo.insert(place) do
        {:ok, p} -> p
        {:error, not_place} -> IO.inspect(not_place)
      end
    end)
  end

  def parse_body(response) do
    Poison.decode!(response.body) |> Enum.map(&(AutocompletePlace.changeset(%AutocompletePlace{}, &1)))
  end

  def start_ecto do
    repos = parse_repo([])

    Enum.each(repos, fn repo ->
      ensure_repo(repo, [])
      {:ok, _pid, _apps} = ensure_started(repo, [])
    end)
  end
end
