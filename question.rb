require_relative 'database_connector'
require_relative 'database_object'
class Question < DatabaseObject
    def self.all
        questions = DBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM questions
        SQL
        questions.map { |row| Question.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = DBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM questions
            WHERE questions.id = :id
        SQL
        Question.new(found.first)
    end

end


p Question.find_by_id(1)