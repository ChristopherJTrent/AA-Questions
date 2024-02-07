require_relative 'database_connector'
require_relative 'database_object'
require_relative 'user'
require_relative 'question'

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
        return nil unless found.first
        self.new(found.first)
    end
    def child_replies
        rows = DBConnector.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE parent_reply_id = ?
        SQL
        rows.map{ |row| Reply.new(row) }
    end

    def author
        User.find_by_id(author_id)
    end
    def question
        Question.find_by_id(question_id)
    end
    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end
end
if __FILE__ == $PROGRAM_NAME
    p Reply.find_by_id(1).child_replies
end