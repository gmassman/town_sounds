defmodule TownSounds.DataProcessing.SystemSupervisor do
  require Apex
  import Ecto.Query, only: [from: 2]
  alias TownSounds.{Repo, AutocompletePlace}
  alias TownSounds.DataProcessing.PlaceWorker

  @doc """
    For each place_id, spawn a worker to fetch bandsintown data
  """
  def start do
    children =
      Repo.all(from AutocompletePlace, select: [:place_id], limit: 4)
      |> Enum.map(fn p ->
        Supervisor.child_spec({PlaceWorker, p.place_id}, id: String.to_atom("place_worker_#{p.place_id}"))
      end)

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
