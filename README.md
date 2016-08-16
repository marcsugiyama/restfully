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
GET    | /counters/:id/next | syncronhous increment counter and get new value
GET    | /counters/:id/incr | asynchronous increment counter and get old value
PUT    | /delay/http_millis/:value | delay for counters/:id/incr http request (default 100)
PUT    | /delay/delay_millis/:value | delay for counters/:id/incr serialized counter (default 100)
GET    | /ets/bomb | trigger too many ets tables alarm
GET    | /ets/defuse | clear too many ets tables alarm state
GET    | /process/bomb | trigger too many processes alarm
GET    | /process/defuse | clear too many processes state
GET    | /atom/bomb | trigger too many atoms alarm

# Notes on Endpoints

## /counters/:id/incr

GET on /counters/:id/incr is asynchronous. The http response is
sent immediately. A message is cast to a gen_server to increment
the counter. The http_millis delay is the number of milliseconds
delay added before sending the http response. This is meant to
simulate internal processing. The delay_millis delay is the
number of milliseconds delay between handling each message processed
by the gen_server. Each /counters/:id/incr GET sends 101 messages
to the gen_server. The large number of messages allows the message
queue to grow faster. Tune the delays and the number of clients
to adjust the growth and consumption rate of the message queue.

## /counters/:id/next

GET on /counters/:id/next is synchronous, That is, the http response is
sent after the database is updated. Note that the default
Postgres isolation rules to not serialize writes, so concurrent
GETs on /counters/:id/next may overwrite one another. That is,
1000 GETs on /counters/:id/next using 4 clients may not result in
the counter incremented by 1000. The delay_millis delay is the
number of milliseconds taken to update the counter. This is meant to
simulate processing time. GET on /counters/:id/next does not
use the https_millis delay.

## Create counter
```
curl --header "Content-Type: application/json" --data-raw '{"counter": {"name": "fifty", "count": 0}}' http://localhost:4000/counters
```

# Demonstrating Long Message Queue Alarm

1. Use POST /counters to create a new counter.
2. Monitor message queue length (Process,Sum message queue length)
3. Use a benchmarking tool to GET /counters/:id/incr
4. Wait for the message queue length alarm

Speed up the queue drain rate by changing delay_millis:
```
curl -X PUT http://localhost:4000/delay/delay_millis/0
```
