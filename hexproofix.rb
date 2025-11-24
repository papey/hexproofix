# frozen_string_literal: true

require 'discordrb'

require_relative 'parser/parser'
require_relative 'validator/validator'
require_relative 'replier/replier'

REQUIRED_ENV = %w[
  DISCORD_CLIENT_ID
  DISCORD_TOKEN
  DISCORD_BOT_NAME
  REACT_TO_USER
].freeze

def ensure_required_env!
  missing = REQUIRED_ENV.reject { |var| ENV[var]&.strip&.length&.positive? }
  raise "Missing required environment variables: #{missing.join(', ')}" if missing.any?
end

def load_config
  {
    top_threshold: ENV.fetch("TOP_THRESHOLD", "50").to_i,
    nobasics_threshold: ENV.fetch("NO_BASICS_THRESHOLD", "50").to_i
  }
end

ensure_required_env!
config = load_config

REACT_TO_USER = ENV["REACT_TO_USER"].to_i

bot = Discordrb::Bot.new(
  client_id: ENV["DISCORD_CLIENT_ID"],
  token: ENV["DISCORD_TOKEN"],
  name: ENV["DISCORD_BOT_NAME"]
)

bot.message_edit do |event|
  next unless event.user.id == REACT_TO_USER

  input = event.message.content.strip

  raw_deck, similar_decks = Parser.parse(input)
  next if similar_decks.empty?

  valid, meta_decks = Validator.validate(similar_decks, config)

  if valid
    Replier.reply_ok(event, raw_deck, config)
  else
    Replier.reply_ko(event, raw_deck, meta_decks, config)
  end
end

bot.run
