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

class QuestionLike
  attr_accessor :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    likes = QuestionDatabase.instance.execute(<<-SQL, id: id)
      SELECT *
      FROM question_likes
      WHERE question_likes.id = :id
    SQL

    likes.map { |like| QuestionLike.new(like) }.first
  end

end
