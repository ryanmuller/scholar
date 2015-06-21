require "./agent"
require "./library"
require "./notebook"

State = Struct.new(:agent, :category, :article, :history)

class Env
  include Agent

  attr_reader :state, :notebook

  command :set_category, "c"
  command :quit, "q"

  def initialize(path)
    @agents = []
    @state = State.new(self, "inbox", nil, {})
    @library = Library.new(self)
    @state[:agent] = @library
    @notebook = Notebook.new(self)
    attach(@library)
    attach(@notebook)
    @quit = false
  end

  def set_category(msg)
    @state[:category] = msg
  end

  def quit(msg)
    @quit = true
  end

  def attach(new_agent)
    @agents << new_agent
    new_agent.global_commands.each { |key, command|
      command.agent = new_agent
      self.class.commands[key] = command
    }
  end

  def message
    "Choose a valid command"
  end

  def put_message
    puts agent.message
    puts "--#{category}--"
    agent_commands = agent.commands.map { |key, c| "[#{key}] #{c.name}" }.join(" ")
    global_commands = commands.map { |key, c| "[#{key}] #{c.name}" }.join(" ")
    puts [agent_commands, global_commands].compact.join(" ")
  end

  def <<(msg)
    super || agent << msg || self
  end

  def agent
    @state[:agent]
  end

  def category
    @state[:category]
  end

  def go_to_library
    @state[:agent] = @library
  end

  def quit?
    @quit
  end
end

env = Env.new(ARGV[0])

loop do
  env.put_message
  input = gets
  env << input
  break if env.quit?
end
