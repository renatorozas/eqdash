# Eqdash

Live earthquakes dashboard.

## Dependencies

  * Node 5.5+
  * Elixir 1.2+
  * Phoenix Framework 1.1.4
  * PostgreSQL 8.X+
  * Elm 0.16

## Getting started

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Install Elm packages: 

  ```
  cd web/elm
  elm package install -y
  elm package install evancz/elm-html -y
  ```

  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
