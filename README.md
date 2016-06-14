# Restfully

Phoenix server for demonstrating Wombat.

# Requirements

1. Elixir
2. Phoenix
3. Postgres

# Starting

1. get dependencies - mix deps.get
2. compile - mix compile
3. create database - mix ecto.create
4. add Restfully tables - mix ecto.migrate
5. start server with node name - iex --name restfully@127.0.0.1 --cookie cookie -S mix phoenix.server


# Endpoints

Base URL: http://localhost:4000/

Action | Endpoint | Description
------ | -------- | -----------
GET    | /counters | list counters
POST   | /counters | create new counter
GET    | /counters/:id | retrieve counter
GET    | /counters/:id/next | increment counter and get new value
