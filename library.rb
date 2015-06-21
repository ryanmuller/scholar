require "./article"

class Library
  include Agent

  command :first, "1"
  command :second, "2"
  command :third, "3"
  global_command :library, "l"

  def initialize(env, path)
    @env = env
    @articles = Dir.glob(File.join(path, "*")).
      map { |article_path|
        Article.new(@env, article_path)
      }.
      shuffle
  end

  def library(msg)
    @env.go_to_library
  end

  def set_article(article)
    @env.state[:article] = article
    @env.state[:agent] = article
  end

  def first(msg)
    set_article(@articles[0])
  end

  def second(msg)
    set_article(@articles[1])
  end

  def third(msg)
    set_article(@articles[2])
  end

  def message
    @articles.
      first(3).
      map(&:title).
      each_with_index.
      reduce("") do |str, title_index|
        str << "[#{title_index[1]+1}] #{title_index[0]}\n"
      end
  end
end
