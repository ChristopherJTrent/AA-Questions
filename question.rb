require 'sqlite3'
require 'singleton'
class QuestionsDBConnector < SQLite3::Database
    include Singleton
    def initialize
        super('aaquestions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Question 
    def self.all
        questions = QuestionsDBConnector.instance.execute(<<-SQL)
            SELECT *
            FROM questions
        SQL
        questions.map { |row| Question.new(row)}
    end

    def self.find_by_id(id) #an integer & found is an array containing a hash result.
        found = QuestionsDBConnector.instance.execute(<<-SQL, id: id)
            SELECT *
            FROM questions
            WHERE questions.id = :id
        SQL
        Question.new(found.first)
    end

    def initialize(options) #a hash
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    
end


p Question.find_by_id(1)