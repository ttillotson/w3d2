require 'sqlite3'
require 'singleton'
require_relative 'questions'
require_relative 'reply'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_reader :id
  attr_accessor :fname, :lname

  def attrs
    { fname: fname, lname: lname }
  end

  def self.all
    users = QuestionDatabase.instance.execute("SELECT * FROM users")
    users.map { |user| User.new(user) }
  end

  def self.find_by_id(id)
    user = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT *
      FROM users
      WHERE users.id = :id
    SQL

    user.map { |usr| User.new(usr) }.first
  end

  def self.find_by_name(fname, lname)
    user = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL

    user.map { |usr| User.new(usr) }.first
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end
end
