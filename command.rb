class Command
  attr_reader :name
  attr_reader :key
  attr_accessor :agent

  def initialize(name, key)
    @name = name
    @key = key || name.chars.first
  end

  def match?(msg)
    msg =~ /^(#{name}|#{key})\b/
  end

  def parse(msg)
    msg.sub(/^(#{name}|#{key})\b/, "").strip
  end
end
