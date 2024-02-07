require_relative 'database_connector'
require_relative 'database_object'

class User < DatabaseObject
    def self.all
        rows = DBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM users
        SQL
        rows.map{|row| User.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM users
            WHERE users.id = :id
        SQL
        User.new(found.first)
    end
end
p User.all
p User.find_by_id(1)
p User.find_by_id(1).fname