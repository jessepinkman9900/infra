# redpanda connect websocket source

## Dataflow
```mermaid
flowchart LR
  websocket_api
  redpanda_connect
  redpanda_cluster
  redpanda_console

  websocket_api <--listen for new messages--> redpanda_connect
  redpanda_connect --push to topic - __raw-allmids__--> redpanda_cluster
  redpanda_connect -.ui.-> redpanda_console
  redpanda_cluster -.ui.-> redpanda_console
```

## Run
```sh
docker compose up -d
# console - http://localhost:8080
```

