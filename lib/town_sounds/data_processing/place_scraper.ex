defmodule TownSounds.DataProcessing.PlaceScraper do
  require Apex
  alias TownSounds.{Repo, Event}

  @doc """
    Try parsing and inserting a chunk of html published to a BIT_CHANNEL
  """
  def consume(html, place_id) do
    html
    |> String.trim
    |> find_event_parent()
    |> insert_changeset(place_id)
  end

  def test_data do
    """
      "<div class="event-0fe45b3b"><a class="event-52550c22" href="https://www.bandsintown.com/e/100110160-herbie-hancock-at-bergen-pac?came_from=257&amp;utm_medium=web&amp;utm_source=home&amp;utm_campaign=event"></a><div class="event-49d18d61"><div class="LazyLoad is-visible" style="height: 70px; width: 70px;"><img src="https://photos.bandsintown.com/thumb/8962851.jpeg" alt="Herbie Hancock"></div></div><div class="event-02e85563"><div class="event-ad736269">FEB</div><div class="event-d7a00339">09</div></div><div class="event-38a9a08e"><h2 class="event-5daafce9"><a href="https://www.bandsintown.com/a/3506-herbie-hancock?came_from=257&amp;utm_medium=web&amp;utm_source=home&amp;utm_campaign=event">Herbie Hancock</a></h2><div class="event-a7d492f7"><div class="event-6891d84c">Bergen PAC</div><div class="event-c5863c62">Englewood, NJ</div></div></div><div class="event-b58f7990"><div class="event-ad736269">FEB</div><div class="event-d7a00339">09</div></div><div class="event-47ded5a8"><div class="event-c3967c50">Tickets &amp; RSVP</div></div></div>"
    """
    |> String.trim
  end

  defp find_event_parent(html) do
    parent_class = ".event-0fe45b3b"
    case Floki.find(html, parent_class) do
      [parent_node] when tuple_size(parent_node) == 3 -> html
      _ -> ""
    end
  end

  defp insert_changeset(html, place_id) when bit_size(html) > 0 do
    Event.changeset(%Event{}, %{
      place_id: place_id,
      html: html
    })
    |> Repo.insert
  end
  defp insert_changeset(_, _place_id) do end
end
