require_relative 'database_connector'
require_relative 'database_object'
require_relative 'user'
require_relative 'reply'
require_relative 'question_likes'

class Question < DatabaseObject
    def self.all
        questions = DBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM questions
        SQL
        questions.map { |row| Question.new(row)}
    end

    def self.find_by_author_id(author_id)
        result = DBConnector.instance.execute(<<-SQL, author_id)
            SELECT *
            FROM questions
            WHERE author_id = ?
        SQL
        result.map {|row| Question.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM questions
            WHERE questions.id = :id
        SQL
        Question.new(found.first)
    end

    def self.most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end
    def likers
        QuestionLikes.likers_for_question_id(id)
    end
    def num_likes
        QuestionLikes.num_likes_for_question_id(id)
    end
end

if __FILE__ == $PROGRAM_NAME
    p Question.find_by_id(1).author
    p Question.find_by_id(3).replies
    p Question.find_by_id(3).followers
end