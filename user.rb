require_relative 'DBConnection'

# DBConnection.instance
class User
    attr_accessor :id, :fname, :lname
    
    def self.all
        users = DBConnection.instance.execute("SELECT * FROM users")
        users.map { |user| User.new(user) }
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        user = DBConnection.instance.execute(<<~SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL

        User.new(user.first) unless user.empty?
    end

    def self.find_by_name(fname, lname)
        users = DBConnection.instance.execute(<<~SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL

        users.map { |user| User.new(user) }
    end
end