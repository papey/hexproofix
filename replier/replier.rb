# frozen_string_literal: true

module Replier
  extend self

  def reply_invalid(event)
    event.message.reply!('⛔ Invalid request')
  end

  def reply_ok(event, raw_deck, config)
    event.message.reply!(
      "✅ Deck **#{raw_deck}** is legal " \
        "(rules: top threshold #{config[:top_threshold]}, " \
        "no basics threshold #{config[:nobasics_threshold]})"
    )
  end

  def reply_ko(event, raw_deck, meta_decks, config)
    list = meta_decks.map do |d|
      "- [#{d[:name]}](#{d[:url]}) (No Basics #{d[:nobasics]}%, Top #{d[:top] || 'NA'})"
    end.join("\n")

    event.message.reply!(<<~MSG)
      ❌ Deck **#{raw_deck}** is **NOT legal** (rules: top threshold #{config[:top_threshold]}, no bacics threshold #{config[:nobasics_threshold]}).
      Found similarities with meta decks:
      #{list}
    MSG
  end
end
