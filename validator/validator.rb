# frozen_string_literal: true

module Validator
  module_function

  def validate(compared_decks, config)
    meta_decks = compared_decks.select do |deck|
      top = deck[:top]
      next false if top.nil? || top >= config[:top_threshold]

      top < config[:top_threshold] && deck[:nobasics].to_f > config[:nobasics_threshold]
    end

    [meta_decks.empty?, meta_decks]
  end
end
