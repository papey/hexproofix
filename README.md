# 🪄 Hexproofix, the MTG Deck Validator Bot

Hexproofix is a Ruby app used to validate **Magic: The Gathering decks** directly from **Discord** messages.
It checks similarity against known meta decks, applies internal rules, and responds automatically.

## Getting Started

### Prerequisites

* [Ruby](https://www.ruby-lang.org/)
* [Bundler](https://bundler.io/)
* A Discord bot token
* A Discord server where your bot is invited

### Install

```sh
bundle install
```

### Configuration (ENV)

Hexproofix relies on environment variables for configuration.

**Required variables:**

* `DISCORD_CLIENT_ID`
* `DISCORD_TOKEN`
* `DISCORD_BOT_NAME`
* `REACT_TO_USER` — only this user ID will be processed by the bot

**Optional variables:**

* `TOP_THRESHOLD` (default: 50)
* `NO_BASICS_THRESHOLD` (default: 50)

Example:

```sh
export DISCORD_CLIENT_ID=123
export DISCORD_TOKEN=ABC
export DISCORD_BOT_NAME=Hexproofix
export REACT_TO_USER=123456789012345678
export TOP_THRESHOLD=60
export NO_BASICS_THRESHOLD=40
```

### Usage

Start the bot:

```sh
bundle exec ruby hexproofix.rb
```

Once running, Hexproofix listens for messages or **edited messages** from the authorized user and validates decks.

It will:

* Listen for metacompare commands messages
* Apply validation rules (top threshold, no-basics threshold)
* Reply with:
    * A **green check** if the deck is legal
    * A **red cross** with details if it is not

### Docker container

You can run Hexproofix using Docker:

```bash
docker build -t hexproofix .
```

Then run it:

```bash
docker run -it --rm \
  -e DISCORD_CLIENT_ID=... \
  -e DISCORD_TOKEN=... \
  -e DISCORD_BOT_NAME=Hexproofix \
  -e REACT_TO_USER=123456789 \
  -e TOP_THRESHOLD=50 \
  -e NO_BASICS_THRESHOLD=50 \
  hexproofix
```

## Authors

- **Wilfried OLLIVIER** - _Main author_ - [Papey](https://github.com/papey)

## License

See the [LICENSE](LICENSE) file for details.
