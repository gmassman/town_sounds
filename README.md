# TownSounds

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Web Scraping
  * Run `mix insert_places` to initialize PostgreSQL database with Bandsintown place_ids
  * Run `cd assets && npm install` then `node vender/browse_bit.js` to open a Puppeteer session for a single place_id

#TODOs
  1. save HTML for first 1000 Event results (may need to add scrolling).
  2. run lots of browse_bit functions concurrently, each with their own place_id