# TownSounds

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Make sure Redis is installed and running on `localhost:6379`. Test connecting to the server with `$ redis-cli`

## Web Scraping
  * Run `mix insert_places` to initialize PostgreSQL database with Bandsintown place_ids
  * Run `mix bit_data_processing` to start scraping the website and populating the database tables.
  <!-- * Run `cd assets && npm install` then `node vendor/scrape_bit.js` to open a Puppeteer session for a single place_id -->

## TODOs
  1. run lots of browse_bit functions concurrently, each with their own place_id