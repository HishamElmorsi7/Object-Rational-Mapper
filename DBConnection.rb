require 'sqlite3'
require 'singleton'

class DBConnection < SQLite3::Database
    include Singleton

    def initialize
        super("studentsForum.db")

        self.results_as_hash = true
        self.type_translation = true
    end
end

def x
    '\n HI \n'
end