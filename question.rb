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



end


