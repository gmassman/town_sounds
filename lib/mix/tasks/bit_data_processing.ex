defmodule Mix.Tasks.BitDataProcessing do
  use Mix.Task
  alias Mix.{Ecto, EctoSQL}
  alias TownSounds.DataProcessing.SystemSupervisor

  def run(args) when is_list(args) do
    start_ecto()
    {:ok, pid} = SystemSupervisor.start
    Apex.ap(["running supervisor pid with children...", pid, Supervisor.count_children(pid)])
    IO.inspect("sleeping, waiting for childs to suicide")
    :timer.sleep(2000)
    Apex.ap(["running supervisor pid with children...", pid, Supervisor.count_children(pid)])
    # IO.inspect(Process.info(pid))
    # IO.inspect()
    # IO.inspect(Supervisor.which_children(pid))
    # {_, child_pid, _, [TownSounds.DataProcessing.PlaceWorker]} = hd(Supervisor.which_children(pid))
    # TownSounds.DataProcessing.PlaceWorker.increment(child_pid)
    # TownSounds.DataProcessing.PlaceWorker.increment(child_pid)
    # TownSounds.DataProcessing.PlaceWorker.increment(child_pid)
    # TownSounds.DataProcessing.PlaceWorker.report(child_pid)
    # :observer.start
    run()
  end

  defp run do
    # :timer.sleep(10000)
    run()
  end

  defp start_ecto do
    repos = Ecto.parse_repo([])

    Enum.each(repos, fn repo ->
      Ecto.ensure_repo(repo, [])
      {:ok, _pid, _apps} = EctoSQL.ensure_started(repo, [])
    end)
  end
end
