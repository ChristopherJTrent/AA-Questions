require_relative 'database_connector'
require_relative 'database_object'
require_relative 'question'

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
end
p User.find_by_name('Kush', 'Patel').first.authored_questions