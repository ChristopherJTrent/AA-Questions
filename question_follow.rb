
require_relative 'database_object'
require_relative 'database_connector'
require_relative 'question'
require_relative 'user'

class QuestionFollow < DatabaseObject

    def self.followers_for_question_id(question_id)
        rows = DBConnector.instance.execute(<<-SQL, question_id)
            SELECT users.id AS id, fname, lname
            FROM users
            JOIN question_follows ON question_follows.user_id = users.id
            JOIN questions ON questions.id = question_follows.question_id
            WHERE questions.id = ?
        SQL
        rows.map {|row| User.new(row)}
    end

    def self.followed_questions_for_user_id(user_id)
        rows = DBConnector.instance.execute(<<-SQL, user_id)
            SELECT questions.id AS id, title, body, author_id
            FROM questions
            JOIN question_follows ON questions.id = question_id
            WHERE question_follows.user_id = ?
        SQL
        rows.map {|row| Question.new(row)}
    end

    def self.most_followed_questions(n)
        rows =DBConnector.instance.execute(<<-SQL, n)
            SELECT questions.id AS id, COUNT(question_follows.id) AS num_follows
            FROM questions
            JOIN question_follows ON questions.id = question_follows.question_id
            GROUP BY questions.id
            ORDER BY num_follows
            LIMIT ?
        SQL
        rows.map {|row| Question.find_by_id(row['id'])}
    end
end

if __FILE__ == $PROGRAM_NAME
    p QuestionFollow.most_followed_questions(1)
end