require_relative 'database_connector'
require_relative 'database_object'

class Reply < DatabaseObject
    def self.all
        rows = DBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM replies
        SQL
        rows.map { |row| self.new(row)}
    end

    def self.find_by_user_id(id)
        rows = DBConnector.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE author_id = ?
        SQL
        rows.map {|row| Reply.new(row)}
    end

    def self.find_by_question_id(id)
        rows = DBConnector.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE question_id = ?
        SQL
        rows.map {|row| Reply.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM replies
            WHERE replies.id = :id
        SQL
        self.new(found.first)
    end
end

p Reply.find_by_question_id(3)