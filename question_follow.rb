require_relative 'DBConnection'

class Question_follow
    attr_accessor :id, :user_id, :question_id

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(id)
        question_follow = DBConnection.instance.execute(<<~SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL

        Question_follow.new(question_follow.first) unless question_follow.empty?
    end

end