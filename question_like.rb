require_relative 'DBConnection'

class Question_like
    attr_accessor :id, :user_id, :question_id

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.find_by_id(id)
        question_like = DBConnection.instance.execute(<<~SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL

        Question_like.new(question_like.first) unless question_like.empty?
    end

end