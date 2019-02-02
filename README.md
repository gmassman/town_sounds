# TownSounds

First, install these components. Most can be downloaded using a package manager, or from the distributors' website:

  * [Elixir](https://elixir-lang.org/install.html)
  * [Redis](https://redis.io/topics/quickstart)
  * [PostgreSQL](https://www.postgresql.org/download/)
  * [NodeJS](https://nodejs.org/en/download/)
  * [Phoenix](https://hexdocs.pm/phoenix/installation.html)

Update the default postgres password to `postgres` (so it matches what's in _config/dev.exs_):
```
$ sudo -u postgres psql
postgres=# \password postgres
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Web Scraping
  * Run `mix insert_places` to initialize PostgreSQL database with Bandsintown place_ids
  * Run `cd assets && npm install` then `node vendor/browse_bit.js` to open a Puppeteer session for a single place_id

## TODOs
  1. run lots of browse_bit functions concurrently, each with their own place_id