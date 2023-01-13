require_relative 'DBConnection'
require_relative 'user'

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

    def self.followers_for_question_id(question_id)
        users = DBConnection.instance.execute(<<~SQL, question_id)
            SELECT
                users.*
            FROM
                users
            INNER JOIN
                question_follows
            ON
                users.id = question_follows.user_id
            WHERE
                question_follows.question_id = ?
        SQL

        users.map { |user| User.new(user) }
    end

    def self.followed_questions_for_user_id(user_id)
        questions = DBConnection.instance.execute(<<~SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            INNER JOIN
                question_follows
            ON
                questions.id = question_follows.question_id
            WHERE
                question_follows.user_id = ?
        SQL

        questions.map { |question| Question.new(question) }
    end

    def self.most_followed_questions(n)
        questions_id = DBConnection.instance.execute(<<~SQL, n)
            SELECT
                question_id
            FROM
                question_follows
            GROUP BY
                question_id
            ORDER BY
                COUNT(user_id)
            DESC

            LIMIT ?
        SQL

        questions_id.map do |question_id|
            Question.find_by_id(question_id['question_id'])
        end
    end
end