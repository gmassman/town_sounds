defmodule TownSoundsWeb.PageController do
  use TownSoundsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
