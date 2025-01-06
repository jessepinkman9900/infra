# db-migrations

- clickhouse object definitions (data definition)
  - databases
  - tables
  - materialised view

## Tools
- [goose](https://github.com/pressly/goose)
```sh
go install github.com/pressly/goose/v3/cmd/goose@v3.24.0
```
- [chartdb](https://app.chartdb.io/)
  - visualise schema & dependencies

## Development
### Add new migrations
```sh
# root dir
cd migrations
goose -s create <file_name> sql
```

## Deployment
### Local
```sh
# 1. run clickhouse & clickhouse ui on local
docker compose up -d
# UI - http://localhost:5521
# DB - http://localhost:8123
# 2. apply migrations
goose -env .env.docker up
# goose -env .env.docker up-by-one
# goose -env .env.docker down
```
