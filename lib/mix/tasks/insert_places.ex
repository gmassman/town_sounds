defmodule Mix.Tasks.InsertPlaces do
  use Mix.Task
  import Mix.Ecto
  import Mix.EctoSQL
  alias TownSounds.{Repo, AutocompletePlace}

  def run(_args) do
    base_url = "https://www.bandsintown.com/cityAutocomplete?input="
    HTTPoison.start
    start_ecto()

    File.stream!("priv/cities-usa.csv")
    |> CSV.decode(headers: true)
    |> Enum.each(fn {:ok, data} ->
      base_url <> clean_city(data["City"])
      |> URI.encode
      |> HTTPoison.get!
      |> parse_body()
      |> insert_places()
    end)
  end

  def start_ecto do
    repos = parse_repo([])

    Enum.each(repos, fn repo ->
      ensure_repo(repo, [])
      {:ok, _pid, _apps} = ensure_started(repo, [])
    end)
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
    Poison.decode!(response.body)
    |> Enum.map(fn place_attrs ->
      AutocompletePlace.changeset(%AutocompletePlace{}, place_attrs)
    end)
  end

  def clean_city(city) do
    String.replace(city, ~r/\[\d+\]/, "")
  end
end
