require 'sqlite3'
require 'singleton'

class ForumDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super("studentsForum.db")

        self.results_as_hash = true
        self.type_translation = true
    end
end