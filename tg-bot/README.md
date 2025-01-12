# tg-bot

Telegram bot with ElizaOS

## Pre-Requisites
- anthropic api key
- telegram bot token
  - [How to create a Telegram bot](https://core.telegram.org/bots#how-do-i-create-a-bot)

## Run

```sh
pnpm i
```

```sh
# update telegram bot token and anthropic api key
cp .env.example .env

# fmt
pnpm fmt

# build and run
pnpm run build
pnpm start --characters=characters/trump.character.json
```
