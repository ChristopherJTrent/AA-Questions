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

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM replies
            WHERE replies.id = :id
        SQL
        self.new(found.first)
    end
end

p Reply.all