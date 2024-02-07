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

    def average_karma
        rows = DBConnector.instance.execute(<<-SQL, id)
            SELECT COUNT(question_likes.id) / CAST (COUNT(DISTINCT(questions.id)) AS FLOAT) AS avg_likes
            FROM question_likes
            LEFT OUTER JOIN questions ON question_id = questions.id
            GROUP BY questions.id
            HAVING questions.author_id = ?
        SQL
        rows.first['avg_likes']
    end

    def save
        unless id
            DBConnector.instance.execute(<<-SQL, fname, lname)
                INSERT INTO users (fname, lname)
                VALUES (?,?)
            SQL
            @id = DBConnector.instance.last_insert_row_id
        else
            DBConnector.instance.execute(<<-SQL, fname, lname, id)
                UPDATE users
                SET fname = ?, lname = ?
                WHERE id = ?
            SQL
        end
    end
end
if __FILE__ == $PROGRAM_NAME
    p User.find_by_name('Kush', 'Patel').first.authored_questions
    p User.find_by_name('Kush', 'Patel').first.authored_replies
    p User.find_by_name('Kush', 'Patel').first.followed_questions
    p User.find_by_name('Earl', 'Cat').first.average_karma
    User.new({'fname' => 'Andrea', 'lname' => 'Cheung'}).save
    p User.find_by_name('Andrea', 'Cheung')
end
