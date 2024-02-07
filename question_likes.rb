require_relative 'database_connector'
require_relative 'database_object'
require_relative 'user'

class QuestionLikes < DatabaseObject
    def self.likers_for_question_id(question_id)
        rows = DBConnector.instance.execute(<<-SQL, question_id)
            SELECT users.id as id, fname, lname
            FROM users
            JOIN question_likes ON question_likes.user_id = users.id
            WHERE question_id = ?
        SQL
        rows.map { |row| User.new(row) }
    end
    def self.num_likes_for_question_id(question_id)
        result = DBConnector.instance.execute(<<-SQL, question_id)
            SELECT COUNT(users.id) AS total
            FROM users
            JOIN question_likes ON question_likes.user_id = users.id
            WHERE question_id = ?
        SQL
        result.first['total']
    end
    def self.liked_questions_for_user_id(id)
        rows = DBConnector.instance.execute(<<-SQL, id)
            SELECT questions.id as id, title, body, author_id
            FROM questions
            JOIN question_likes ON question_id = questions.id
            WHERE question_likes.user_id = ?
        SQL
        rows.map {|row| Question.new(row)}
    end
end

if __FILE__ == $PROGRAM_NAME
    p QuestionLikes.num_likes_for_question_id(1)
    p QuestionLikes.likers_for_question_id(2)
    p QuestionLikes.liked_questions_for_user_id(2)
end