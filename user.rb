require_relative 'database_connector'
require_relative 'database_object'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User < DatabaseObject
    def self.all
        rows = DBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM users
        SQL
        rows.map{|row| User.new(row)}
    end
    
    def self.find_by_name(fname, lname)
        rows = DBConnector.instance.execute(<<-SQL, fname, lname)
            SELECT *
            FROM users
            WHERE fname = ? AND lname = ?
        SQL
        rows.map {|row| User.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM users
            WHERE users.id = :id
        SQL
        User.new(found.first)
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
if __FILE__ == $PROGRAM_NAME
    p User.find_by_name('Kush', 'Patel').first.authored_questions
    p User.find_by_name('Kush', 'Patel').first.authored_replies
    p User.find_by_name('Kush', 'Patel').first.followed_questions
end
