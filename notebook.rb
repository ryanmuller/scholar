class Notebook
  include Agent

  command :quit, "q"
  global_command :write, "w"
  global_command :view_notes, "v"

  def initialize(env)
    @env = env
  end

  def write(msg)
    append(msg)
  end

  def view_notes(msg)
    article = Article.new(@env, file)
    @env.state[:article] = article
    @env.state[:agent] = article
  end

  private

  def append(note_text)
    File.open(file, "a") do |f|
      f.puts note_text
    end
  end

  def file
    File.join("notebooks/", "#{title}.txt")
  end

  def title
    @env.category
  end
end
