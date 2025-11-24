# frozen_string_literal: true

module Parser
  extend self

  EXAMPLE = <<-TEXT
  [test brew 2](<https://moxfield.com/decks/koNKP0t1kkuVEGwgaYcg0Q>)
  [Dimir Affinity](<https://mtgdecks.net/Pauper/dimir-affinity-analysis-25689/all>) (top 47): Basics 60.617%; No Basics 58.333%
  [Sultai Affinity](<https://mtgdecks.net/Pauper/sultai-affinity-analysis-30891/all>) (top NA): Basics 56.132%; No Basics 57.259%
  [Esper Affinity](<https://mtgdecks.net/Pauper/esper-affinity-analysis-28013/all>) (top 17): Basics 52.09%; No Basics 52.9%
  [Grixis Affinity](<https://mtgdecks.net/Pauper/grixis-affinity-analysis-7478/all>) (top 7): Basics 45.728%; No Basics 45.773%
  [Esper Metalcraft](<https://mtgdecks.net/Pauper/esper-metalcraft-analysis-30982/all>) (top 66): Basics 42.731%; No Basics 42.064%
  TEXT

  def parse(raw_message = EXAMPLE)
    lines = raw_message.split("\n")

    return if lines.nil?

    raw_source_deck = lines.shift

    [raw_source_deck, lines.map { parse_line(_1) }.compact]
  end

  private

  LINE_REGEX = /
  \[
    (?<name>[^\]]+)
  \]
  \(<
    (?<url>[^>]+)
  >\)
  \s*
  \(top\s+(?<top>\d+|NA)\):
  \s*Basics\s+(?<basics>[\d.]+)%;
  \s*No\s+Basics\s+(?<nobasics>[\d.]+)%
/x.freeze

  def parse_line(line)
    match = LINE_REGEX.match(line) or return nil

    {
      url: match[:url],
      name: match[:name],
      basics: match[:basics].to_f,
      nobasics: match[:nobasics].to_f,
      top: match[:top] == 'NA' ? nil : match[:top].to_i
    }
  end
end
