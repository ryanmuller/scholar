require "./command"

module Agent
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      class << self
        attr_accessor :commands
        attr_accessor :global_commands
      end
    end
    base.commands = {}
    base.global_commands = {}
  end

  def <<(msg)
    commands.each do |key, command|
      if command.match?(msg)
        (command.agent || self).send(command.name, command.parse(msg)) and return true
      end
    end
    return false
  end

  def commands
    self.class.commands
  end

  def global_commands
    self.class.global_commands
  end

  module ClassMethods
    def global_command(name, key)
      global_commands[key] = Command.new(name, key)
    end

    def command(name, key)
      commands[key] = Command.new(name, key)
    end
  end
end
