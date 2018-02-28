require 'sqlite3'
require 'singleton'
require_relative 'user'
require_relative 'questions'
# require_relative ' qfollowup'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Reply
  attr_accessor :question_id, :parent_reply_id, :author_id, :body

  def initialize(options)
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def self.find_by_user_id(id)
    reply = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT *
      FROM replies
      WHERE replies.author_id = :id
    SQL

    reply.map { |replyy| Reply.new(replyy) }.first
  end

  def self.find_by_question_id(id)
    reply = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT *
      FROM replies
      WHERE replies.question_id = :id
    SQL

    reply.map { |replyy| Reply.new(replyy) }
  end

  def self.find_by_user_id(id)
    replies = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE author_id = ?
    SQL

    replies.map { |reply| Reply.new(reply)}
  end

  def self.find_by_parent_reply(id)
    replies = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE parent_reply_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    id = (parent_reply_id - 1 == 0 ? nil : parent_reply_id - 1)

    Reply.find_by_parent_reply(id)
  end

  def child_reply
    Reply.find_by_parent_reply(parent_reply_id + 1)
  end
end
