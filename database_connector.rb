require 'sqlite3'
require 'singleton'

class DBConnector < SQLite3::Database
    include Singleton
    def initialize
        super('aaquestions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end
