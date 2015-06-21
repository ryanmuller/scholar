class Article
  include Agent

  command :next, "n"
  command :previous, "p"
  command :save_quote, "s"

  def initialize(env, file)
    @env = env
    @file = file
    @passage_reader = PassageReader.new(paragraphs, @env.state[:history][@file])
  end

  def next(msg)
    begin
      @passage_reader.next!
      @env.state[:history][@file] = @passage_reader.current_passage
    rescue PassageReader::EndOfPassages
      @env.go_to_library
    end
  end

  def previous(msg)
    @passage_reader.previous
    @env.state[:history][@file] = @passage_reader.current_passage
  end

  def save_quote(msg)
    @env.notebook << "w #{@passage_reader.read}"
  end

  def message
    @passage_reader.read
  end

  def title
    File.basename @file
    #@title ||= File.open(@file) do |f|
    #  f.readlines.each do |line|
    #    if line =~ /^title: /
    #      return line.sub(/^title: /, "").strip
    #    end
    #  end
    #end
  end

  def paragraphs
    begin
      @paragraphs ||= File.open(@file) do |f|
        #lines = f.readlines
        #prelude_end = lines.index { |line| line.strip == "---" }
        #lines[prelude_end+1..-1].join("\n").split("\n\n\n").map(&:strip)
        f.readlines.join("").split("\n\n").map(&:strip)
      end
    rescue Errno::ENOENT
      @paragraphs = [ "File does not exist." ]
    end
  end
end

class PassageReader
  attr_reader :current_passage

  def initialize(passages, start=nil)
    @passages = passages
    @current_passage = start || 0
    @size = passages.size
  end

  def read
    @passages[@current_passage]
  end

  def reset
    @current_passage = 0
  end

  def previous
    @current_passage = [@current_passage - 1, 0].max
  end

  def next
    @current_passage = [@current_passage + 1, @size].min
  end

  def next!
    @current_passage += 1

    if @current_passage == @size
      raise EndOfPassages
    end
  end

  EndOfPassages = Class.new(StandardError)
end
