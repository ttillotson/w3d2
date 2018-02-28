require 'sqlite3'
require 'singleton'
require_relative 'user'
require_relative 'questions'


class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class QuestionFollow
  attr_accessor :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    follow_up = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT *
      FROM question_follows
      WHERE question_follows.id = :id
    SQL

    follow_up.map { |f_up| QuestionFollow.new(f_up) }.first
  end

  def self.followers_for_question_id(q_id)
    users = QuestionDatabase.instance.execute(<<-SQL, q_id)
      SELECT users.id, users.fname, users.lname
      FROM question_follows
      JOIN users
        ON  users.id = question_follows.user_id
      WHERE question_id = ?

    SQL

    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(u_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, u_id)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM question_follows
    JOIN questions
      ON  questions.id = question_follows.question_id
    WHERE question_follows.user_id = ?
    SQL

    questions.map { |question| Question.new(question)}
  end
end
