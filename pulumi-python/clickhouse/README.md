# clickhouse

## Pre-Req
```sh
# 0. cli tools
mise install

# 1. install deps
uv venv
source .venv/bin/activate
uv sync --all-extras

# 2. install goose - if you need db-migrations to be applied
go install github.com/pressly/goose/v3/cmd/goose@v3.24.0
```

## Deploy
```sh
# 0. pulumi cli setup
## 1 configure clickhouse env var - get from https://console.clickhouse.cloud
export CLICKHOUSE_ORG_ID=<org-id>
export CLICKHOUSE_TOKEN_KEY=<token-key>
export CLICKHOUSE_TOKEN_SECRET=<token-secret>

## 2 stack init
pulumi stack init dev
# pulumi stack init prod

## 3 provision resources - take ~4min
pulumi preview
pulumi up
```
