require 'sqlite3'
require 'singleton'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_reader :id
  attr_accessor :title, :body, :author_id

  def self.all
    questions = QuestionDatabase.isntance.execute("SELECT * FROM questions")
    questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL

    question.map{ |question| Question.new(question) }.first
  end

  def self.find_by_author_id(author_id)
    question = QuestionDatabase.instance.execute(<<-SQL, author_id)
      SELECT *
      FROM questions
      WHERE author_id = ?
    SQL

    question.map { |question| Question.new(question) }
  end

  def initialize(options)
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(author_id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end
end
