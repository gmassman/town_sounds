defmodule Mix.Tasks.InsertEvents do
  use Mix.Task
  import Mix.Ecto
  import Mix.EctoSQL
  import Ecto.Query
  alias TownSounds.{Repo, AutocompletePlace}

  def run(_args) do
    start_ecto()

    place_ids = Repo.all(from p in AutocompletePlace, select: p.place_id)
    for place_id <- place_ids, do: create_events(place_id)
    # require IEx; IEx.pry;
  end

  def create_events(place_id) do
    HTTPoison.start

    "https://www.bandsintown.com/?place_id=" <> place_id
    |> URI.encode
    |> HTTPoison.get!
    |> IO.inspect
  end

  def start_ecto do
    repos = parse_repo([])

    Enum.each(repos, fn repo ->
      ensure_repo(repo, [])
      {:ok, _pid, _apps} = ensure_started(repo, [])
    end)
  end
end
